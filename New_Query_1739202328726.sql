/*1. Create a table called employees with the following structure?
: emp_id (integer, should not be NULL and should be a primary key)Q
: emp_name (text, should not be NULL)Q
: age (integer, should have a check constraint to ensure the age is at least 18)Q
: email (text, should be unique for each employee)Q
: salary (decimal, with a default value of 30,000).*/

CREATE TABLE employees(
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    age int check (age>18),
    email VARCHAR(50) UNIQUE,
    salary FLOAT DEFAULT 30000);

/*2.Explain the purpose of constraints and how they help maintain data integrity in a database. Provide
examples of common types of constraints.*/
/*ANS: Purpose of Constraints in a Database
Constraints ensure data integrity by enforcing rules on table columns. They prevent invalid data entry and maintain consistency.

Common Types of Constraints:
PRIMARY KEY – Ensures unique identification (e.g., customer_id).
FOREIGN KEY – Enforces referential integrity (e.g., rental.customer_id → customer.customer_id).
NOT NULL – Prevents null values (e.g., email must be provided).
UNIQUE – Ensures no duplicate values (e.g., username).
CHECK – Enforces conditions (e.g., age > 18).*/

/*3. Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify
your answer.*/

/*ANS: Ensures mandatory data entry (e.g., customer_name should never be empty).
Prevents unexpected NULL values that could cause logic errors.

Can a Primary Key Contain NULL?
A Primary Key must be unique and cannot contain NULL values because:

Uniqueness – A NULL value is unknown, making uniqueness enforcement impossible.*/

/*4.  Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an
example for both adding and removing a constraint.
*/
 
/* for add use -> alter         ALTER TABLE customer ADD CONSTRAINT unique_email UNIQUE (email);
   for remove also use alter    ALTER TABLE customer DROP CONSTRAINT unique_email;*/



--1. -Identify the primary keys and foreign keys in maven movies db. Discuss the differences
--
--2. List all details of actor
USE mavenmovies;
SELECT * FROM actor;

--3. List all customer information from DB
SELECT * FROM customer;

--4. List different countries.
SELECT country FROM country;

--5. Display all active customers.
SELECT CONCAT(first_name," ",last_name) as "Name"
FROM customer
WHERE active = 1;

--6. List of all rental IDs for customer with ID 1.
SELECT rental_id FROM rental
WHERE customer_id = 1;

--7.  Display all the films whose rental duration is greater than 5 .
SELECT title FROM film
WHERE rental_duration > 5;

--8. List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(replacement_cost) FROM film
WHERE replacement_cost BETWEEN 15 AND 20;

--9. Display the count of unique first names of actors
SELECT first_name,COUNT(first_name)
FROM actor
GROUP BY first_name;

--10.  Display the first 10 records from the customer table SELECT * FROM customer
LIMIT 10;

--11. - Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT * FROM customer
WHERE first_name LIKE "b%"
LIMIT 3;

--12. -Display the names of the first 5 movies which are rated as ‘G’
SELECT title FROM film
WHERE rating = "G"
LIMIT 5;

--13. -Find all customers whose first name starts with "a"
SELECT * FROM customer
WHERE first_name LIKE "a%";

--14. Find all customers whose first name ends with "a".
SELECT * FROM customer
WHERE first_name LIKE "%a";

--15.  Display the list of first 4 cities which start and end with ‘a’ 
SELECT city FROM city
WHERE city LIKE "a%a"
LIMIT 4;

--16. Find all customers whose first name have "NI" in any position.
SELECT * FROM customer
WHERE first_name LIKE "%NI%";

--17. Find all customers whose first name have "r" in the second position
SELECT * FROM customer
WHERE first_name LIKE "_r%";

--18. - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * FROM customer
WHERE first_name LIKE "a____%";

--19- Find all customers whose first name starts with "a" and ends with "o".
SELECT * FROM customer
WHERE first_name LIKE "a%o";

--20 - Get the films with pg and pg-13 rating using IN operator.
select title,rating from film
WHERE rating IN ("PG","PG-13");

