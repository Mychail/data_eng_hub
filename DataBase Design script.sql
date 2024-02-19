USE portfolio_project;

DROP TABLE samplesuperstore;
DROP TABLE dim_category;
DROP TABLE dim_shipping;
DROP TABLE dim_territory;
# creating a dimension territory table

DROP TABLE IF EXISTS dim_territory;
CREATE TABLE dim_territory (
    territory_ID INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50),
    postalcode INT NOT NULL
);
SELECT *
FROM dim_territory;

ALTER TABLE samplesuperstore
ADD COLUMN territory_id INT
;

# checking
SELECT *
FROM samplesuperstore;

ALTER TABLE samplesuperstore
ADD CONSTRAINT fk_territory_id
FOREIGN KEY(territory_id) REFERENCES dim_territory(territory_ID);

# added data from the main table into the newly created dimension table

INSERT INTO dim_territory(postalcode, city , state, country, region)
SELECT DISTINCT PostalCode, City, State, Country, Region
FROM samplesuperstore
;

# populationg the foreign key column
UPDATE samplesuperstore ss
JOIN dim_territory dt ON ss.PostalCode = dt.postalcode
SET ss.territory_id = dt.territory_ID;

# Create a dimension table for categories

DROP TABLE IF EXISTS dim_category;
CREATE TABLE dim_category(
category_ID INT PRIMARY KEY AUTO_INCREMENT,
category VARCHAR(55),
subcategory VARCHAR(55)
);
# checking if the table has been created
SELECT *
FROM dim_category;

# insert data for the columns from the main table into the dimension table
# rename the column sub category in the sample super store table
ALTER TABLE samplesuperstore
RENAME COLUMN `Sub-Category` TO SubCategory;

# check if it has been fixed
SELECT *
FROM samplesuperstore;

# create category foreign key constraint on the samplesuperstore table
ALTER TABLE samplesuperstore
ADD COLUMN category_id INT,
ADD CONSTRAINT fk_category_id
FOREIGN KEY(category_id) REFERENCES dim_category(category_ID);

# insert data from the main table  into the newly created category dimensional table
INSERT INTO dim_category(subcategory, category)
SELECT DISTINCT SubCategory, Category
FROM samplesuperstore;

# Test the dimension table has been populated
SELECT *
FROM dim_category;

# popuklate the foreign key column created in the fact table

UPDATE samplesuperstore ss
JOIN dim_category dc
ON ss.SubCategory = dc.subcategory
SET ss.category_id = dc.category_ID;

# taking a look at my fact table
SELECT *
FROM samplesuperstore
LIMIT 5;

# creating a new dimensional table for shipping records
CREATE TABLE dim_shipping(
ship_ID INT PRIMARY KEY AUTO_INCREMENT,
shipmode VARCHAR(50)
);

# create foreign key and contraint in the fact table
ALTER TABLE samplesuperstore
ADD COLUMN ship_id INT,
ADD CONSTRAINT fk_ship_id
FOREIGN KEY(ship_id) REFERENCES dim_shipping(ship_ID);

# insert data into the dimension table
INSERT INTO dim_shipping(shipmode)
SELECT DISTINCT ShipMode
FROM samplesuperstore;

SELECT *
FROM dim_shipping;

# populate the fact table foreign key column
UPDATE samplesuperstore ss
JOIN dim_shipping ds
ON ss.ShipMode = ds.shipmode
SET ss.ship_id = ds.ship_ID;

# TEST OUTPUT
SELECT *
FROM samplesuperstore;

# create the dimension table segment
DROP TABLE IF EXISTS dim_segment;
CREATE TABLE dim_segment(
segment_ID INT PRIMARY KEY AUTO_INCREMENT,
segment VARCHAR(50)
);

# create foreign key in the fact table
ALTER TABLE samplesuperstore
ADD COLUMN segment_id INT,
ADD CONSTRAINT fk_segment_id
FOREIGN KEY(segment_id) REFERENCES dim_segment(segment_ID);

# insert into the segment dimension table
INSERT INTO dim_segment(segment)
SELECT DISTINCT Segment
FROM samplesuperstore;

# check the table
SELECT *
FROM dim_segment;

# populate the foreign key column in the fact table

UPDATE samplesuperstore ss
JOIN dim_segment sg
ON ss.Segment = sg.segment
SET ss.segment_id = sg.segment_ID;

# verify if it has been populated

SELECT *
FROM samplesuperstore
LIMIT 5;

# Drop unneeded columns
ALTER TABLE samplesuperstore
DROP COLUMN ShipMode,
DROP COLUMN Segment,
DROP COLUMN Country,
DROP COLUMN City,
DROP COLUMN State,
DROP COLUMN PostalCode,
DROP COLUMN Region,
DROP COLUMN Category,
DROP COLUMN SubCategory;

# check if all chamges have been implemented
SELECT *
FROM samplesuperstore;



