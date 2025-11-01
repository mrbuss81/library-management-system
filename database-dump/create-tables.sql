-- ==========================================================================
-- COMP230 - Assignment 1
-- Library Book Management
-- Author: Michael Buss
-- Date: October 15 2025
--
-- Description:
-- This SQL script creates all tables required for the Library
-- Book Management System. It defines entity structures, primary keys,
-- foreign keys, and relevant constraints for data integrity.
--
-- Run this script using:
--   psql -U postgres -d library_db -f create-tables.sql
-- ==========================================================================


-- ==========================================================================
-- CLEANUP SECTION (DROP TABLES IN REVERSE ORDER)
-- Ensures a clean rebuild by removing existing table if present.
-- ==========================================================================


DROP TABLE IF EXISTS Fine CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Loan CASCADE;
DROP TABLE IF EXISTS Writes CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Member CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Author CASCADE;
DROP TABLE IF EXISTS Publisher CASCADE;



-- ==========================================================================
-- TABLE: Publisher
-- Stores information about book publishers.
-- Each publisher may be associated with many books.
-- ==========================================================================


CREATE TABLE Publisher (
    publisher_id SERIAL PRIMARY KEY,		-- Unique ID (auto-incrementing)
    name VARCHAR(100) NOT NULL,			-- Publisher name (required)
    email VARCHAR(100) NOT NULL,		-- Publisher contact email (required)
    CHECK (email LIKE '%@%.%')			-- Basic email validation pattern
);

COMMENT ON TABLE PUBLISHER IS 'Stores publisher details for the library system.';
COMMENT ON COLUMN Publisher.name IS 'Name of the publishing company.';
COMMENT ON COLUMN Publisher.email IS 'Contact email address for the publisher.';

-- ===========================================================================
-- TABLE: Author
-- Stores details about authors who have written one or more books.
-- ===========================================================================


CREATE TABLE Author (
    author_id SERIAL PRIMARY KEY, 		-- Unique ID for each author
    name VARCHAR(100) NOT NULL,			-- Author's full name
    email VARCHAR(100) UNIQUE,			-- Optional, must be unique if used
    CHECK (email IS NULL OR email LIKE '%@%.%') -- Valid email format if provided
);

COMMENT ON TABLE Author IS 'Stores author information, including name and optional email.';
COMMENT ON COLUMN Author.name IS 'Full name of the author.';
COMMENT ON COLUMN Author.email IS 'Email address of the author (unique if provided).';

-- ===========================================================================
-- TABLE: Staff
-- Stores information about library staff who manage loans and reservations.
-- ===========================================================================


CREATE TABLE Staff (
    staff_id SERIAL PRIMARY KEY,				-- Unique ID
    name VARCHAR(100) NOT NULL,					-- Full name
    email VARCHAR(100) NOT NULL UNIQUE,				-- Unique staff email
    role VARCHAR(100) DEFAULT 'Librarian' NOT NULL,		-- Default role
    start_date DATE DEFAULT CURRENT_DATE, 			-- Defaults to current date
    CHECK (role IN ('Librarian', 'Assistant', 'Manager'))	-- Valid roles only
);

COMMENT ON TABLE Staff IS 'Stores library staff details, including role and start date.';
COMMENT ON COLUMN Staff.role IS 'Job title or position (default Librarian).';
COMMENT ON COLUMN Staff.start_date IS 'Date when the staff member started employment.';

-- ===========================================================================
-- TABLE: Book
-- Stores information about each book in the library's catalog.
-- ===========================================================================


CREATE TABLE Book (
    book_id SERIAL PRIMARY KEY,					-- Unique book id
    title VARCHAR(150) NOT NULL,  				-- Book title
    isbn CHAR(13) UNIQUE NOT NULL,				-- 13-digit ISBN
    publication_year INT CHECK (publication_year >= 1400 AND publication_year <= EXTRACT(YEAR FROM CURRENT_DATE)), -- Valid year
    availability_status VARCHAR(20) DEFAULT 'Available'
	CHECK (availability_status IN ('Available', 'Checked Out', 'Reserved')), -- FK link to Publisher
    publisher_id INT REFERENCES Publisher(publisher_id)
	ON DELETE SET NULL
);

COMMENT ON TABLE Book IS 'Stores library catalog information, including publisher and availability.';
COMMENT ON COLUMN Book.isbn IS 'Unique 13-digit ISBN for the book.';
COMMENT ON COLUMN Book.availability_status IS 'Tracks whether a book is available, checked out or reserved.';

-- ===========================================================================
-- TABLE: Writes
-- Links Authors and Books (M:N relationship).
--============================================================================

