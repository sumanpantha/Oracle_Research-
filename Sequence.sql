/*
Use the CREATE SEQUENCE statement to create a sequence, which is a database object from which multiple users may generate unique integers.
You can use sequences to automatically generate primary key values.
When a sequence number is generated, the sequence is incremented, independent of the transaction committing or rolling back.
If two users concurrently increment the same sequence, then the sequence numbers each user acquires may have gaps, because sequence numbers are being generated by the other user.
One user can never acquire the sequence number generated by another user.
Once a sequence value is generated by one user, that user can continue to access that value regardless of whether the sequence is incremented by another user.
Sequence numbers are generated independently of tables, so the same sequence can be used for one or for multiple tables.
It is possible that individual sequence numbers will appear to be skipped, because they were generated and used in a transaction that ultimately rolled back.
Additionally, a single user may not realize that other users are drawing from the same sequence.
Once a sequence is created, you can access its values in SQL statements with the CURRVAL pseudocolumn,
which returns the current value of the sequence, or the NEXTVAL pseudocolumn, which increments the sequence and returns the new value.
*/

--Syntax:
CREATE SEQUENCE sequence_name
[INCREMENT BY n]
[START WITH n]
[MAXVALUE n |NOMINVALUE ]
[MINVALUE n |NOMAXVALUE ]
[CYCLE | NOCYCLE]
[CACHE n | NOCACHE]
[ORDER | NOORDER];

--sequence_name  : is the name of the sequence generator
--INCREMENT BY n : specifies the interval between sequence numbers which n is an integer.if omitted n=1.
--START WITH n   : specifies the first sequence number to be generated.If omitted n=1. (Note:START WITH n >= MINVALUE n)

--MAXVALUE N | NOMAXVALUE : specifies the minimum value the sequence can generate.specifies a maximum value of 10^26(28digit) for an ascending sequence and -1 for a descending sequence.(default option)
--MINVALUE n | NOMINVALUE : specifies the minimum value the sequence can generate.specifies a maximum value of 1 for an ascending sequence and -(10^26) for a descending sequence.(default option)

--CYCLE | NOCYCLE : specifies whether the sequence continues to generate values after reaching its maximum or minimum value(NOCYCLE default)
--CACHE n | NOCACHE : specifies how many values the Oracle Server preallocates and keep in memory (by default, the Oracle Server caches 20 values)

--ORDER | NOORDER :Specify ORDER to guarantee that sequence numbers are generated in order of request. This clause is useful if you are using the sequence numbers as timestamps. Guaranteeing order is usually not important for sequences used to generate primary keys.
--Specify NOORDER if you do not want to guarantee sequence numbers are generated in order of request. This is the default.


--EG:
DROP SEQUENCE sequence_eg;

--Simple way to CREATE SEQUENCE with out declaring parameters which takes all the default value to create SEQUENCE.
CREATE SEQUENCE sequence_eg;

--WAY to fetch the sequence value.
--Gives the CURRENT value.
--Syntax:
SELECT
      sequence_name.CURRVAL
FROM
      dual;

--Gives the NEXT value.
--Syntax:
SELECT
     sequence_name.NEXTVAL
FROM
     dual;

SELECT
     sequence_eg.CURRVAL
FROM
     dual;
--ORA-08002: sequence SEQUENCE_EG.CURRVAL is not yet defined in this session

--First we should run NEXTVAL statement because untill that the value is not assigned on the sequence.
SELECT
     sequence_eg.NEXTVAL
FROM
     dual;


--SEQUENCE WITH PARAMETERS.
DROP SEQUENCE sq1;

CREATE SEQUENCE sq1
INCREMENT BY 1
START WITH 5
MINVALUE 1
NOORDER ;

BEGIN
    FOR i IN 1..10
    LOOP
       Dbms_Output.Put_Line(sq1.NEXTVAL);
    END LOOP;
END;
/
/*
5
6
7
8
9
10
11
12
13
14
*/

DROP SEQUENCE sq2;

CREATE SEQUENCE sq2
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 20
CYCLE ;