--21 - Get the films with length between 50 to 100 using between operator.
select title,length from film
WHERE length BETWEEN 50 AND 100;

--22 - Get the top 50 actors using limit operator.
select * from actor
LIMIT 50;

--23 - Get the distinct film ids from inventory table.
SELECT film_id FROM inventory;


/*Question 1:
Retrieve the total number of rentals made in the Sakila database.
Hint: Use the COUNT() function.*/

SELECT COUNT(rental_id) as "Total number of rental"
FROM rental;


/*Question 2:
Find the average rental duration (in days) of movies rented from the Sakila database.
Hint: Utilize the AVG() function.*/
SELECT AVG(rental_duration)
FROM film;


--String Functions:

/*Question 3:

Display the first name and last name of customers in uppercase.
Hint: Use the UPPER () function.*/

SELECT UPPER(first_name) as "First name",UPPER(last_name) as "Last name"
FROM customer;

/*Question 4:

Extract the month from the rental date and display it alongside the rental ID.
Hint: Employ the MONTH() function.*/

SELECT MONTH(rental_date) as "Month",rental_id
FROM rental;


--GROUP BY:


/*Question 5:

Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
Hint: Use COUNT () in conjunction with GROUP BY.*/
SELECT customer_id,count(rental_id) as "Count of rentals"
FROM rental
GROUP BY customer_id;

/*Question 6:

Find the total revenue generated by each store.
Hint: Combine SUM() and GROUP BY.*/
SELECT st.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store st ON i.store_id = st.store_id
GROUP BY st.store_id;



/*Question 7:

Determine the total number of rentals for each category of movies.
Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.*/
SELECT c.name AS category, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_rentals DESC;


/*Question 8:
Find the average rental rate of movies in each language.
Hint: JOIN film and language tables, then use AVG () and GROUP BY.*/
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

/*Questions 9 -

Display the title of the movie, customer s first name, and last name who rented it.
Hint: Use JOIN between the film, inventory, rental, and customer tables.*/
SELECT f.title AS movie_title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;




/*Question 10:
Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
Hint: Use JOIN between the film actor, film, and actor tables.*/

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';



/*Question 11:

Retrieve the customer names along with the total amount they've spent on rentals.

Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.*/
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC;



/*Question 12:

List the titles of movies rented by each customer in a particular city (e.g., 'London').

Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.*/
SELECT c.first_name, c.last_name, ci.city, f.title AS movie_title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
ORDER BY c.last_name, c.first_name, f.title;


/*Question 13:

Display the top 5 rented movies along with the number of times they've been rented.

Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.*/

SELECT f.title AS movie_title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;




/*Question 14:

Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).

Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.*/

SELECT c.customer_id, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE s.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT s.store_id) = 2;

--Windows Function:

--1. Rank the customers based on the total amount they've spent on rentals.
SELECT c.customer_id, c.first_name, c.last_name, 
       SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS ranking
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY ranking;

--2. Calculate the cumulative revenue generated by each film over time.
SELECT f.title, p.payment_date, 
       SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

--3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT f.title, f.length, 
       AVG(DATEDIFF(r.return_date, r.rental_date)) OVER (PARTITION BY f.length) AS avg_rental_duration
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

--4. Identify the top 3 films in each category based on their rental counts.
SELECT c.name AS category, f.title, COUNT(r.rental_id) AS rental_count,
       RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS ranking
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name, f.title
HAVING ranking <= 3;



--6. Find the monthly revenue trend for the entire rental store over time.
SELECT DATE_FORMAT(p.payment_date, '%Y-%m') AS month, 
       SUM(p.amount) AS monthly_revenue,
       SUM(SUM(p.amount)) OVER (ORDER BY DATE_FORMAT(p.payment_date, '%Y-%m')) AS cumulative_revenue
FROM payment p
GROUP BY month
ORDER BY month;

