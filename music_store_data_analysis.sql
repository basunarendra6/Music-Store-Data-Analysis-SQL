-- SECTION 1: DATABASE CREATION
-- =============================================================

DROP DATABASE music_store;

CREATE DATABASE IF NOT EXISTS music_store;
USE music_store;
-- (PostgreSQL users: run `CREATE DATABASE music_store;` separately,
--  then connect to it — Postgres has no `USE` statement.)


-- =============================================================
-- SECTION 2: TABLE CREATION
-- Auto-increment added to primary keys, ON DELETE/UPDATE CASCADE
-- added to all foreign keys as required by the project brief.
-- =============================================================

-- 1. Genre and MediaType
CREATE TABLE Genre (
    genre_id   INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(120)
);

CREATE TABLE MediaType (
    media_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(120)
);

-- 2. Employee
CREATE TABLE Employers (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name   VARCHAR(120),
    first_name  VARCHAR(120),
    title       VARCHAR(120),
    reports_to  INT,
    levels      VARCHAR(255),
    birthdate   DATE,
    hire_date   DATE,
    address     VARCHAR(255),
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100),
    postal_code VARCHAR(20),
    phone       VARCHAR(50),
    fax         VARCHAR(50),
    email       VARCHAR(100),
    FOREIGN KEY (reports_to) REFERENCES Employee(employee_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
drop table employee;

-- 3. Customer
CREATE TABLE Customer (
    customer_id    INT PRIMARY KEY AUTO_INCREMENT,
    first_name     VARCHAR(120),
    last_name      VARCHAR(120),
    company        VARCHAR(120),
    address        VARCHAR(255),
    city           VARCHAR(100),
    state          VARCHAR(100),
    country        VARCHAR(100),
    postal_code    VARCHAR(20),
    phone          VARCHAR(50),
    fax            VARCHAR(50),
    email          VARCHAR(100),
    support_rep_id INT,
    FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Artist
CREATE TABLE Artist (
    artist_id INT PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(120)
);

-- 5. Album
CREATE TABLE Album (
    album_id  INT PRIMARY KEY AUTO_INCREMENT,
    title     VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Track
CREATE TABLE Track (
    track_id      INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(200),
    album_id      INT,
    media_type_id INT,
    genre_id      INT,
    composer      VARCHAR(220),
    milliseconds  INT,
    bytes         INT,
    unit_price    DECIMAL(10,2),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Invoice
CREATE TABLE Invoice (
    invoice_id          INT PRIMARY KEY AUTO_INCREMENT,
    customer_id         INT,
    invoice_date        DATE,
    billing_address     VARCHAR(255),
    billing_city        VARCHAR(100),
    billing_state       VARCHAR(100),
    billing_country     VARCHAR(100),
    billing_postal_code VARCHAR(20),
    total                DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
    invoice_line_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id      INT,
    track_id        INT,
    unit_price      DECIMAL(10,2),
    quantity        INT,
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (track_id) REFERENCES Track(track_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. Playlist
CREATE TABLE Playlist (
    playlist_id INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255)
);

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
    playlist_id INT,
    track_id    INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (track_id) REFERENCES Track(track_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* -------------------------------------------------------------
   DATA IMPORT (manual step, not scripted here):
   1. Download the CSVs from the link provided in the project doc.
   2. Import each CSV into its matching table, in this order to
      respect foreign-key dependencies:
      Genre -> MediaType -> Employee -> Customer -> Artist ->
      Album -> Track -> Invoice -> InvoiceLine -> Playlist ->
      PlaylistTrack
   3. Match CSV column headers exactly to the column names above.
   4. track.csv, invoiceline.csv and playlisttrack.csv are large —
      import them last and be patient.
   ------------------------------------------------------------- */
   
   select * from genre;
   select * from mediatype;
   select * from customer;
   select * from artist;
   select * from album;
   select * from track;
   select * from invoice;
   select * from invoiceline;
   select * from playlist;
   select * from playlisttrack;
   
   
    
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE customer
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, company, address, city, state,
 country, postal_code, phone, fax, email, @support_rep_id)
SET
  support_rep_id = NULLIF(@support_rep_id, '');
   show tables;
SELECT COUNT(*) FROM employers;
TRUNCATE TABLE employers;
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@secure_file_priv;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE employers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(employee_id, last_name, first_name, title, @reports_to, levels,
 @birthdate, @hire_date, address, city, state, country,
 postal_code, phone, fax, email)
SET
  reports_to = NULLIF(@reports_to, ''),
  birthdate = STR_TO_DATE(@birthdate, '%d-%m-%Y'),
  hire_date = STR_TO_DATE(@hire_date, '%d-%m-%Y');
  SELECT * FROM employers;


-- =============================================================
-- SECTION 3: TASK QUERIES
-- =============================================================

-- ---------------------------------------------------------------
-- Q1. Who is the senior most employee based on job title?
-- The 'levels' column encodes seniority; the highest level
-- (alphabetically/rank-wise last, e.g. 'C-Level' or 'Senior')
-- identifies the most senior employee. Ordering descending and
-- taking the first row surfaces the senior-most title.
-- ---------------------------------------------------------------
SELECT *
FROM Employers
ORDER BY levels DESC
LIMIT 1;


-- ---------------------------------------------------------------
-- Q2. Which countries have the most Invoices?
-- ---------------------------------------------------------------
SELECT billing_country,
       COUNT(invoice_id) AS invoice_count
FROM Invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;


-- ---------------------------------------------------------------
-- Q3. What are the top 3 values of total invoice?
-- ---------------------------------------------------------------
SELECT invoice_id,
       customer_id,
       total
FROM Invoice
ORDER BY total DESC
LIMIT 3;


-- ---------------------------------------------------------------
-- Q4. Which city has the best customers?
-- Returns the single city with the highest sum of invoice totals,
-- to host the promotional Music Festival.
-- ---------------------------------------------------------------
SELECT billing_city,
       SUM(total) AS total_invoice_amount
FROM Invoice
GROUP BY billing_city
ORDER BY total_invoice_amount DESC
LIMIT 1;


-- ---------------------------------------------------------------
-- Q5. Who is the best customer?
-- The customer who has spent the most money overall.
-- ---------------------------------------------------------------
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;


-- ---------------------------------------------------------------
-- Q6. Email, first name, last name and Genre of all Rock Music
-- listeners, ordered alphabetically by email (A to Z).
-- ---------------------------------------------------------------
SELECT DISTINCT c.email,
       c.first_name,
       c.last_name,
       g.name AS genre
FROM Customer c
JOIN Invoice i        ON c.customer_id = i.customer_id
JOIN InvoiceLine il   ON i.invoice_id = il.invoice_id
JOIN Track t          ON il.track_id = t.track_id
JOIN Genre g          ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;


-- ---------------------------------------------------------------
-- Q7. Top 10 rock bands: artist name and total track count for
-- the artists who have written the most rock tracks.
-- ---------------------------------------------------------------
SELECT ar.name AS artist_name,
       COUNT(t.track_id) AS total_tracks
FROM Artist ar
JOIN Album al  ON ar.artist_id = al.artist_id
JOIN Track t   ON al.album_id = t.album_id
JOIN Genre g   ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY total_tracks DESC
LIMIT 10;


-- ---------------------------------------------------------------
-- Q8. Track names with a song length longer than the average
-- song length. Ordered by song length, longest first.
-- ---------------------------------------------------------------
SELECT name,
       milliseconds
FROM Track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM Track)
ORDER BY milliseconds DESC;


-- ---------------------------------------------------------------
-- Q9. How much has each customer spent on each artist?
-- Returns customer name, artist name and total amount spent.
-- ---------------------------------------------------------------
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ar.name AS artist_name,
       SUM(il.unit_price * il.quantity) AS total_spent
FROM Customer c
JOIN Invoice i      ON c.customer_id = i.customer_id
JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
JOIN Track t        ON il.track_id = t.track_id
JOIN Album al       ON t.album_id = al.album_id
JOIN Artist ar      ON al.artist_id = ar.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, ar.artist_id, ar.name
ORDER BY customer_name ASC, total_spent DESC;
-- Note: PostgreSQL users can replace CONCAT(a, ' ', b) with a || ' ' || b


-- ---------------------------------------------------------------
-- Q10. Most popular Genre per country (by number of purchases).
-- Ties are handled with RANK() so all tied genres are returned.
-- ---------------------------------------------------------------
WITH genre_purchase_counts AS (
    SELECT i.billing_country AS country,
           g.name AS genre,
           COUNT(il.invoice_line_id) AS purchase_count,
           RANK() OVER (
               PARTITION BY i.billing_country
               ORDER BY COUNT(il.invoice_line_id) DESC
           ) AS genre_rank
    FROM Invoice i
    JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
    JOIN Track t        ON il.track_id = t.track_id
    JOIN Genre g        ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
)
SELECT country,
       genre,
       purchase_count
FROM genre_purchase_counts
WHERE genre_rank = 1
ORDER BY country ASC;


-- ---------------------------------------------------------------
-- Q11. Top-spending customer per country.
-- Ties are handled with RANK() so all customers who share the
-- top amount for a country are returned.
-- ---------------------------------------------------------------
WITH customer_country_spend AS (
    SELECT i.billing_country AS country,
           c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(i.total) AS total_spent,
           RANK() OVER (
               PARTITION BY i.billing_country
               ORDER BY SUM(i.total) DESC
           ) AS spend_rank
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    GROUP BY i.billing_country, c.customer_id, c.first_name, c.last_name
)
SELECT country,
       customer_name,
       total_spent
FROM customer_country_spend
WHERE spend_rank = 1
ORDER BY country ASC;

