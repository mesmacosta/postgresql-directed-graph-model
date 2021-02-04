# postgresql-directed-graph-model
Simplistic approach on how to store a directed graph on postgresql

Based on [postgresql-graph-search-practices---10-billion-scale-graph-with-millisecond-response_595039](https://www.alibabacloud.com/blog/postgresql-graph-search-practices---10-billion-scale-graph-with-millisecond-response_595039)

# Use case
Considering a directed graph (there can be cycles) return all paths from a given node.


# Model
```
create table nodes(      
  id INTEGER PRIMARY KEY,
  title VARCHAR(256)       
);
```

```
create table edges(      
  from int,              -- node 1      
  to int,                -- node 2         
  primary key (from,to)  -- primary key      
);    

```
# UDF
[find_node_paths_udf](https://github.com/mesmacosta/postgresql-directed-graph-model/blob/main/compute/find_node_paths_udf.sql)

With data:
```
- Vertices: [{id: 1}, {id: 2}, {id: 3}, {id: 4}] 
- Edges: [{from: 1, to: 2}, {from: 2, to: 3}, {from: 3, to: 4}]
```

Executing:
```
select o_path from find_node_paths(1);
```
results:
```
  o_path
-----------
 {1,2}
 {1,2,3}
 {1,2,3,4}
(3 rows)
```

Executing:
```
select o_path from find_node_paths(3);
```
results:
```
 o_path
--------
 {3,4}
(1 row)
```