CREATE TABLE Writes (
    author_id INT NOT NULL REFERENCES Author(author_id)
	ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES Book(book_id)
	ON DELETE CASCADE,
    PRIMARY KEY (author_id, book_id)
);

COMMENT ON TABLE Writes IS 'Associates authors with books they have written.';
COMMENT ON COLUMN Writes.author_id IS 'Foreign key linking to Author table.';
COMMENT ON COLUMN Writes.book_id IS 'Foreign key linking to Book table.';

-- ===========================================================================
-- TABLE: Member
-- Represents registered library user who borrow or reserve books.
-- ===========================================================================


CREATE TABLE Member (
    member_id SERIAL PRIMARY KEY,			-- Unique ID for each member
    name VARCHAR(100) NOT NULL,				-- Full name
    email VARCHAR(100) NOT NULL UNIQUE,			-- Unique email address
    join_date DATE DEFAULT CURRENT_DATE,		-- Date joined
    member_type VARCHAR(20) DEFAULT 'Standard'		
	CHECK (member_type IN ('Standard', 'Faculty', 'Student')) -- Valid member type
);

COMMENT ON TABLE Member IS 'Stores information about registered library members.';
COMMENT ON COLUMN Member.member_type IS 'Defines member category: Standard, Faculty, or Student.';
COMMENT ON COLUMN Member.join_date IS 'Date when the member joined the library.';

-- ===========================================================================
-- TABLE: Loan
-- Represents the ternary relationship between Member, Book, and Staff.
-- Tracks all book borrowing transactions.
-- ===========================================================================


CREATE TABLE Loan (
    loan_id SERIAL PRIMARY KEY,				-- Unique loan record
    member_id INT NOT NULL REFERENCES Member(member_id)
	ON DELETE CASCADE,				-- Remove loan if member deleted
    book_id INT NOT NULL REFERENCES Book(book_id)
	ON DELETE RESTRICT,				-- Prevent deleting a book on loan
    staff_id INT NOT NULL REFERENCES Staff(staff_id)
	ON DELETE SET NULL,				-- Staff may leave; loan record stays
    loan_date DATE DEFAULT CURRENT_DATE,		-- Date loan was made
    due_date DATE NOT NULL,				-- Must return by this date
    return_date DATE,					-- Actual date returned
    CHECK (due_date >= loan_date)			-- Due date cannot be before the loan date
);

COMMENT ON TABLE Loan IS 'Tracks loans of books from members, processed by staff.';
COMMENT ON COLUMN Loan.due_date IS 'The date when the book is due for return.';
COMMENT ON COLUMN Loan.return_date IS 'The date when the book was actually returned.';

-- ===========================================================================
-- TABLE: Reservation
-- Tracks book reservations made by members.
-- ===========================================================================


CREATE TABLE Reservation (
    reservation_id SERIAL PRIMARY KEY,			-- Unique reservation record
    member_id INT NOT NULL REFERENCES Member(member_id)
	ON DELETE CASCADE,				-- Delete reservation if member removed
    book_id INT NOT NULL REFERENCES Book(book_id)
	ON DELETE CASCADE,				-- Delete reservation if book removed
    reservation_date DATE DEFAULT CURRENT_DATE,		-- Auto-fill with current date
    status VARCHAR(20) DEFAULT 'Pending'
	CHECK (status IN ('Pending', 'Fulfilled', 'Cancelled')) -- Valid reservation states
);

COMMENT ON TABLE Reservation IS 'Tracks member reservations for specific books.';
COMMENT ON COLUMN Reservation.status IS 'Reservation status: Pending, Fulfilled, or Cancelled.';
COMMENT ON COLUMN Reservation.reservation_date IS 'Date the reservation was made.';

-- ===========================================================================
-- TABLE: Fine
-- Tracks fines issued to members for overdue or damaged books.
-- ===========================================================================


CREATE TABLE Fine (
    fine_id SERIAL PRIMARY KEY,				-- Unique fine record
    member_id INT NOT NULL REFERENCES Member(member_id)
	ON DELETE CASCADE,				-- Remove fine if member removed
    loan_id INT REFERENCES Loan(loan_id)
	ON DELETE SET NULL,				-- Keep fine even if loan deleted
    amount NUMERIC(6,2) NOT NULL CHECK (amount > 0),	-- must be a positive value
    fine_date DATE DEFAULT CURRENT_DATE,		-- Auto-filled issue date
    paid_status BOOLEAN DEFAULT FALSE			-- True if paid, False if outstanding
);

COMMENT ON TABLE Fine IS 'Records fines for overdue or damaged books.';
COMMENT ON COLUMN Fine.amount IS 'Fine amount in dollars (must be positive).';
COMMENT ON COLUMN Fine.paid_status IS 'True if fine is paid, FALSE if still owed.';


