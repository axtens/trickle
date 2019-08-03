IMPLEMENTATION MODULE ERRORs;
FROM IO IMPORT DispString;
FROM System IMPORT Terminate;

PROCEDURE Error( ErrNum : ErrorClass; severity : CARDINAL);
BEGIN
        CASE severity OF
                1 : DispString("Warning: ");
                |
                2 : DispString("FATAL ERROR: ");
        END;
        CASE ErrNum OF
                LabelSpace : DispString("Out of LABEL space.");|
                LineSpace : DispString("Out of LINE space.");|
                VarSpace : DispString("Out of VAR space.");|
                VarSet : DispString("Could not set variable.");|
                SetExecute: DispString("Could not set $EXECUTE.");|
                SetStatus: DispString("Could not set $STATUS.");
        END;
        IF severity = 2 THEN
                Terminate(2)
        END
END Error;
END ERRORs.


