-- initialize spatialite extensions to SQLite database
.read init_spatialite.sql
  
-- Add Geometry column to data tables; make them feature classes
SELECT AddGeometryColumn('crime',    'Geometry', 2226, 'POINT', 2);
SELECT AddGeometryColumn('stations', 'Geometry', 4326, 'POINT', 2);

-- Update tables with new geometry values
-- EPSG SRID 2226 for California StatePlane Zone 2 (US ft) and 4326 for GRS WGS84 (longlat)
UPDATE crime    SET Geometry = GeomFromText('POINT(' || X_Coord || ' ' || Y_Coord || ')', 2226);
UPDATE stations SET Geometry = GeomFromText('POINT(' || lng     || ' ' || lat     || ')', 4326);

-- Load shapefiles
-- All California agency shapefiles projected in 2226
.loadshp shapefiles/CITIES               cities    2226
.loadshp shapefiles/MAIN_RIVERS          rivers    2226
.loadshp shapefiles/maj_hosp             hospitals 2226
.loadshp shapefiles/MajorRoads           roads     2226
.loadshp shapefiles/RECREATION           parks     2226
.loadshp shapefiles/Sac_2010CensusBlkPop blocks    2226
.loadshp shapefiles/schools              schools   2226

-- Add spatial indexes to optimize spatial searches
SELECT CreateSpatialIndex('crime',     'Geometry');
SELECT CreateSpatialIndex('stations',  'Geometry');
SELECT CreateSpatialIndex('cities',    'Geometry');
SELECT CreateSpatialIndex('rivers',    'Geometry');
SELECT CreateSpatialIndex('hospitals', 'Geometry');
SELECT CreateSpatialIndex('roads',     'Geometry');
SELECT CreateSpatialIndex('parks',     'Geometry');
SELECT CreateSpatialIndex('blocks',    'Geometry');
SELECT CreateSpatialIndex('schools',   'Geometry');

-- Optimize database when finished
VACUUM;