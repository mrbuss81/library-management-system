# Normalization - Library Database System
**Author:** Michael Buss
**Course:** COMP230
**Instructor:** Carl Janzen
**Date:** October 13 2025

---

## 1. First Normal Form (1NF) Verification

The initial ER model was designed with 1NF principles in mind, so **no explicit 1NF violations** were found.  
However, this section documents how the design ensures compliance with 1NF and how potential violations were avoided.

### **1.1 1NF Requirements**
To satisfy First Normal Form:
- Each attribute must hold **atomic (indivisible)** values.  
- Each record (tuple) must be **uniquely identifiable** by a key.  
- There must be **no repeating groups or arrays** of data.

### **1.2 Verification in the Library Database**

| Potential Issue | Example | Resolution |
|------------------|----------|-------------|
| **Multi-valued attribute** | A Book having multiple Authors | Modeled using a separate **Writes** relationship (M:N) between `Author` and `Book`. |
| **Composite attribute** | Member’s name (first, last) | Stored as separate atomic fields: `first_name`, `last_name`. |
| **Repeating groups** | A Member borrowing multiple Books | Replaced by the **Loans** relationship (ternary: Member–Book–Staff). |
| **Non-unique rows** | Missing identifiers | Every entity defined with a **primary key** (e.g., `book_id`, `member_id`, `loan_id`). |

### **1.3 Conversion Summary**

Because the ERD was created using atomic attributes and relationship entities from the start,  
the design already satisfied 1NF. No decomposition was needed at this stage —  
the model naturally enforces atomicity and unique identification.

✅ Therefore, the **Library Database** began in **First Normal Form** by design.


---


## 2. Functional Dependencies (FD's)

Functional dependencies describe how one attribute (or set of attributes) determines another.
Below are the main FD's derived from the schema.

### **1.1 Book**

- 'book_id -> title, isbn, availability_status, publication_year, publisher_id'
- 'isbn -> book_id, title, availability_status, publication_year, publisher_id'
- (Each ISBN uniquely identifies a Book)

### **1.2 Publisher**

- 'publisher_id -> name, email'

### **1.3 Author**

- 'author_id -> name, email'

### **1.4 Member**

- 'member_id -> name, email, join_date, member_type'

### **1.5 Staff**

- 'staff_id -> name, email, start_date, role'

### **1.6 Loan (ternary relationship between Member, Staff, Book)**

- '{member_id, book_id, staff_id} -> loan_date, due_date, return_date'
- 'loan_id -> member_id, book_id, staff_id, loan_date, due_date, return_date'

### 1.7 Reservation**

- 'reservation_id -> member_id, book_id, reservation_date, status'
- '{member_id, book_id} -> reservation_id, reservation_date, status'

### 1.8 Fine**

- 'fine_id -> member_id, amount, paid_status'
- 'member_id -> amount, paid_status' (for simplicity, 1 fine at a time)


---

## 3. Normal Forms Overview

Normalization organizes data to minimize redundancy and dependency anomalies.
We verify each table against **1NF**, **2NF**, and **3NF**.


### **1NF - Atomic Attributes**
Each field contains only indivisibe values.

All entites ('Book', 'Member', 'Loan', etc.) already meet 1NF
No multi-valued or repeating attributes.


---


### **2NF - Eliminate Partial Dependencies**
Every non-key attribute must depend on the **whole primary key**, not part of it.

All entities except the ternary 'Loan' are already in 2NF.
For 'Loan', dependencies like 'loan_date' depend on the *entire* composite '{member_id, book_id, staff_id}', not just part of it.
So therefor 'Loan' will satisfy 2NF (no partial dependancies)


---


### **3NF - Eliminate Transitive Dependencies**
No non-key attribute should depend on another non-key attribute.

| Entity | Check | Reason |
|--------|-------|--------|
| **Book** | ✅ | 'publisher_id' is a foreign key; 'Publisher' details are stored seperately. No partial or transitive dependencies. |
| **Publisher** | ✅ | All attribute depend directly on 'publisher_id'. No redundancy across the books. |
| **Author** | ✅ | Attributes depend only on 'author_id'; relationship with 'Book' is handled by the M:N 'Writes' table. |
| **Member** | ✅ | Attributes depend only on 'member_id'; no transitive dependancies. |
| **Staff** | ✅ | Attributes depend only on 'staff_id'; role and start date are atomic and independent. |
| **Loan** | ✅ | Loan attributes ('loan_date', 'due_date', 'return_date') depend on the composite key {'member_id', 'book_id', 'staff_id'}. |
| **Reservation** | ✅ | 'status' and 'reservation_date depend on 'reservation_id' or {'member_id', 'book_id'}. no transitive dependencies. |
| **Fine** | ✅ | 'amount' and 'paid_status' depend on 'fine_id'. 'member_id' is a foreign key only. |

