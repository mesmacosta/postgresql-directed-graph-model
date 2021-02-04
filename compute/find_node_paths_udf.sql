-- based on: https://www.alibabacloud.com/blog/postgresql-graph-search-practices---10-billion-scale-graph-with-millisecond-response_595039
-- select o_path from find_node_paths(1);   

create or replace function find_node_paths(    
  IN i_root int,                       -- The node that the search is based on      
  IN i_depth int  default 99999,       -- the tier to search (the depth limit)    
  IN i_limit int8 default 2000000000,  -- limit the number of records returned for each tier    
  OUT o_path int[],                    -- output: path, an array of IDs 
  OUT o_visited int[],                 -- output: visited nodes, an array of IDs       
  OUT o_point1 int,                    -- output: point 1 ID    
  OUT o_point2 int,                    -- output: point 2 ID    
  OUT o_depth int                      -- output: current depth (tier)    
) returns setof record as 
$$
    
declare    
  sql text;    
begin    
sql := format($_$    
WITH RECURSIVE find_paths(
 n1, -- point 1
 n2, -- point 2
 depth, -- depth, starting from 1
 path, -- path, stored using an array
 visited -- visited nodes, stored using an array
) AS (      
        select n1,n2,depth,path,visited from (      
        SELECT -- ROOT node query
            g.n1, -- point 1
            g.n2, -- point 2
            1 AS depth, -- initial depth =1
            ARRAY[g.n1, g.n2] AS path, -- initial path
            ARRAY[g.n1] as visited -- nodes visited
        FROM edges AS g       
        WHERE       
          n1 = %s                                                    -- ROOT node =?      
          limit %s                           -- How many records are limited at each tier?      
        ) t      
      UNION ALL      
        select n1,n2,depth,path,visited from (      
        SELECT     -- recursive clause      
            g.n1,    -- point 1      
            g.n2,    -- point 2      
            sg.depth + 1 as depth,       -- depth + 1      
            path || g.n2 as path,         -- add a new point to the path      
            visited || g.n1 as visited   -- mark node as visited    
        FROM edges AS g
        INNER JOIN find_paths AS sg ON g.n1 = sg.n2    -- circular INNER JOIN      
        WHERE       
          (g.n1 <> ALL(sg.visited))      -- prevent from cycling      
          AND sg.depth <= %s                 -- search depth =?        
          limit %s                           -- How many records are limited at each tier?                 
        ) t      
)      
SELECT path as o_path, visited as o_visited, n1 as o_point1, n2 as o_point2, depth as o_depth    
FROM find_paths;
$_$, i_root, i_limit, i_depth, i_limit    
);    
    
return query execute sql;    
    
end;    

$$
 language plpgsql strict;  
