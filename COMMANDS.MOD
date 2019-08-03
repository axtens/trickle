IMPLEMENTATION MODULE Commands;
(*$L+*)
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Strings IMPORT CompareStr;
FROM IO IMPORT DispCard;

TYPE
        CommandWord = ARRAY [0..8] OF CHAR;
        pCommandWord = POINTER TO CommandWord;
        CommandWordArray = ARRAY [0..TotalTokens] OF pCommandWord;

VAR
        CWarray : CommandWordArray;
        cnt     : CARDINAL;
        
PROCEDURE TokenNumber( token : ARRAY OF CHAR) : tokentype;
VAR
        cnt : INTEGER;
        flg : BOOLEAN;

BEGIN
        cnt := 0;
        flg := FALSE;
        LOOP
                IF CompareStr(token,CWarray[cnt]^) = 0 THEN
                        flg := TRUE;
                        EXIT
                END;
                INC(cnt);
                IF cnt > TotalTokens THEN
                        EXIT
                END;


        END;
        IF flg THEN
                RETURN VAL(tokentype,cnt);
        ELSE
                RETURN notknown
        END;

END TokenNumber;
BEGIN
        FOR cnt := 0 TO TotalTokens DO
                NEW(CWarray[cnt])
        END;
        CWarray[ORD(rem)]^ := "REM";
        CWarray[ORD(invoke)]^ := "INVOKE";
        CWarray[ORD(pause)]^ := "PAUSE";
        CWarray[ORD(mkdir)]^ := "MKDIR";
        CWarray[ORD(rmdir)]^ := "RMDIR";
        CWarray[ORD(chdir)]^ := "CHDIR";
        CWarray[ORD(endif)]^ := "ENDIF";
        CWarray[ORD(append)]^ := "APPEND";
        CWarray[ORD(delete)]^ := "DELETE";
        CWarray[ORD(cls)]^ := "CLS";
        CWarray[ORD(notify)]^ := "NOTIFY";
        CWarray[ORD(reboot)]^ := "REBOOT";
        CWarray[ORD(create)]^ := "CREATE";
        CWarray[ORD(label)]^ := "LABEL";
        CWarray[ORD(goto)]^ := "GOTO";
        CWarray[ORD(yesno)]^ := "YESNO";
        CWarray[ORD(var)]^ := "VAR";
        CWarray[ORD(verify)]^ := "VERIFY";
        CWarray[ORD(else)]^ := "ELSE";
        CWarray[ORD(incvar)]^ := "INCVAR";
        CWarray[ORD(decvar)]^ := "DECVAR";
        CWarray[ORD(input)]^ := "INPUT";
        CWarray[ORD(shell)]^ := "SHELL";
        CWarray[ORD(box)]^ := "BOX";
        CWarray[ORD(showxy)]^ := "SHOWXY";
        CWarray[ORD(gotoxy)]^ := "GOTOXY";
        CWarray[ORD(range)]^ := "RANGE?";
        CWarray[ORD(wipe)]^ := "WIPE";
        CWarray[ORD(halt)]^ := "HALT";
        CWarray[ORD(exists)]^ := "EXISTS";
        CWarray[ORD(userbreak)]^ := "USERBREAK";
        CWarray[ORD(beep)]^ := "BEEP";
        CWarray[ORD(wait)]^ := "WAIT";
        CWarray[ORD(getchar)]^ := "GETCHAR";
        CWarray[ORD(putchar)]^ := "PUTCHAR";
        CWarray[ORD(if)]^ := "IF";

END Commands.

