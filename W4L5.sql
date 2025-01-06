#1Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
USE sakila;

SELECT 
    COUNT(i.inventory_id) AS number_of_copies
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
WHERE 
    f.title = 'Hunchback Impossible';
    
    #2List all films whose length is longer than the average length of all the films in the Sakila database.
USE sakila;

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
#3 Use a subquery to display all actors who appear in the film "Alone Trip".
USE sakila;

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);
#4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
USE sakila;

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';
#5Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
#join
USE sakila;

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';
#Subqueries
USE sakila;

SELECT c.first_name, c.last_name, c.email
FROM customer c
WHERE c.address_id IN (
    SELECT a.address_id
    FROM address a
    WHERE a.city_id IN (
        SELECT ci.city_id
        FROM city ci
        WHERE ci.country_id = (
            SELECT co.country_id
            FROM country co
            WHERE co.country = 'Canada'
        )
    )
);
#6Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
#step 1 
USE sakila;

SELECT fa.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;
#step2
USE sakila;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = 25;  -- 

#7 Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
#step 1
USE sakila;

SELECT p.customer_id, SUM(p.amount) AS total_payments
FROM payment p
GROUP BY p.customer_id
ORDER BY total_payments DESC
LIMIT 1;

#step2
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = 1;  -- Replace '1' with the customer_id obtained from Step 1

#8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
USE sakila;

SELECT customer_id, total_amount_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS inner_totals
);

