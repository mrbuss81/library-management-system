# Data Dictionary — Entities
*Library Database System* — Michael Buss  

Entity names match the ERD (capitalized), while attributes use lowercase `snake_case` for SQL consistency.  
This dictionary lists all entities, their key attributes, and example values.  

---

| **Entity Name** | **Description** | **Attributes (Name, Type, Constraints)** | **Keys** | **Nullable?** | **Example Values** |
|-----------------|-----------------|------------------------------------------|-----------|----------------|--------------------|
| **Book** | Stores information about each book in the library’s catalog. | **book_id** (INT, NOT NULL), title (VARCHAR(100), NOT NULL), isbn (CHAR(13), UNIQUE, NOT NULL), availability_status (VARCHAR(20), NOT NULL, DEFAULT 'Available', CHECK (availability_status IN ('Available','Checked Out','Reserved'))), publication_year (YEAR, NOT NULL, CHECK (publication_year BETWEEN 1500 AND 2100)) | PK: book_id | All: No | *(1, "Dune", "9780441172719", "Available", 2010)* |
| **Publisher** | Represents the publishers responsible for producing books. | **publisher_id** (INT, NOT NULL), name (VARCHAR(100), NOT NULL), email (VARCHAR(100), NOT NULL) | PK: publisher_id | All: No | *(10, "Penguin Books", "contact@penguin.ca")* |
| **Author** | Stores details about authors who have written one or more books. | **author_id** (INT, NOT NULL), name (VARCHAR(100), NOT NULL), email (VARCHAR(100)) | PK: author_id | `email` = Yes | *(1, "Frank Herbert", "frank.herbert@email.com")* |
| **Reservation** | Tracks book reservations made by members. | **reservation_id** (INT, NOT NULL), status (VARCHAR(20), NOT NULL, DEFAULT 'Pending', CHECK (status IN ('Pending','Fulfilled','Cancelled'))), reservation_date (DATE, NOT NULL, DEFAULT CURRENT_DATE) | PK: reservation_id | All: No | *(1, "Pending", "2025-03-02")* |
| **Member** | Represents registered library users who borrow or reserve books. | **member_id** (INT, NOT NULL), name (VARCHAR(100), NOT NULL), email (VARCHAR(100), NOT NULL), join_date (DATE, NOT NULL, DEFAULT CURRENT_DATE), member_type (VARCHAR(20), NOT NULL, DEFAULT 'Standard', CHECK (member_type IN ('Standard','Faculty','Guest'))) | PK: member_id | All: No | *(100, "Alice Turner", "alice.turner@ufv.ca", "2025-01-10", "Standard")* |
| **Fine** | Records any fines issued to members for overdue or damaged books. | **fine_id** (INT, NOT NULL), amount (DECIMAL(6,2), NOT NULL), paid_status (VARCHAR(20), NOT NULL, DEFAULT 'Unpaid', CHECK (paid_status IN ('Paid','Unpaid'))) | PK: fine_id | All: No | *(1, 15.00, "Unpaid")* |
| **Staff** | Stores information about library staff who manage loans and member activities. | **staff_id** (INT, NOT NULL), name (VARCHAR(100), NOT NULL), email (VARCHAR(100), NOT NULL), start_date (DATE, NOT NULL, DEFAULT CURRENT_DATE), role (VARCHAR(20), NOT NULL, DEFAULT 'Librarian') | PK: staff_id | All: No | *(1, "John Nguyen", "john.nguyen@library.ca", "2022-08-01", "Librarian")* |

---

> **Default Values:**  
> - `availability_status` defaults to `'Available'`  
> - `member_type` defaults to `'Standard'`  
> - `join_date`, `start_date`, and `reservation_date` default to the current date  
> - `paid_status` defaults to `'Unpaid'`  
> - `status` (Reservation) defaults to `'Pending'`  
> - `role` (Staff) defaults to `'Librarian'`

---

## Metadata Summary

| **Metadata Type** | **Details** |
|--------------------|-------------|
| **Data Sources** | Information entered by library staff during cataloging, member registration, and daily circulation operations. |
| **Update Frequency** | Real-time for loans, fines, and reservations; periodic for member and book records. |
| **Privacy / Security** | Member and Staff emails classified as **confidential**; accessible only to authorized personnel. |
| **Valid Value Ranges / Enumerations** | `availability_status` ∈ {‘Available’, ‘Checked Out’, ‘Reserved’}; `paid_status` ∈ {‘Paid’, ‘Unpaid’}; `member_type` ∈ {‘Standard’, ‘Faculty’, ‘Guest’}; `status` ∈ {‘Pending’, ‘Fulfilled’, ‘Cancelled’} |

