create table edges(      
  n1 int REFERENCES nodes (id),    -- node 1      
  n2 int REFERENCES nodes (id),    -- node 2         
  primary key (n1,n2)              -- primary key      
);      