--7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH CustomerSpending AS (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent,
           PERCENT_RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, first_name, last_name, total_spent
FROM CustomerSpending
WHERE spending_rank <= 0.20
ORDER BY total_spent DESC;

--8. Calculate the running total of rentals per category, ordered by rental count.
SELECT c.name AS category, f.title, COUNT(r.rental_id) AS rental_count,
       SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name, f.title;

--9. Find the films that have been rented less than the average rental count for their respective categories.
WITH AvgCategoryRentals AS (
    SELECT c.name AS category, f.title, COUNT(r.rental_id) AS rental_count,
           AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.name) AS avg_rentals
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
)
SELECT category, title, rental_count, avg_rentals
FROM AvgCategoryRentals
WHERE rental_count < avg_rentals;

--10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT DATE_FORMAT(p.payment_date, '%Y-%m') AS month, SUM(p.amount) AS monthly_revenue
FROM payment p
GROUP BY month
ORDER BY monthly_revenue DESC
LIMIT 5;



/*1. First Normal Form (1NF):
a. Identify a table in the Sakila database that violates 1NF. Explain how you
would normalize it to achieve 1NF*/

/*ANS: 1NF Violation in Sakila Database
The customer table may violate 1NF if it stores multiple phone numbers in a single column.

Normalization to 1NF:
Create a new customer_phone table with one phone number per row.
Remove the phone_numbers column from customer.
Final Structure:

customer (customer_id, first_name, last_name, email)
customer_phone (phone_id, customer_id, phone_number)
This ensures atomicity and eliminates repeating groups. */




/*2. Second Normal Form (2NF):
a. Choose a table in Sakila and describe how you would determine whether it is in 2NF.
If it violates 2NF, explain the steps to normalize it.*/

/*ANS:
The rental table violates 2NF because store_id depends only on inventory_id, not the full primary key (rental_id, inventory_id).

Normalization to 2NF:
Move store_id to an inventory table.
Remove store_id from rental.
Now, all non-key attributes fully depend on the entire primary key, ensuring 2NF compliance. 
*/


/*3.Third Normal Form (3NF):
a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies
present and outline the steps to normalize the table to 3NF*/

/*ANS: The payment table violates 3NF because staff_address depends on staff_id, which is not a primary key.

Normalization to 3NF:
Move staff_address to a separate staff_details table.
Remove staff_address from payment.
✅ This eliminates transitive dependencies, ensuring 3NF compliance.*/

/*4. Normalization Process:

a. Take a specific table in Sakila and guide through the process of normalizing it from the initial
unnormalized form up to at least 2NF.*/


/*5. CTE Basics:

a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they
have acted in from the actor and film_actor tables.
6. CTE with Joins:*/

WITH ActorFilmCount AS (
    SELECT 
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, actor_name
)
SELECT * FROM ActorFilmCount;


/*a. Create a CTE that combines information from the film and language tables to display the film title,
language name, and rental rate.
c\ CTE for Aggregation:*/

WITH FilmLanguage AS (
    SELECT 
        f.film_id, 
        f.title AS film_title, 
        l.name AS language_name, 
        f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLanguage;


/*a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments)
from the customer and payment tables.
\ CTE with Window Functions:*/
WITH CustomerRevenue AS (
    SELECT 
        c.customer_id, 
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
        SUM(p.amount) AS total_revenue
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT * FROM CustomerRevenue;


/*a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
È\ CTE and Filtering:*/
WITH FilmRanking AS (
    SELECT 
        film_id, 
        title, 
        rental_duration, 
        RANK() OVER (ORDER BY rental_duration DESC) AS rank_position
    FROM film
)
SELECT * FROM FilmRanking;


/*a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the
customer table to retrieve additional customer details*/
WITH FrequentRenters AS (
    SELECT 
        customer_id, 
        COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
    c.email, 
    fr.rental_count
FROM FrequentRenters fr
JOIN customer c ON fr.customer_id = c.customer_id;

/*a. Write a query using a CTE to find the total number of rentals made each month, considering the
rental_date from the rental table
EE' CTE and Self-Join:*/
WITH MonthlyRentals AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month, 
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY rental_month
)
SELECT * FROM MonthlyRentals;


/*a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film
together, using the film_actor table.*/



/*12. CTE for Recursive Search:

a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager,
considering the reports_to column*/

