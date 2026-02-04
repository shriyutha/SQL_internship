1. email
email VARCHAR(100) UNIQUE NOT NULL
NOT NULL → email must exist
UNIQUE → no duplicates allowed
- Prevents duplicate user accounts
- Multiple constraints on one column
2. age
- CHECK (age BETWEEN 18 AND 65)
- Enforces numeric range
- Prevents invalid ages
- This is numeric validation at database level
3. salary
- CHECK (salary > 0)
- Salary must be positive
- Prevents negative or zero salary
4. department
- CHECK (department IN ('HR', 'IT', 'Finance', 'Sales'))
- Restricts values to known categories
- Prevents spelling mistakes
5. created_at
- DEFAULT CURRENT_TIMESTAMP
- Automatically stores insert time
- No need to supply value manually
