delimiter //

CREATE PROCEDURE drop_partitions_by_month
(IN int_id int(11),
IN in_table_schema varchar(64),
IN in_table_name varchar(64),
IN in_partition_begin_month varchar(7),
IN in_partition_end_month varchar(7),
IN in_partitioning_key varchar(64),
IN in_dry_run tinyint
)

ProcExit:BEGIN

  DECLARE loop_cnt tinyint;
  DECLARE limit_cnt tinyint;
  DECLARE partition_count tinyint;
  DECLARE max_value varchar(8);
  DECLARE begin_partition varchar(64);
  DECLARE end_partition varchar(64);
  DECLARE drop_partition varchar(64);

  If in_partition_begin_month not regexp '[20][0-9][0-9][_][01-12]' THEN
     select 'ERROR: Begin month not in format YYYY_MM';
     LEAVE ProcExit;
  end if;

  If in_partition_end_month not regexp '[20][0-9][0-9][_][01-12]' THEN
     select 'ERROR: End month not in format YYYY_MM';
     LEAVE ProcExit;
  end if;


  if in_partition_begin_month > in_partition_end_month THEN
     select 'ERROR: Begin month is greater than end month';
     LEAVE ProcExit;
  end if;

  if in_dry_run NOT IN (0,1) THEN
     select 'ERROR: dry run must be 0 or 1';
     LEAVE ProcExit;
  end if;

  SET begin_partition = CONCAT('PART_' , in_table_name , '_' , in_partition_begin_month);
  SET end_partition   = CONCAT('PART_' , in_table_name , '_' , in_partition_end_month);

  SET max_value = 'MAXVALUE';
  SET partition_count = 0;
  SET loop_cnt = 0;

  select count(*) into partition_count
  from information_schema.partitions
  where table_schema = in_table_schema
  and table_name = in_table_name
  and partition_description != max_value
  and partition_name between begin_partition and end_partition;

  if  partition_count = 0 THEN
      select 'ERROR: No partitions found to drop';
      LEAVE ProcExit;
  end if;

  while partition_count > 0 do

      if in_dry_run = 1 THEN
         SET limit_cnt = loop_cnt;
      ELSE
         SET limit_cnt = 0;
      end if;

      select partition_name
        into drop_partition
      from information_schema.partitions
      where table_schema = in_table_schema
      and table_name = in_table_name
      and partition_name between begin_partition and end_partition
      and partition_description != max_value
      order by partition_description asc limit limit_cnt, 1;


      select concat('ALTER TABLE ', in_table_schema, '.', in_table_name, ' DROP PARTITION  ', drop_partition,';')
      into @drop_monthly_partition_alter_text;

      select @drop_monthly_partition_alter_text;
      if in_dry_run = 0 THEN
          prepare stmt from @drop_monthly_partition_alter_text;
          execute stmt;
          deallocate prepare stmt;
      end if;

      SET loop_cnt = loop_cnt + 1;
      SET partition_count = partition_count - 1;

  end while;

END
//

delimiter ;