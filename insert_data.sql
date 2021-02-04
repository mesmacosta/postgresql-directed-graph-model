-- Nodes data
INSERT INTO nodes values (1, 'First Node');
INSERT INTO nodes values (2, '2nd Node');
INSERT INTO nodes values (3, 'Third Node');
INSERT INTO nodes values (4, 'Fourth Node');

-- Edges data
INSERT INTO edges values (1, 2);
INSERT INTO edges values (2, 3);
INSERT INTO edges values (3, 4);

-- Cyclic Data
INSERT INTO edges values (2, 1);
INSERT INTO edges values (3, 2);