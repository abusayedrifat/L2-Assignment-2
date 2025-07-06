-- Active: 1747705708757@@127.0.0.1@5432@conservation_db
CREATE Table rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

INSERT INTO rangers("name",region) VALUES 
('Alice Green', 'Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range');

-- SELECT * from rangers;
CREATE Table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discover_date DATE,
    conservation_status VARCHAR(15)
);

-- DROP Table species;


INSERT INTO species (common_name,scientific_name, discover_date, conservation_status) VALUES
('Snow Leopard ','Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger','Panthera tigris tigris', '1758-01-01' ,'Endangered'),
('Red Panda ','Ailurus fulgens  ','1825-01-01','Vulnerable'),
('Asiatic Elephant','Elephas maximus indicus','1758-01-01' ,'Endangered ');

-- SELECT * from species;

CREATE Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id) NOT NULL,
    species_id INTEGER REFERENCES species(species_id) NOT NULL,
    sighting_time TIMESTAMP without TIME zone,
    "location" VARCHAR(50),
    notes VARCHAR(300)
);

-- DROP Table sightings;

INSERT INTO sightings(species_id,ranger_id,"location",sighting_time,notes) VALUES
(1,1,'Peak Ridge',' 2024-05-10 07:45:00 ',' Camera trap image captured'),
(2,2,'Bankwood Area ','2024-05-12 16:20:00',' Juvenile seen '),
(3,3,'Bamboo Grove East','2024-05-15 09:10:00 ','Feeding observed'),
(1,2,'Snowfall Pass ','2024-05-18 18:30:00 ',NULL);

SELECT * from sightings;


--1st question

INSERT INTO rangers("name", region) VALUES
('Derek Fox', 'Coastal Plains');



--2nd question

SELECT  count(scientific_name) as unique_species_count from species;


--3rd question

SELECT * from sightings WHERE "location" LIKE '%Pass%';


--4th question
SELECT "name", count(ranger_id) as total_sightings from sightings 
 JOIN rangers USING(ranger_id) GROUP BY "name";

 -- 5th question

SELECT  common_name from sightings 
INNER JOIN  species ON species.species_id != sightings.species_id;
 ORDER BY common_name ASC LIMIT 1 ;


--6th question

SELECT common_name, sighting_time, "name" from sightings
INNER JOIN species ON species.species_id = sightings.species_id
INNER JOIN rangers on rangers.ranger_id = sightings.ranger_id
ORDER BY sighting_time DESC LIMIT 2;


--7th question
UPDATE species
SET conservation_status = 'Historic'
WHERE discover_date < '1800-01-01';


--8th question

SELECT sighting_id,
CASE 
    WHEN sighting_time::TIMESTAMP::TIME < '12:00:00' THEN 'Morning'
    WHEN sighting_time::TIMESTAMP::TIME BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'  
    ELSE  'Evening'
END as time_of_day
FROM sightings;


--9th question 
-- i did't understand at all. asking delete ranger who never sighted any species. but on that sightings table we can clearly see that every ranger sighted at least one species. so how could you say that Delete rangers who have never sighted any species? that doesn't make any sense. but i can write the code for it.

DELETE FROM rangers 
WHERE ranger_id NOT IN (
    SELECT ranger_id from sightings
) 