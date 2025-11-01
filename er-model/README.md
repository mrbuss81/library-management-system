# COMP230 — Assignment 1
**Library Database System**  
**Author:** Michael Buss  
**Student ID:** 300066231  
**Course:** COMP230 (Databases and Database Management Systems)  
**Instructor:** Carl Janzen  
**Date:** October 13, 2025  

---

## Project Overview
This repository contains my submission for **Assignment 1**, which focuses on the design and documentation of a relational database system for a library.

The goal of this project was to apply data modeling concepts, including:
- Entity–Relationship (ER) modeling  
- Identification of entities, attributes, and relationships  
- Specification of keys, constraints, and participation  
- Documentation of business rules and metadata  

---

## Contents
| File | Description |
|------|--------------|
| `ER-diagram.pdf` | Final ER diagram showing all entities, attributes, and relationships. |
| `entities.md` | Entity data dictionary with data types, constraints, and default values. |
| `relationships.md` | Relationship definitions with participation, cardinality, and business rules. |

---

## How to View
All files are viewable directly in GitLab:
- Open `ER-diagram.pdf` for the final ER model.  
- Read `entities.md` and `relationships.md` for supporting documentation.  
- Each Markdown file is formatted for readability in GitLab’s web viewer.

---

## Design Decisions

### 1. Ternary Relationship — *Loan*
The **Loan** relationship connects **Member**, **Book**, and **Staff** in a *ternary relationship*.  
This design reflects real-world library operations, where each loan transaction:
- Involves one **Member** borrowing,  
- One **Book** being borrowed, and  
- One **Staff** member processing the transaction.  

The ternary structure ensures that all three entities are required to define a valid loan.  
In the database implementation, this relationship will become a separate table (`Loan`) with foreign keys referencing each participating entity.

---

### 2. Weak Entity — *Fine*
The **Fine** entity is modeled as a *weak entity* dependent on **Member** and **Loan**, since fines cannot exist without an associated member and loan record.  
Each fine is uniquely identified by its relationship to a specific loan.

---

### 3. Binary and M:N Relationships
- **Writes (Author–Book):** M:N relationship — authors can write many books, and books can have multiple authors.  
- **Publishes (Publisher–Book):** 1:N relationship — each book is published by exactly one publisher.  
- **Reservation (Member–Book):** M:N relationship — members can reserve multiple books, and books can have multiple reservations.

---

### 4. Modeling Conventions
- Attribute names use `snake_case` for SQL consistency.  
- Entities are singular and capitalized.  
- Default values and constraints are specified in the data dictionary.  
- Participation and cardinalities are shown on the ERD and documented in `relationships.md`.

---

## Submission Notes
- The **Loan** relationship is modeled as a *ternary relationship* among Member, Staff, and Book.  
- The **Fine** entity acts as a *weak entity*, dependent on Member and Loan.  
- This submission includes all components for Parts 1 and 2 (ERD and Data Dictionary).  

---

**Submitted by:**  
Michael Buss  
Student ID: 300066231  
University of the Fraser Valley  
October 2025

