IMPLEMENTATION MODULE LABELs;
FROM Storage IMPORT ALLOCATE, DEALLOCATE, Available;
FROM Strings IMPORT CompareStr, Assign;
FROM XStr IMPORT UpperCase;
FROM SYSTEM IMPORT TSIZE;
FROM ERRORs IMPORT ErrorClass, Error;

CONST
    limit = 100;
    notfound = 0;
TYPE
    string = ARRAY [0..255] OF CHAR;
    lablptr = POINTER TO lablrec;
    lablrec = RECORD
                lablname : string;
                lablnum  : CARDINAL
              END;
VAR
   labl : ARRAY [1..limit] OF lablptr;
   lablcounter : CARDINAL;

PROCEDURE LabelNumber( LABELname : ARRAY OF CHAR) : CARDINAL;
VAR
        I : CARDINAL;
BEGIN
        I := 1;
        LOOP
                IF I > limit THEN
                        RETURN notfound
                END;
                IF labl[I] = NIL THEN
                        RETURN notfound
                ELSE
                    IF CompareStr(labl[I]^.lablname,LABELname) = 0 THEN
                       RETURN I;
                    END
                END;
                INC(I)
        END;

END LabelNumber;

PROCEDURE defineLABEL( LABELname : ARRAY OF CHAR; LABELline : CARDINAL);
BEGIN
        IF LabelNumber(LABELname) = notfound THEN
                IF Available(TSIZE(lablrec)) AND (lablcounter <= limit) THEN
                        NEW(labl[lablcounter]);
                        UpperCase(LABELname);
                        Assign(LABELname,labl[lablcounter]^.lablname);
                        labl[lablcounter]^.lablnum  := LABELline;
                        INC(lablcounter);
                ELSE
                        Error(LabelSpace,2)
                END;
        END
END defineLABEL;


PROCEDURE getLABEL( LABELname : ARRAY OF CHAR; VAR value : CARDINAL) : BOOLEAN;
VAR
        I : CARDINAL;
BEGIN
        I := LabelNumber( LABELname);
        IF I <> notfound THEN
                value := labl[I]^.lablnum;
                RETURN TRUE
        ELSE
                RETURN FALSE
        END;
END getLABEL;



BEGIN
        FOR lablcounter := 1 TO limit DO
                labl[lablcounter] := NIL;
        END;
        lablcounter := 1;

END LABELs.



