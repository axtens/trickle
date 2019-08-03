IMPLEMENTATION MODULE BigFile;
(*$L+*)

FROM Files IMPORT Read;
FROM Strings IMPORT Concat, Pos, Copy, Length, Delete;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
CONST
    siz = 9000;
TYPE

        BigBuffer = ARRAY [0..siz] OF CHAR;
        pBuffer   = POINTER TO BigBuffer;
VAR
        BUF : pBuffer;
        ArrayLoc, BytesRead : CARDINAL;

PROCEDURE ReadBuffer( VAR buf : INTEGER) : BOOLEAN;
BEGIN
        Read(buf,BUF,siz,BytesRead);
        IF BytesRead = 0 THEN
                RETURN FALSE
        ELSE
                ArrayLoc := 0;
                RETURN TRUE
        END;

END ReadBuffer;


PROCEDURE BigRead( VAR buf : INTEGER; VAR InString : ARRAY OF CHAR) : BOOLEAN;
VAR
        i,j,k,l  : CARDINAL;
        cr   : CHAR;
BEGIN
        InString[0] := 0X;
        cr := 0DX;
        IF ArrayLoc >= BytesRead  THEN
                IF NOT ReadBuffer(buf) THEN
                        RETURN FALSE
                END;
        END;
        i := ArrayLoc;
        LOOP
                IF BUF^[i] = cr THEN
                        DEC(i);
                        EXIT
                END;
                INC(i);
                IF i>BytesRead THEN
                        i := BytesRead;
                        EXIT
                END;
        END;
        l := 0;
        FOR j := ArrayLoc TO i DO
                (* Concat(InString,BUF^[j],InString) *)
                InString[l] := BUF^[j];
                INC(l);
        END;
        InString[l] := 0C;
        k := i - ArrayLoc;
        ArrayLoc := ArrayLoc + k + 3;
        RETURN TRUE

END BigRead;

BEGIN
        NEW(BUF);
        BytesRead := siz;
        ArrayLoc := siz+1;

END BigFile.

