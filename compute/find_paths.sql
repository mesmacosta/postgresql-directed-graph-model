\set ROOT_NODE 1
\set SEARCH_DEPTH 100000

WITH RECURSIVE find_paths(
 n1, -- point 1
 n2, -- point 2
 depth, -- depth, starting from 1
 path, -- path, stored using an array
 visited -- visited nodes, stored using an array
) AS
  (SELECT -- ROOT node query
 g.n1, -- point 1
 g.n2, -- point 2
 1 AS depth, -- initial depth =1
 ARRAY[g.n1, g.n2] AS path, -- initial path
 ARRAY[g.n1] as visited -- nodes visited
   FROM edges AS g
   WHERE n1 = :ROOT_NODE -- ROOT node =?
    UNION ALL      
SELECT     -- recursive clause      
    g.n1,    -- point 1      
    g.n2,    -- point 2      
    sg.depth + 1 as depth,       -- depth + 1      
    path || g.n2 as path,         -- add a new point to the path      
    visited || g.n1 as visited   -- mark node as visited 
FROM edges AS g
INNER JOIN find_paths AS sg ON g.n1 = sg.n2    -- circular INNER JOIN      
WHERE        
    (g.n1 <> ALL(sg.visited))        -- prevent from cycling      
    AND 
    sg.depth <= :SEARCH_DEPTH    -- search depth =?      
)
SELECT path FROM find_paths;