# IT-235 Database Design (SNHU)

## 🔍 What to Expect

- Course introduces database modeling and design from the ground up. Students will:
  - Use modeling tools/techniques to translate user / business requirements into database designs.  
  - Create entity-relationship models (ERMs), with entities & attributes.  
  - Draw ER diagrams (ERDs) and define table relationships.  
  - Use normalization (e.g. dependency diagrams) to ensure appropriate design.  

## 📅 Typical Flow / Modules

| Module | Topic | Deliverables |
|---|--------|---------------|
| 1 | Requirements gathering / user stories / business cases | Collect user requirements; discussion / reflection |
| 2 | Entity-Relationship Modeling | Draft ERM, define attributes & primary keys |
| 3 | ER Diagrams & Table Relationships | ERD + correct relationships, cardinality |
| 4 | Normalization (1NF, 2NF, 3NF) | Normalize schema; dependency diagrams |
| 5 | Mapping ERD to relational tables; schema design | Write CREATE TABLE, define constraints, keys |
| 6 | Sample queries / data manipulation; handling data types | Practice SQL SELECT / JOINs etc. |
| 7 | Final project: complete schema + sample data + diagrams + normalization + reflection | Full project submission with all parts |

## ⚠ Common Pitfalls

- Skipping or rushing normalization — leaving anomalies in schema.  
- Ambiguous relationships in ER diagrams (cardinality, optional/mandatory)  
- Not matching business requirements (user stories) with schema — missing fields.  
- Weak or missing constraints (foreign keys, unique, validations).  
- Minimal reflections — just "I did X" isn't enough; explain *why* design choices made.

## ✅ Tips to Succeed

- Read the user requirements very carefully; list attributes & constraints before modeling.  
- Draw wireframes/diagrams even on paper first.  
- Use tools like Visio, Lucidchart, or ER modeling software.  
- Test sample queries with sample data to ensure relationships work.  
- Include normalization steps explicitly in your work.  
