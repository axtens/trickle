MODULE TCL2;
(*$L+*)

FROM System IMPORT GetArg, Terminate;
FROM IO IMPORT DispString, DispLine, DispCard, DispNL;
FROM Files IMPORT Open, NORMAL, Close, FileStatus;
FROM XStr IMPORT Cut, UpperCase, LeftTrim;
FROM Strings IMPORT Concat, Length, CompareStr;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Commands IMPORT TokenNumber, tokentype, tokens;
FROM BigFile IMPORT BigRead;
FROM VARs IMPORT defineVAR, setVAR;
FROM LABELs IMPORT defineLABEL, getLABEL;
FROM XAnsi IMPORT AnsiLocate, AnsiEraseDisplay, AnsiBox;
FROM NumberConversion IMPORT CardToString, StringToCard;
FROM LINEs IMPORT defineLINE, getLINE;
FROM Loader IMPORT Execute;
FROM FileSpec IMPORT DropExt;
FROM ERRORs IMPORT Error;
FROM SYSTEM IMPORT ASSEMBLER;

TYPE
    string = ARRAY [0..255] OF CHAR;

VAR

   buff : INTEGER;
   token, p0, p1, p2, p3, p4, remainder : string;
   filename1, inrec : string;
   i,linecounter,k,l,cnt : CARDINAL;
   last : CARDINAL;

PROCEDURE doNotKnown;
BEGIN
        DispString(token);
        DispLine(" unknown.")
END doNotKnown;

PROCEDURE doREM;
BEGIN
END doREM;

PROCEDURE doINVOKE;
VAR
   sysEXEC : CARDINAL;
   a       : ARRAY [0..4] OF CHAR;
   f       : CARDINAL;
BEGIN
        Execute(p1,p2,sysEXEC);
        CardToString(sysEXEC,a,f);
        setVAR("$EXECUTE",a)
END doINVOKE;

PROCEDURE doPAUSE;
BEGIN
        IF Length(p1) <> 0 THEN
                DispString(p1)
        ELSE
                DispString("Press any key.")
        END;
        ASM
                MOV     AH,0
                INT     16H
        END;
END doPAUSE;

PROCEDURE doMKDIR;
BEGIN
END doMKDIR;

PROCEDURE doRMDIR;
BEGIN
END doRMDIR;

PROCEDURE doCHDIR;
BEGIN
END doCHDIR;

PROCEDURE doENDIF;
BEGIN
END doENDIF;

PROCEDURE doAPPEND;
BEGIN
END doAPPEND;

PROCEDURE doDELETE;
BEGIN
END doDELETE;

PROCEDURE doCLS;
BEGIN
        AnsiEraseDisplay;
END doCLS;

PROCEDURE doNOTIFY;
BEGIN
        DispLine(p1)
END doNOTIFY;

PROCEDURE doREBOOT;
BEGIN
END doREBOOT;

PROCEDURE doCREATE;
BEGIN
END doCREATE;

PROCEDURE doLABEL;
BEGIN
END doLABEL;

PROCEDURE doGOTO;
BEGIN
        IF getLABEL(p1,i) THEN
                setVAR("$STATUS","TRUE");
        ELSE
                setVAR("$STATUS","FALSE")
        END;
END doGOTO;

PROCEDURE doYESNO;
BEGIN
END doYESNO;

PROCEDURE doVAR;
BEGIN
END doVAR;

PROCEDURE doVERIFY;
BEGIN
END doVERIFY;

PROCEDURE doELSE;
BEGIN
END doELSE;

PROCEDURE doINCVAR;
BEGIN
END doINCVAR;

PROCEDURE doDECVAR;
BEGIN
END doDECVAR;

PROCEDURE doINPUT;
BEGIN
END doINPUT;

PROCEDURE doSHELL;
BEGIN
END doSHELL;

PROCEDURE doBOX;
VAR
        a,b,c,d : CARDINAL;
        f       : BOOLEAN;
BEGIN
        StringToCard(p1,a,f);
        StringToCard(p2,b,f);
        StringToCard(p3,c,f);
        StringToCard(p4,d,f);
        AnsiBox(a,b,c,d);
END doBOX;

PROCEDURE doSHOWXY;
BEGIN
        doGOTOXY;
        DispString(p3)
END doSHOWXY;

PROCEDURE doGOTOXY;
VAR
        a,b : CARDINAL;
        f   : BOOLEAN;
BEGIN
        StringToCard(p1,a,f);
        StringToCard(p2,b,f);
        AnsiLocate(a,b);

END doGOTOXY;

PROCEDURE doRANGE;
BEGIN
END doRANGE;

PROCEDURE doWIPE;
BEGIN
END doWIPE;

PROCEDURE doHALT;
BEGIN
END doHALT;

