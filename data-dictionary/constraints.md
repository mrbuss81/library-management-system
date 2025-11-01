# Constraints Summary

This document lists all constraints used in the Library Book Management System schema.

| Table | Constraint | Description |
|--------|-------------|-------------|
| **Member** | PRIMARY KEY (member_id) | Ensures each member record is unique. |
| Member | CHECK (member_type IN ('Standard','Student')) | Validates allowed member types. |
| **Loan** | FOREIGN KEY (member_id) REFERENCES Member(member_id) | Enforces valid member reference. |
| Loan | FOREIGN KEY (book_id) REFERENCES Book(book_id) | Ensures valid book reference. |
| **Fine** | CHECK (amount > 0) | Ensures fine amounts are positive. |
| Fine | DEFAULT (paid_status = FALSE) | Defaults unpaid fines to false. |
| **Book** | FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_id) | Links each book to its publisher. |
| **Writes** | FOREIGN KEY (author_id) REFERENCES Author(author_id) | Connects authors and books. |
| **Reservation** | CHECK (status IN ('Pending','Completed','Cancelled')) | Restricts reservation status values. |