--ORA-04013: number to CACHE must be less than one cycle
--We must have at least 21 data to rotate in cycle.

CREATE SEQUENCE sq2
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 21
CYCLE;

--Here the sequence start with 1 and increment by 1 and reach up to 21 maximum number and repeats(CYCLE) the value again
BEGIN
    FOR i IN 1..50
    LOOP
       Dbms_Output.Put_Line(sq2.NEXTVAL);
    END LOOP;
END;
/

/*
2
4
6
8
10
12
14
16
18
20
*/


--Other EG:Create sequence with DEFAULT values
DECLARE
    l_output NUMBER(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE sq1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq1' ;

    FOR i IN 1..10
    LOOP
       EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL FROM dual' INTO l_output ;
       Dbms_Output.Put_Line(l_output);
    END LOOP;
END;
/


--create sequence with parameters
DECLARE
    l_output NUMBER(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE sq1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq1
                       increment by 1
                       start with 1
                       maxvalue 3
                       cache 2
                       cycle' ;

    FOR i IN 1..10
    LOOP
       EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL FROM dual' INTO l_output ;
       Dbms_Output.Put_Line(l_output);
    END LOOP;
END;
/


DECLARE
    l_output NUMBER(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE sq1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq1
                       increment by 7
                       start with 9
                       maxvalue 100
                       cache 2
                       cycle' ;

    FOR i IN 1..200
    LOOP
       EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL FROM dual' INTO l_output ;
       Dbms_Output.Put_Line(l_output);
    END LOOP;
END;
/

DECLARE
    l_output NUMBER(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE sq1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq1
                       increment by 7
                       start with 9
                       maxvalue 100
                       cache 2
                       cycle' ;
    EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL FROM dual' INTO l_output ;
    FOR i IN 1..20
    LOOP
       EXECUTE IMMEDIATE 'SELECT sq1.currval FROM dual' INTO l_output ;
       Dbms_Output.Put_Line(l_output);
    END LOOP;
END;
/


CREATE sequence sq;



--In Oracle 12c, you can now specify the CURRVAL and NEXTVAL sequence pseudocolumns as default values for a column.

CREATE TABLE t1
(
 c1 NUMBER DEFAULT sq.NEXTVAL,   --cannot declare CURRVAL and NEXTVAL in DEFAULT option in column prior to Oracle 12cR1
 c2 VARCHAR2(20)
);

DROP SEQUENCE sq2;

CREATE SEQUENCE sq2;

SELECT sq2.NEXTVAL FROM dual;

--MAXVALUE can be defined 127 digit but in data dictionary view the column value is 28 digit
ALTER SEQUENCE sq2
  MAXVALUE 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
  MINVALUE 1;


DROP  SEQUENCE s1;
CREATE SEQUENCE s1
START WITH 1
INCREMENT BY 2
MINVALUE 1;

--Here the maximum value of the sequence is 9999999999999999999999999999 by default 28 digit value.

DROP  SEQUENCE s;
CREATE SEQUENCE s
START WITH -1
INCREMENT BY -2
MAXVALUE 100;

--Here the minimum value is -9999999999999999999999999999 by default  28 digit value.

SELECT s.NEXTVAL FROM dual;

BEGIN
    FOR i IN 1..10
    LOOP
       Dbms_Output.Put_Line(s.NEXTVAL);
    END LOOP;
END;
/

SELECT USER FROM dual;

--Data dictionary view which shows the USER SEQUENCE information.
SELECT * FROM user_sequences;


DECLARE
    l_output NUMBER(10);
BEGIN
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE sq1';
    EXCEPTION WHEN OTHERS THEN
        NULL;
    END;

    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq1
                       increment by 1
                       start with 1
                       maxvalue 10' ;
    --EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL FROM dual' INTO l_output ;
    FOR i IN 1..9
    LOOP
       EXECUTE IMMEDIATE 'SELECT sq1.NEXTVAL-100 FROM dual' INTO l_output ;
       Dbms_Output.Put_Line(l_output);
    END LOOP;
END;
/