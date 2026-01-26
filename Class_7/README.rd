-- Referential Integrity Summary:
1. Primary Key - Uniquely identifies a row
2. Foreign Key - Links two tables 
3. Referential Integrity - Prevents invalid relationships
4. ON DELETE CASCADE - Deletes dependent rows automatically
5. FK Violation - Prevents new records 


-- Real world mapping:

 Company
 |-- Department (HR)
 |     |-- Employee (Alice)
 |
 |-- Department (IT)
 |     |-- Employee (Bob)
 |
 |-- Department (Finance)
 |     |-- Employee (Charlie)
 |
 |-- Department (HR)
 |    |-- Employee (Sara)
 |
 |-- Department (IT)
 |     |-- Employee (David)
 |
 |-- Department (Finance)
       |-- Employee (Emma) 

	   
-- Explanation:
Company → concept
Department → parent entity
Employee → child entity
A Department can have many Employees, but an Employee belongs to one and only one Department.

