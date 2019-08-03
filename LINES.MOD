IMPLEMENTATION MODULE LINEs;
FROM Storage IMPORT ALLOCATE, DEALLOCATE, Available;
FROM Strings IMPORT CompareStr, Assign;
FROM XStr IMPORT UpperCase;
FROM SYSTEM IMPORT TSIZE;
FROM ERRORs IMPORT ErrorClass, Error;

CONST
    limit = 600;
TYPE
    string = ARRAY [0..126] OF CHAR;
    progptr = POINTER TO progrec;
    progrec = RECORD
                    progtext : string;
              END;
VAR
   prog : ARRAY [1..limit] OF progptr;
   i    : CARDINAL;

PROCEDURE defineLINE( VAR linenumber : CARDINAL; LINE : ARRAY OF CHAR);
BEGIN
        IF Available(TSIZE(progrec)) AND (linenumber <= limit) THEN
                NEW(prog[linenumber]);
                Assign(LINE,prog[linenumber]^.progtext);
                INC(linenumber);
        ELSE
            Error(LineSpace,2)
        END;
END defineLINE;

PROCEDURE getLINE( linenumber : CARDINAL; VAR LINE : ARRAY OF CHAR) : BOOLEAN;
BEGIN
     IF prog[linenumber] = NIL THEN
        RETURN FALSE
     END;
     IF prog[linenumber]^.progtext[0]=0X THEN
        RETURN FALSE
     END;
     Assign(prog[linenumber]^.progtext,LINE);
     RETURN TRUE

END getLINE;


BEGIN
        FOR i := 1 TO limit DO
       		prog[i] := NIL;
        END;

END LINEs.

