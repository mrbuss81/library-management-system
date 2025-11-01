# 📚 Library Management System (COMP 230 Project)

**Author:** Michael Buss  
**Program:** Bachelor of Computer Science — University of the Fraser Valley  
**Instructor:** Carl Janzen  
**Course:** COMP 230 – Database Management Systems  
**Term:** Fall 2025  

---

## 🧾 Overview
This repository contains a fully designed **Library Management Database System**, developed as part of COMP 230 at UFV.  
It demonstrates the complete process of **database modeling, normalization, and SQL implementation**, moving from theoretical design to a functional relational schema.

---

## 🧩 Key Features
- Comprehensive **Entity–Relationship (ER) model**
- Fully normalized schema up to **3NF/BCNF**
- PostgreSQL **DDL and DML scripts**
- Documented **data dictionary** and **functional dependencies**
- Sample dataset and dump files for testing
- Clear **design rationale** (ternary relationships, weak entities, cardinalities)

---

## 🗂️ Project Structure

```text
Library-Management-System/
  README.md                 - Portfolio overview (this file)
  data-dictionary/          - Attribute definitions and data types
  database-dump/            - SQL schema, create-tables.sql, and insert data
    README.md               - Implementation notes and load instructions
  er-model/                 - ER diagram and design documentation
    README.md               - Academic submission for COMP 230 (ER + design notes)
  normalization/            - 1NF, 2NF, 3NF analysis and dependency notes
```

---

## 🧠 Design Highlights
- **Ternary Relationship (Loan):** Connects *Member*, *Book*, and *Staff*, reflecting real-world circulation workflows.  
- **Weak Entity (Fine):** Dependent on both *Member* and *Loan*, ensuring referential integrity.  
- **M:N Relationships:** Implemented via bridge tables (*Writes*, *Reservation*).  
- Consistent **naming conventions** (`snake_case`, singular entity names).  

---

## 💡 How to Run Locally
1. Launch PostgreSQL (or pgAdmin).  
2. Create a new database:
   ```sql
   CREATE DATABASE library_db;
3. Load the schema and sample data:

\i database-dump/create-tables.sql


4. Review the ER model and documentation in /er-model and /data-dictionary.

📈 Learning Outcomes

Mastered database normalization and ER modeling.

Implemented strong constraint and key management.

Strengthened version control and repository organization skills.

Learned to document complex systems professionally.

🧭 Related Documentation

ER Model & Design Notes → er-model/README.md

SQL Implementation → database-dump/README.md

Normalization Details → normalization/

🧑‍💻 Author

Michael Buss
Computer Science Undergraduate — UFV
GitHub: mrbuss81
 / CompSciRVDad

LinkedIn: Coming soon

📚 Academic Documentation

This project originated as part of COMP 230 – Database Management Systems (UFV).
See the detailed submission materials in:

er-model/README.md

database-dump/README.md
