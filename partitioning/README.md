# Partition maintenance for MySQL tables

## Procedure functions
* create_partitions_by_month
* drop_partitions_by_month
* export_partitions_by_month

## Usage

```
call create_partitions_by_month (<sequence no>, <table_schema>, <table_name>, <start partition YYYY_MM>, <end partition YYYY_MM>, <parition key>)
```

## Examples

```
call create_partitions_by_month (1,'fin_data','orders','2025_01','2025_13','order_date');
```
