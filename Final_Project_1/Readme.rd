
Project Objective:

The objective of this project is to design and implement a fully normalized relational database schema for an e-commerce platform.
The system supports:
Customer management
Product catalog management
Category hierarchy (with subcategories)
Order processing
Payment tracking
Sales reporting
The database is designed using Third Normal Form (3NF) to ensure:
Elimination of redundancy
Enforcement of data integrity
Efficient querying
Scalability

System Overview:

The e-commerce system includes the following core entities:
Customers
Addresses
Categories (with recursive hierarchy)
Products
Orders
Order_Items (resolves many-to-many)
Payments