PROCEDURE doEXISTS;
BEGIN
END doEXISTS;

PROCEDURE doUSERBREAK;
BEGIN
END doUSERBREAK;

PROCEDURE doBEEP;
BEGIN
END doBEEP;

PROCEDURE doWAIT;
BEGIN
END doWAIT;

PROCEDURE doGETCHAR;
BEGIN
END doGETCHAR;

PROCEDURE doPUTCHAR;
BEGIN
END doPUTCHAR;

PROCEDURE doIF;
BEGIN
END doIF;


BEGIN
        defineVAR("$EXECUTE");
        defineVAR("$STATUS");
        GetArg(filename1,cnt);
     	IF cnt = 0 THEN
            DispLine("No file.");
            Terminate(1);
     	END;
        DropExt(filename1,filename1);
        Concat(filename1,".tcl",filename1);
        Open(buff,filename1,NORMAL);
        IF FileStatus <> 0 THEN
                DispString(filename1);
                DispLine(" not found.");
                Terminate(1)
        END;
     	linecounter := 1;
     	last := 1;
        DispString("Loading ... ");
     	LOOP
            IF NOT BigRead(buff,inrec) THEN
                EXIT
            END;
            LeftTrim(inrec);
            Cut(inrec,token,p0);
            Cut(p0,p1,remainder);
            Cut(remainder,p2,remainder);
            Cut(remainder,p3,remainder);
            IF Length(inrec)<>0 THEN
                UpperCase(token);
                CASE TokenNumber(token) OF
                        rem : ;
                        |
                        label : defineLABEL(p1,linecounter)
                        |
                        var :   defineVAR(p1);
                                defineLINE(linecounter,inrec)
                        ELSE
                                defineLINE(linecounter,inrec)
                END; (* CASE *)
	END;
     	END;
     	Close(buff);
     	DEC(linecounter);
     	i := 1;
        DispLine("Executing...");
        WHILE getLINE(i,inrec) DO
                Cut(inrec,token,p0);
                UpperCase(token);
                Cut(p0,p1,remainder);
                Cut(remainder,p2,remainder);
                Cut(remainder,p3,remainder);
                Cut(remainder,p4,remainder);
                CASE TokenNumber(token) OF
                        notknown : (* keyword not found *) doNotKnown;
                        |
                        rem : (* "REM" *) doREM;
                        |
                        invoke : (* "INVOKE" *) doINVOKE;
                        |
                        pause : (* "PAUSE" *) doPAUSE;
                        |
                        mkdir : (* "MKDIR" *) doMKDIR;
                        |
                        rmdir : (* "RMDIR" *) doRMDIR;
                        |
                        chdir : (* "CHDIR" *) doCHDIR;
                        |
                        endif : (* "ENDIF" *) doENDIF;
                        |
                        append : (* "APPEND" *) doAPPEND;
                        |
                        delete : (* "DELETE" *) doDELETE;
                        |
                        cls : (* "CLS" *) doCLS;
                        |
                        notify : (* "NOTIFY" *) doNOTIFY;
                        |
                        reboot : (* "REBOOT" *) doREBOOT;
                        |
                        create : (* "CREATE" *) doCREATE;
                        |
                        label : (* "LABEL" *) doLABEL;
                        |
                        goto : (* "GOTO" *) doGOTO;
                        |
                        yesno : (* "YESNO" *) doYESNO;
                        |
                        var : (* "VAR" *) doVAR;
                        |
                        verify : (* "VERIFY" *) doVERIFY;
                        |
                        else : (* "ELSE" *) doELSE;
                        |
                        incvar : (* "INCVAR" *) doINCVAR;
                        |
                        decvar : (* "DECVAR" *) doDECVAR;
                        |
                        input : (* "INPUT" *) doINPUT;
                        |
                        shell : (* "SHELL" *) doSHELL;
                        |
                        box : (* "BOX" *) doBOX;
                        |
                        showxy : (* "SHOWXY" *) doSHOWXY;
                        |
                        gotoxy : (* "GOTOXY" *) doGOTOXY;
                        |
                        range : (* "RANGE?" *) doRANGE;
                        |
                        wipe : (* "WIPE" *) doWIPE;
                        |
                        halt : (* "HALT" *) doHALT;
                        |
                        exists : (* "EXISTS" *) doEXISTS;
                        |
                        userbreak : (* "USERBREAK" *) doUSERBREAK;
                        |
                        beep : (* "BEEP" *) doBEEP;
                        |
                        wait : (* "WAIT" *) doWAIT;
                        |
                        getchar : (* "GETCHAR" *) doGETCHAR;
                        |
                        putchar : (* "PUTCHAR" *) doPUTCHAR;
                        |
                        if : (* "IF" *) doIF;
                END;
                INC(i);
        END;
END TCL2.
