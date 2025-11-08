-- Cursors: Write a PL/SQL block of code using parameterized Cursor that will merge 
-- the data available in the newly created table N_RollCall with the data available in the table 
-- O_RollCall. If the data in the first table already exist in the second table then that data 
-- should be skipped. 




CREATE TABLE O_RollCall (
    RollNo INT PRIMARY KEY,
    Name VARCHAR(30)
);

CREATE TABLE N_RollCall (
    RollNo INT,
    Name VARCHAR(30)
);


-- Old data
INSERT INTO O_RollCall VALUES
(1, 'Amit'),
(2, 'Riya'),
(3, 'Karan');

-- New data (includes duplicates)
INSERT INTO N_RollCall VALUES
(2, 'Riya'),
(3, 'Karan'),
(4, 'Sneha'),
(5, 'Neha');


DELIMITER $$

CREATE PROCEDURE merge_RollCall(IN start_roll INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE rno INT;
    DECLARE rname VARCHAR(30);

    -- Parameterized cursor: selects new data from N_RollCall
    DECLARE cur CURSOR FOR
        SELECT RollNo, Name FROM N_RollCall WHERE RollNo >= start_roll;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO rno, rname;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Insert only if RollNo does not already exist in O_RollCall
        IF NOT EXISTS (SELECT * FROM O_RollCall WHERE RollNo = rno) THEN
            INSERT INTO O_RollCall VALUES (rno, rname);
        END IF;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;


CALL merge_RollCall(1);


SELECT * FROM O_RollCall;
