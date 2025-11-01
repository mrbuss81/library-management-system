# Relational Schema - Library Database System
**Author:** Michael Buss
**Course:** COMP230 (Database and Database Management Systems)
**Date:** October 13 2025


---


## Overview
This document presents the **relational schema** derived from the final ER diagram.
Each entity and relationship has been translated into a table with attributes, keys, and constraints.


---


## Table Definitions



## 1. Member
**Attributes:**

- member_id (PK)
- name
- email
- join_date
- member_type


**Notes:** Each member can make reservations, borrow books and receive fines.


---


### 2. Staff
**Attributes:**

- staff_id (PK)
- name
- email
- start_date
- role

**Notes:** Each staff member can loan books, make reservations and issue fines.


---

### 3. Book 
**Attributes:**

- book_id (PK)
- title 
- isbn (UNIQUE)
- publisher_id (FK)
- availability_status
- publication_year

**Notes:** A book can be loaned or reserved; each is linked to one publisher.


---


### 4. Author
**Attributes:**

- author_id (PK)
- name 
- email

**Notes:** Connected to Book through a many to many relationship (Writes).


---


### 5. Publisher
**Attributes:**

- publisher_id (PK)
- name 
- email


**Notes:** Each publisher can be associated with multiple books, 
but every book is published by only one publisher. 
This will for a **1:N** relationship (Publisher -> Book) via the 'publisher_id' (FK) in the Book table.


---


### 6. Reservation
**Attributes:**

- reservation_id (PK)
- member_id (FK)
- book_id (FK)
- reservation_date
- status


**Notes:** Members can reserve books; status {Pending, Fulfilled, Cancelled}.


---


### 7. Fine
**Attributes:**

- fine_id (PK)
- member_id (FK)
- amount
- paid_status


**Notes:** Fines belong to a single member; paid status {Paid, Unpaid}


---


### 8. Loan
**Attributes:**

- loan_id (PK)
- member_id (FK)
- book_id (FK)
- staff_id (FK)
- loan_date
- due_date
- return_date


**Notes:** This is a Ternary relationship capturing who processed each loan, and which book/member it involved.


---


## Referential Integrity Summary

- Book.publisher_id -> Publisher.publisher_id
- Loan.member_id -> Member.member_id
- Loan.staff_id -> Staff.staff_id
- Loan.book_id -> Book.book_id
- Fine.member_id -> Member.member_id
- Reservation.member_id -> Member.member_id
- Reservation.book_id -> Book.book_id


---



