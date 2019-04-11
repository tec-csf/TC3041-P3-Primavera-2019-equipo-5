//Crear el contenedor en docker con Neo4j en el puerto 7687
docker run --name=neo4j -m=4g --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j/data:/data --env=NEO4J_AUTH=none neo4j

//Cortar los archivos para tener menos registros y poder agregar los
// headers correspondientes
head -n 200000 soc-pokec-profiles.csv >> profiles.csv
head -n 4000000 1soc-pokec-relationships.csv >> 1relationships.csv

//Copiar los archivos dentro del contenedor
docker cp profiles.csv neo4j:/var/lib/neo4j/import/
docker cp 1relationships.csv neo4j:/var/lib/neo4j/import/

//En el browser ir a localhost:7687

//Query para agregar todos los nodos de los usuarios (separados por tabs no ,)
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:/profiles.csv" AS row
FIELDTERMINATOR '\t'
CREATE (:User {userID: row.user_id});

//Crear el index
CREATE INDEX ON :User(userID);

//Crear las relaciones 
USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:/1relationships.csv" AS row
MATCH (start:User {userID: row.START_ID})
MATCH (end:User {userID: row.END_ID})
MERGE (start)-[:RELATION]->(end);