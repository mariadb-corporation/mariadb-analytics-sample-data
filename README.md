# Sample Analytics Data
## Description 
This simple data set uses the [on time performance](https://www.transtats.bts.gov/homepage.asp) dataset from the *Bureau of Transportation Statistics (BTS)* for US based commercial airline flights. This includes the following 3 tables:

*   **airlines**: Dimension table for airlines (30 records)
*   **airports**: Dimension table for airports (400 records)
*   **flights**: Fact table for airline departure data (38,083,735 records)

## Prerequisite

A MariaDB server with ColumnStore enabled is required. For a quick test environment, try our [docker project](https://hub.docker.com/r/mariadb/columnstore).  

## Quick Start
### Clone The Repo
```
cd /tmp
```
```
git clone https://github.com/mariadb-corporation/mariadb-analytics-sample-data.git
```
```
cd mariadb-analytics-sample-data
```
### Run The Project
```
./run_project
```
This script will:
1. Create sample schemas(s)
2. Download flight data from our public S3 bucket
3. Load into the database
4. Offer you the ability to clone this data to InnoDB for direct comparisions with ColumnStore.

## Sample Queries
The following sample queries are provided in the [queries directory](/queries/):

1.   **1.sql** : Provides a report of flight count, market share percentage, cancelled flights percentage, and diverted flights percentage by airline for 2020.
2.   **2.sql** : Provides a report of the delay types by airline by year.
3.   **3.sql** : Provides a report of the volume and average arrival delay for California based airports by airline in 2020.
4.   **4.sql** : Provides a report of the average and maximum delay by month and hour in the day for bay area airports in 2020.
5.   **5.sql** : Provides a report of the average and maximum delay by day and hour for bay area airports in November 2020.
```
mariadb -vvv columnstore_bts < queries/1.sql
```
or
```
mariadb -vvv innodb_bts < queries/1.sql
```

## InnoDB vs ColumnStore Comparison

### Environment
|Metric                |Value                |
|:---------------------|--------------------:|
|Provider              |AWS                  |
|Instance Type         |m5.8xlarge           |
|Architecture          |x86_64               |
|CPU                   |32                   |
|RAM                   |128GB                |
|MariaDB Version       |10.6.12              |
|ColumnStore Version   |23.02.2              |
|MariaDB Exa Version   |25.1.8               |

### Data Load Times
|Engine                |Time                 |
|:---------------------|--------------------:|
|InnoDB                |19 min 10.126 sec    |
|ColumnStore*          |68.5367 sec          |
|MariaDB Exa*          |49.591 sec           |

_*Loaded via the engine's native bulk loader (not LOAD DATA INFILE)._

### Query Times

|Query                 |InnoDB*              |ColumnStore          |MariaDB Exa          |
|:--------------------:|--------------------:|--------------------:|--------------------:|
|[1](/queries/1.sql)   |27.226 sec           |0.457 sec            |0.317 sec            |
|[2](/queries/2.sql)   |1 min 24.368 sec     |1.523 sec            |0.402 sec            |
|[3](/queries/3.sql)   |6.038 sec            |0.209 sec            |0.175 sec            |
|[4](/queries/4.sql)   |6.070 sec            |0.093 sec            |0.161 sec            |
|[5](/queries/5.sql)   |18.589 sec           |0.418 sec            |0.032 sec            |    

_*Note: InnoDB tables were given indexes and a warm bufferpool._

### Disk Usage
|Engine                |Size                 |
|:---------------------|--------------------:|
|InnoDB                |14GB                 |
|ColumnStore           |2GB                  |
|MariaDB Exa           |1.4GB                |

## Conclusion

In terms of performance, both storage engines excel in different areas. InnoDB is optimized for transactional workloads, where data is frequently updated or inserted. It uses a write-ahead logging mechanism to ensure that data is always consistent and recoverable in case of a system failure. 

In contrast, ColumnStore is optimized for analytical workloads, where data is read-intensive and queries often involve aggregation and filtering operations. ColumnStore can execute these queries much faster due to its columnar design and vectorized processing.

In addition, ColumnStore also offers additional benefits such as a high-speed bulk loader and a smaller disk footprint. Unlike InnoDB, ColumnStore does not use traditional indexes, which contributes to its smaller disk footprint. Additionally, the columnar design of ColumnStore allows for higher compression ratios of data, reducing the amount of disk space required to store data. These advantages make ColumnStore a compelling add on for organizations looking to optimize their data storage and processing for analytical workloads.

Building on these analytical foundations, MariaDB Exa raises the ceiling for high-performance analytics. On this dataset, Exa loaded the data roughly 28% faster than ColumnStore, compressed it into a 1.4GB footprint — about 10x smaller than the InnoDB copy — and delivered query latencies that consistently sit comfortably below ColumnStore's, including more than 3x faster on Query 2 and an order of magnitude faster on Query 5. Beyond raw speed, MariaDB Exa includes built-in change data capture for zero-ETL replication from InnoDB — keeping the analytical copy in lockstep with the transactional source without a separate pipeline, a capability ColumnStore does not offer. Exa is also self-tuning: rather than relying on DBAs to design indexes up front, it builds and adapts its own indexes to match the incoming workload. For organizations where every millisecond and every gigabyte matters, MariaDB Exa is the high-performance option in MariaDB's analytical engine family.