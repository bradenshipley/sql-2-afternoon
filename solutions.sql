--Practice Joins
-- 1
SELECT * 
FROM Invoice AS i
JOIN InvoiceLine AS il ON il.UnitPrice 
WHERE il.UnitPrice > .99;
-- 2
SELECT c.FirstName, c.LastName, i.Total
FROM Invoice AS i
JOIN customer AS c ON i.CustomerId = c.CustomerId;
-- 3
SELECT c.FirstName, c.LastName, e.FirstName, e.LastName
FROM customer AS c
JOIN employee AS e ON c.SupportRepId = e.EmployeeId;
-- 4
SELECT al.Title, ar.Name
FROM Artist AS ar
JOIN Album AS al ON al.ArtistId = ar.ArtistId;
-- 5
SELECT plt.TrackId, pl.name
FROM PlayListTrack AS plt
JOIN Playlist as pl ON pl.PlaylistId = plt.PlaylistId
JOIN Track AS t ON t.TrackId = plt.TrackId
ORDER BY plt.PlaylistId;
-- 6
SELECT t.Name
FROM Track AS t
JOIN PlaylistTrack as plt ON plt.TrackId = t.TrackId
WHERE plt.PlaylistId = 5;
-- 7
SELECT t.Name, pl.name
FROM Track AS t
JOIN PlaylistTrack AS plt ON plt.TrackId = t.TrackId
JOIN Playlist AS pl ON pl.PlaylistId = plt.PlaylistId;
-- 8
SELECT t.Name, al.Title
FROM Track AS t
JOIN Album AS al ON al.AlbumId = t.AlbumId
JOIN Genre AS g ON t.GenreId = g.GenreId
WHERE g.name="Alternative";
--Black Diamond
SELECT pl.Name,t.Name, g.Name, al.Title, ar.Name 
FROM Track AS t
JOIN Playlist AS pl ON pl.PlaylistId = plt.PlaylistId
JOIN PlaylistTrack AS plt ON plt.TrackId = t.TrackId
JOIN Artist AS ar ON ar.ArtistId = al.ArtistId
JOIN Album AS al ON al.AlbumId = t.AlbumId
JOIN Genre AS g ON t.GenreId = g.GenreId
WHERE pl.name="Music";

--NESTED QUERIES
-- 1
SELECT * 
FROM Invoice
WHERE InvoiceId IN (
	SELECT InvoiceId
  	FROM InvoiceLine
  	WHERE UnitPrice > .99
);
-- 2
SELECT * 
FROM PlaylistTrack
WHERE PlaylistId IN (
	SELECT PlaylistId
  	FROM Playlist
  	WHERE Name = 'Music'
);
-- 3
SELECT Name 
FROM Track
WHERE TrackId IN (
	SELECT TrackId
  	FROM PlaylistTrack
  	WHERE PlaylistId = 5
);
-- 4
SELECT Name 
FROM Track
WHERE GenreId IN (
	SELECT GenreId
  	FROM Genre
  	WHERE Name = 'Comedy'
);
-- 5
SELECT Name 
FROM Track
WHERE AlbumId IN (
	SELECT AlbumId
  	FROM Album
  	WHERE Name = 'Fireball'
);
-- 6
SELECT Name 
FROM Track
WHERE AlbumId IN (
	SELECT AlbumId
  	FROM Album
  	WHERE ArtistId IN (
    	SELECT ArtistId
      	FROM Artist
      	WHERE Name = 'Queen'
    )
);
--UPDATING ROWS
-- 1
UPDATE Customer
SET Fax = null
WHERE Fax IS NOT NULL;
SELECT * FROM Customer;
-- 2
UPDATE Customer
SET Company = 'self'
WHERE Company IS NULL;
SELECT * FROM Customer;
-- 3
UPDATE Customer
SET LastName = 'Thompson'
WHERE CustomerId IN (
	SELECT CustomerId
  	FROM Customer
  	WHERE FirstName = 'Julia'
  	AND LastName = 'Barnett'
);
SELECT * FROM Customer;
-- 4
UPDATE Customer
SET SupportRepId = 4
WHERE email = 'luisrojas@yahoo.cl';
SELECT * FROM Customer;
-- 5
UPDATE Track
SET composer = 'The darkness around us'
WHERE composer IS NULL;
SELECT * FROM Track;

--GROUP BY
--1
SELECT COUNT(*), g.Name
FROM Track AS t
JOIN Genre AS g ON t.GenreId = g.GenreId
GROUP BY g.Name;
--2
SELECT COUNT(*), g.Name
FROM Track AS t
JOIN Genre AS g ON t.GenreId = g.GenreId
WHERE g.Name IN ('Rock', 'Pop')
GROUP BY g.Name;
--3
SELECT COUNT(*), a.Name
FROM Artist AS a
JOIN Album AS al ON a.ArtistId = al.ArtistId
GROUP BY a.Name;

--USE DISTINCT
--1
SELECT DISTINCT Composer 
FROM Track;
--2
SELECT DISTINCT BillingPostalCode 
FROM Invoice
ORDER BY BillingPostalCode ASC;
--3
SELECT DISTINCT Company 
FROM Customer
ORDER BY Company ASC;

--PRACTICE DELETE
--1
N/A

--2
DELETE FROM practice_delete
WHERE Type = 'bronze';

SELECT * FROM practice_delete;
--3
DELETE FROM practice_delete
WHERE Type = 'silver';

SELECT * FROM practice_delete;
--4
DELETE FROM practice_delete
WHERE Value = 150;

SELECT * FROM practice_delete;

--ECOMMERCE SIMULATION
--creating tables
CREATE TABLE users (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	name TEXT,
  	email TEXT
)
CREATE TABLE products (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	name TEXT,
  	price INTEGER
)
CREATE TABLE orders (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
  	product_id INTEGER,
  	FOREIGN KEY (product_id) REFERENCES products(id)
)
--inserting data into the tables
INSERT INTO users 
(name, email)
VALUES
('George', 'gmoney@gmail.com'),
('Bill', 'mrCoolIce@gmail.com'),
('Patrick', 'No!ThisIsPatrick!@gmail.com');

SELECT * FROM users;

INSERT INTO products 
(name, price)
VALUES
('Stapler', 321),
('Microwave', 325),
('Fridge', 3221);

SELECT * FROM products;

INSERT INTO orders
(product_id)
VALUES
(2),(1),(3);
--run queries
--get all products for the first order
SELECT * 
FROM products
WHERE id IN(
  	SELECT id
  	FROM orders
  	WHERE id =1
  );
--get all orders
SELECT * 
FROM products
WHERE id IN (
    SELECT * 
    FROM orders
);
--get the total cost of an order
SELECT SUM(price)
FROM products
WHERE id IN (
    SELECT id
    FROM orders
    WHERE id = 2
)
--add a foreign key reference from Orders to Users
ALTER TABLE orders
ADD COLUMN user_id INTEGER REFERENCES users (id);