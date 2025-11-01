o# Part 4 - PostgreSQL Implementation
**Author:** Michael Buss
**Date:** October 15 2025


---

## 📘 Description
This folder contains all files related to **Part 4: PostgreSQL Implementation** of the Library Book Management System (COMP230 - Assignment 1).


It includes the complete PostgreSQL schema creation, data population, index creation, and query testing.


---


## 🗂 Files
| File | Description |
|------|-------------|
| 'create-tables.sql' | Defines all tables, keys, constraints, and comments. |
| 'part4-postgresql.sql' | Runs after 'create-tables.sql'; inserts >= 5 rows per table and executes test queries. |
| 'database.sql' | Full PostgreSQL database dump generated using 'pg_dump -U postgres -d library_db'. |


---

## ⚙️ How to run
Inside PostgreSQL ('psql'):

'''sql
\i create-tables.sql
\i part4-postgresql.sql
