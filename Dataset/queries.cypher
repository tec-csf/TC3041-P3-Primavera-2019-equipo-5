
//Obtener las conexiones entre dos nodos con un máximo de 3 saltos
MATCH (u:User { userID: "1"})-[r:RELATION*1..3]-(m) RETURN u,r,m LIMIT 20

//Obtener las conexiones de un nodo
MATCH (u:User { userID: "1"})-[r:RELATION]-(m) RETURN u,r,m 

//Obtener la ruta más corta entre dos nodos sin limitar el número de saltos
MATCH (u:User { userID: "1" }),(m:User { userID: '159799' }), p = shortestPath((u)-[*]-(m))
RETURN p
