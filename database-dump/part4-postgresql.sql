-- ===========================================================================
-- COMP230 - Assignment 1 - Part 4
-- PostgreSQL Implementation and Testing
-- Author: Michael Buss
-- Date: October 15 2025
--
-- Description:
-- This script builds upon create-tables.sql and fulfills Part 4 requirements:
-- 	* Creates indexes for all foreign keys
--	* Inserts sample data (>= 5 rows per table)
-- 	* Demonstrates JOINS, aggregates, GROUP BY + HAVING, and subqueries
-- 	* Prepares for final database dump (pg_dump)
-- ===========================================================================


-- Load the schema
\i create-tables.sql


-- ===========================================================================
-- 1. CREATE INDEXES FOR FOREIGN KEYS
-- ===========================================================================

CREATE INDEX idx_book_publisher_id	ON Book(publisher_id);
CREATE INDEX idx_writes_author_id	ON Writes(author_id);
CREATE INDEX idx_writes_book_id		ON Writes(book_id);
CREATE INDEX idx_loan_member_id		ON Loan(member_id);
CREATE INDEX idx_loan_book_id		ON Loan(book_id);
CREATE INDEX idx_loan_staff_id		ON Loan(staff_id);
CREATE INDEX idx_reservation_member_id	ON Reservation(member_id);
CREATE INDEX idx_reservation_book_id	ON Reservation(book_id);
CREATE INDEX idx_fine_member_id		ON Fine(member_id);
CREATE INDEX idx_fine_loan_id		ON Fine(loan_id);

-- ===========================================================================
-- 2. INSERT SAMPLE DATA
-- ===========================================================================


-- Publishers (5)
INSERT INTO Publisher (name, email) VALUES
('Publisher A', 'pubA@example.com'),
('Publisher B', 'pubB@example.com'),
('Publisher C', 'pubC@example.com'),
('Publisher D', 'pubD@example.com'),
('Publisher E', 'pubE@example.com');

-- Authors (5)
INSERT INTO Author (name, email) VALUES
('Author A', 'authorA@example.com'),
('Author B', 'authorB@example.com'),
('Author C', 'authorC@example.com'),
('Author D', 'authorD@example.com'),
('Author E', 'authorE@example.com');

-- Staff (5)
INSERT INTO Staff (name, email, role, start_date) VALUES
('Staff A', 'staffA@library.ca', 'Librarian', '2023-01-10'),
('Staff B', 'staffB@library.ca', 'Assistant', '2023-05-12'),
('Staff C', 'staffC@library.ca', 'Manager', '2024-02-01'),
('Staff D', 'staffD@library.ca', 'Librarian', '2024-04-20'),
('Staff E', 'staffE@library.ca', 'Assistant', '2024-06-15');

-- Books (5)
INSERT INTO Book (title, isbn, publication_year, availability_status, publisher_id) VALUES
('Book A', '9780000000001', 2001, 'Available', 1),
('Book B', '9780000000002', 2005, 'Available', 2),
('Book C', '9780000000003', 2010, 'Available', 3),
('Book D', '9780000000004', 2015, 'Available', 4),
('Book E', '9780000000005', 2020, 'Available', 5);


-- Writes (5 links, 1-to-1 for simplicity)
INSERT INTO Writes (author_id, book_id) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);


-- Members (6)
INSERT INTO Member (name, email, member_type, join_date) VALUES
('Member A', 'memberA@example.com', 'Standard', '2024-01-01'),
('Member B', 'memberB@example.com', 'Student', '2024-02-15'),
('Member C', 'memberC@example.com', 'Faculty', '2024-03-10'),
('Member D', 'memberD@example.com', 'Standard', '2024-04-20'),
('Member E', 'memberE@example.com', 'Student', '2024-05-05'),
('Member F', 'memberF@example.com', 'Standard', '2025-01-01');


-- Loans (6)
INSERT INTO Loan (member_id, book_id, staff_id, loan_date, due_date, return_date) VALUES
(1,1,1,'2025-09-01','2025-09-15','2025-09-12'),
(2,2,2,'2025-09-05','2025-09-19','2025-09-18'),
(3,3,3,'2025-09-10','2025-09-24',NULL),
(4,4,4,'2025-09-12','2025-09-26',NULL),
(5,5,5,'2025-09-15','2025-09-29','2025-09-25'),
(1, 2, 1, '2025-10-05', '2025-10-20', NULL);


-- Reservations (6)
INSERT INTO Reservation (member_id, book_id, status, reservation_date) VALUES
(1,3,'Pending','2025-10-01'),
(2,4,'Fulfilled','2025-10-02'),
(3,1,'Cancelled','2025-10-03'),
(4,2,'Pending','2025-10-04'),
(5,5,'Pending','2025-10-05'),
(6, 3, 'Pending', '2025-10-10');


-- Fines (6)
INSERT INTO Fine (member_id, loan_id, amount, paid_status, fine_date) VALUES
(1,1,3.50,TRUE,'2025-09-16'),
(2,2,1.75,FALSE,'2025-09-20'),
(3,3,5.00,FALSE,'2025-09-25'),
(4,4,2.25,TRUE,'2025-09-28'),
(5,5,4.00,FALSE,'2025-09-30'),
(1, 6, 2.00, FALSE, '2025-10-25');


-- ===========================================================================
-- 3. TEST QUERIES (5 total)
-- ===========================================================================


-- 1. JOIN across multiple tables
SELECT m.name AS member, b.title, s.name AS staff, l.loan_date
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id
JOIN Staff s ON l.staff_id = s.staff_id;

-- 2. Aggregate: count of books per publisher
SELECT p.name AS publisher, COUNT(b.book_id) AS total_books
FROM Publisher p
LEFT JOIN Book b ON p.publisher_id = b.publisher_id
GROUP BY p.name;

-- 3. GROUP BY + HAVING: members with more than one loan
SELECT m.name, COUNT(l.loan_id) AS num_loans
FROM Member m
JOIN Loan l ON m.member_id = l.member_id
GROUP BY m.name
HAVING COUNT(l.loan_id) > 1;

-- 4. Aggregate SUM: total fines per member
SELECT m.name, SUM(f.amount) AS total_fines
FROM Member m
JOIN Fine f ON m.member_id = f.member_id
GROUP BY m.name;

-- 5. Subquery: members who reserved but have not borrowed
SELECT name
FROM Member
WHERE member_id IN (
    SELECT member_id
    FROM Reservation
    WHERE member_id NOT IN (SELECT member_id FROM Loan)
);

-- ===========================================================================
-- 4. FINAL STEP: DATABASE DUMP INSTRUCTION
-- ===========================================================================
-- To export your entire database (schema + data), run in terminal:
--   pg_dump -U postgres -d library_db > library_db_dump.sql
-- ============================================================================