✅ Therefore, the database is fully normalized to **Third Normal Form (3NF)**.

---

## 4. Decomposition Examples

If transitive or partial dependencies existed, we would **decompose** a table to fix it.



### Example 1 - Book and Publisher (1:N relationship) 

**Before:**

Book(book_id, title, isbn, availability_status, publication_year, publisher_name,publisher_email)

**Problem:**
Publisher details ('publisher_name', 'publisher_email') depend on the Publisher, not the Book, creating a **transitive dependancey**

**After:**

Book(book_id, isbn, availability_status, publication_year)
Publisher(publisher_id, name, email)


---

### Example 2 - Loan and Staff (M:N relationship)

**Before:** 

Loan(loan_id, member_id, book_id, staff_id, staff_name, loan_date, due_date, return_date)

**Problem:** 
Staff details ('staff_id, 'staff_name') depend on the staff and not the Loan.


**After:**

Loan(loan_id, book_id, member_id, staff_id, loan_date, due_date, return_date)
Staff(staff_id, name, email, role, start_date)


---

### Example 3 - Reservation (partial dependency)

**Before:** 

Reservation(member_id, book_id, reservation_date, status, member_name)

**Problem:**  
`member_name` depends only on `member_id`, not on the full composite key `{member_id, book_id}` — this is a **partial dependency**.

**After:**

Reservation(member_id, book_id, reservation_date, status)
Member(member_id, name, email, join_date, member_type)


---



## **5. Armstrong's Axioms**

Armstrong's Axioms define how new functional dependencies (FD's) can be logically derived from existing ones.
They are the theoretical foundation that ensures the correctness of decomposition and normalization.

### **5.1 Core Axioms**

| Axiom | Definition | Example (Library DB Context) |
|-------|------------|------------------------------|
| **Reflexivity** | if Y is a subset of X, then X -> Y | Since 'book_id' is the subset of {'book_id'}, it follows that 'book_id -> book_id'. |
| **Augmentation** | If X -> Y, then XZ -> YZ for any Z | if 'book_id -> title', then 'book_id, member_id -> title, member_id'. |
| **Transitivity** | If X -> Y -> Z, then X -> Z | if 'publisher_id -> name' and 'name -> email', then publisher_id -> email', |

These 3 axioms allow us to **derive all other valid dependencies** in a schema.


---


### **5.2 Derived Rules**

| Rule | Derived From | Meaning |
|------|--------------|---------|
| **Union** | Augmentaion + Transivity | If 'X -> Y' and 'X -> Z', then 'X -> YZ'. |
| **Decomposition** | Reflexivity | If 'X -> YZ', then 'X -> Y' and 'X -> Z'. |
| **Pseudo-Transitivity** | Transitivity | If 'X -> Y' and 'YW -> Z', then 'XW -> Z'. |


---

## **5.3 Application to this Design**

- During decomposition (e.g., splitting **Book** and **Publisher**), the axioms ensure that **FDs are preserved**.
- The closure of attributes ('X+') was used conceptually to verify **lossless joins** between decomposed relations.
- Because all dependancies in this schema can be derived using these axioms, the **design is dependancy-preserving** and fully **normalized to 3NF**.

✅ **Conclusion:**

Armstrong's Axioms formally justify that the normalization process in the Library Database preserves all functional dependencies while eliminating redundancy.

## **6. Summary & Reflection**

The normalization process confirmed that the **Library DataBase System** is fully normalized to **Third Normal Form (3NF)**.
All entities and relationships were verified to depend solely on their respective keys, with no partial or transitive dependencies remaining.

By applying **functional dependency analysis**, **decomposition**, and **Armstrong's Axioms**, the final schema:
- Ensures **data integrity** and **consistency**.
- Prevents **update, insertion, and deletion anomalies**.
- Maintains **dependency preservation** and **lossless joins**.

This process validated that the database design-originally modeled in the ER diagram-was conceptually sound and logically optimized.
The resulting structure supports efficient queries and scalable data management for all library operations.  

























































































