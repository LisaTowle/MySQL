# Partition maintenance for MySQL tables

## Procedure functions
* create_partitions_by_month
* drop_partitions_by_month
* export_partitions_by_month

## Usage

```
call create_partitions_by_month (<sequence no>, <table_schema>, <table_name>, <start partition YYYY_MM>, <end partition YYYY_MM>, <parition key>, <dry run flag>);
call drop_partitions_by_month (<sequence no>, <table_schema>, <table_name>, <start partition YYYY_MM>, <end partition YYYY_MM>, <parition key>, <dry run flag>);
call export_partitions_by_month (<sequence no>, <table_schema>, <table_name>, <start partition YYYY_MM>, <end partition YYYY_MM>, <parition key>);
```
* sequence no: this can be used where the parameters for multiple tables are stored in a file
* table_schema: database/schema name where the partitioned table resides
* table_name: name of the partitioned table
* starting year and month for the partitioning activity, in YYYY_MM format
* ending year and month for the partitioning activity, in YYYY_MM format
* partition key column

## Examples

```
call create_partitions_by_month (1,'fin_data','orders','2025_01','2025_13','order_date',1);
call create_partitions_by_month (1,'fin_data','orders','2025_01','2025_13','order_date');
call drop_partitions_by_month (1,'fin_data','orders','2025_01','2025_13','order_date');
call export_partitions_by_month (1,'fin_data','orders','2025_01','2025_13','order_date');
```
