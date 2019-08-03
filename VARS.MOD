IMPLEMENTATION MODULE VARs;
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
    variptr = POINTER TO varirec;
    varirec = RECORD
                variname : string;
                varival  : string;
              END;
VAR
   vari : ARRAY [1..limit] OF variptr;
   varicounter : CARDINAL;

PROCEDURE VarNumber( VarName : ARRAY OF CHAR) : CARDINAL;
VAR
        I : CARDINAL;
BEGIN
        I := 1;
        LOOP
                IF I > limit THEN
                        RETURN notfound
                END;
                IF vari[I] = NIL THEN
                        RETURN notfound
                ELSE
                    IF CompareStr(vari[I]^.variname,VarName) = 0 THEN
                       RETURN I;
                    END
                END;
                INC(I)
        END;

END VarNumber;

PROCEDURE defineVAR( VARname : ARRAY OF CHAR);
BEGIN
        IF VarNumber(VARname) = notfound THEN
                IF Available(TSIZE(varirec)) AND (varicounter <= limit) THEN
                        NEW(vari[varicounter]);
                        UpperCase(VARname);
                        Assign(VARname,vari[varicounter]^.variname);
                        vari[varicounter]^.varival  := '';
                        INC(varicounter);
                ELSE
                        Error(VarSpace,2)
                END;
        END
END defineVAR;

PROCEDURE setVAR( VARname, value : ARRAY OF CHAR);
VAR
        I : CARDINAL;
BEGIN
        I := VarNumber( VARname);
        IF I <> notfound THEN
                Assign(value,vari[I]^.varival);
        ELSE
                Error(VarSet,1);
        END;

END setVAR;

PROCEDURE getVAR( VARname : ARRAY OF CHAR; VAR value : ARRAY OF CHAR) : BOOLEAN;
VAR
        I : CARDINAL;
BEGIN
        I := VarNumber( VARname);
        IF I <> notfound THEN
                Assign(vari[I]^.varival,value);
                RETURN TRUE
        ELSE
                RETURN FALSE
        END;
END getVAR;



BEGIN
        FOR varicounter := 1 TO limit DO
                vari[varicounter] := NIL;
        END;
        varicounter := 1;

END VARs.


