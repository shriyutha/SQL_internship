A transaction is a group of SQL statments that must execute a single unit of work / single logical unit, mean either all executed or never.
All the transactions weill follow the ACID properties:
1. Atomicity		All or nothing	
2. Consistency		Valid state before & after	
3. Isolation		Concurrent transactions don’t interfere	
4. Durability		Committed data is permanent 

Isolation level: Isolation controls how transactions interact. 
3 main isolation levels: READ COMMITTED 
						 REPEATABLE READ	
						 SERIALIZABLE  
						 
Dirty read = reading uncommitted data, PostgreSQL does NOT allow dirty reads even at lowest level.	
