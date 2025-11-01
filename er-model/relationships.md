# Relationships — Library Database System
*Michael Buss*

This document defines the main relationships in the Library Database System. Each entry includes the entities involved, their cardinality and participation, and a short business rule describing how they interact.

---

| **Relationship Name** | **Entities Involved** | **Cardinality** | **Participation** | **Attributes** | **Business Rule** |
|------------------------|----------------------|-----------------|-------------------|----------------|-------------------|
| **Loans** | Member, Book, Staff | Ternary (M:N:N) | All Mandatory | loan_date, due_date, return_date | Members borrow Books processed by Staff. A Book can only be on loan to one Member at a time. |
| **Reservation** | Member ↔ Book | M:N | Both Mandatory | reservation_date, status | Members can reserve multiple Books, and Books can have many Reservations. Each starts with status 'Pending'. |
| **Fine_assigned** | Member ↔ Fine | 1:N | Member Optional, Fine Mandatory | amount, paid_status | Each Fine belongs to one Member. A Member can have many Fines, all default to 'Unpaid'. |
| **Publishes** | Publisher ↔ Book | 1:N | Publisher Optional, Book Mandatory | — | Each Book is published by one Publisher, while a Publisher may produce many Books. |
| **Writes** | Author ↔ Book | M:N | Both Mandatory | — | Authors can write multiple Books, and Books can have multiple Authors. |

---

## Business Rules Summary

1. Every Loan includes one Member, one Book, and one Staff member.  
2. Books can only be borrowed or reserved if they exist in the catalog.  
3. Members may have multiple Loans, Reservations, and Fines.  
4. Each Fine belongs to a single Member and defaults to 'Unpaid'.  
5. Each Reservation starts as 'Pending' and updates when fulfilled or cancelled.  
6. A Book’s availability changes to 'Checked Out' when on loan.  
7. Publishers and Authors must exist before Books can reference them.  
8. Deleting a Member removes their Reservations and Fines.  

---

> **Note:**  
> The **Loans** relationship connects Members, Books, and Staff as a ternary relationship. This design captures all loan information (dates and participants) in a single relationship instead of using separate linking tables.

---



