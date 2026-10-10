# Music Store Data Analysis Using SQL

## Project Description
This project analyzes a music store database using SQL. It creates relational tables for customers, employees, artists, albums, tracks, invoices, invoice lines, genres, media types, and playlists, then uses SQL queries to explore sales and customer behavior.

## Objectives
- Identify the senior-most employee based on the hierarchy field.
- Analyze invoice counts by billing country and find the highest-value invoices.
- Identify the city with the highest total invoice value and the customer who spent the most.
- Find customers who purchased Rock music and rank artists by Rock-track count.
- Compare track lengths against the average track length.
- Analyze customer spending by artist.
- Find the most purchased genre in each country.
- Identify the highest-spending customer in each country.

## SQL Concepts Used
- Database and table creation
- Primary keys and foreign keys
- Joins
- Aggregate functions (`COUNT`, `SUM`, `AVG`)
- `GROUP BY` and `ORDER BY`
- Subqueries
- Common Table Expressions (CTEs)
- Window functions (`RANK`)
- Data import with `LOAD DATA INFILE`

## Database Tables
The SQL script defines tables for:
`Genre`, `MediaType`, `Employers`, `Customer`, `Artist`, `Album`, `Track`, `Invoice`, `InvoiceLine`, `Playlist`, and `PlaylistTrack`.

## Files
- `music_store_data_analysis.sql` — SQL schema, data import examples, and analysis queries.

## How to Run
1. Install MySQL 8.0 or a compatible MySQL client/server.
2. Open `music_store_data_analysis.sql` in MySQL Workbench or your preferred SQL editor.
3. Review the database creation and table definitions before running the script.
4. Import the required CSV datasets into the corresponding tables. The script includes example `LOAD DATA INFILE` statements; update file paths and CSV settings for your computer.
5. Run the analysis queries in the `SECTION 3: TASK QUERIES` section.

## Important Notes
- The script uses MySQL syntax such as `AUTO_INCREMENT`, `USE`, and `LOAD DATA INFILE`.
- The SQL file contains `DROP DATABASE music_store;`, which can delete an existing database with that name. Review or remove that statement before running if you need to preserve existing data.
- The script references `Employee` in foreign keys while defining a table named `Employers`; review and align these names before running the full script.
- The CSV files are not included in this repository. Add them only if you have permission to share them and they do not contain private information.
- Some `LOAD DATA INFILE` paths are specific to a local Windows MySQL installation and should be changed for your environment.

## Author
Add your name here.
