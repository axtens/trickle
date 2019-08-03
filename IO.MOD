IMPLEMENTATION MODULE IO;

FROM SYSTEM IMPORT SEGMENT, OFFSET, ASSEMBLER;
FROM Strings IMPORT Concat, Copy, Length;

PROCEDURE GetChar( Echo : BOOLEAN):CHAR;
VAR
   c : CHAR;
BEGIN
     IF Echo THEN
        c := 1X
     ELSE
        c := 7X
     END;
     ASM
        MOV  AH,c
        INT  21X
        MOV  c,AL
     END;
     RETURN c
END GetChar;

PROCEDURE GetLine( VAR S : ARRAY OF CHAR; Echo : BOOLEAN);
VAR
   cnt, lim : CARDINAL;
   chr      : CHAR;

BEGIN
     cnt := 0;
     lim := SIZE(S);
     LOOP
         chr := GetChar(Echo);
         IF (chr = 0DX) OR (cnt > lim) THEN
            EXIT
         END;
         S[cnt] := chr;
         INC(cnt)
     END
END GetLine;

PROCEDURE InputLine( VAR S : ARRAY OF CHAR);
VAR
    c : CARDINAL;
BEGIN
     c := OFFSET(S);
     S[0] := 0FFX;
     S[1] := 0X;
     ASM
        MOV  DX,c
        MOV  AH,10
        INT  33
     END;
     Copy(S,2,ORD(S[1]),S);
END InputLine;

PROCEDURE DispChar( C : CHAR);
BEGIN
      ASM
        MOV     AH,2
        MOV     DL,C
        INT     21H
      END;
END DispChar;

PROCEDURE DispString( P : ARRAY OF CHAR);
VAR
   K,I : CARDINAL;
   J : CHAR;
BEGIN
     K := SIZE(P)-1;
     FOR I := 0 TO K DO
         J := P[I];
         IF J=0X THEN
            I := K
         ELSE
            DispChar(P[I]);
         END;
     END;
END DispString;

PROCEDURE DispNL;
VAR
   X : ARRAY [0..1] OF CHAR;

BEGIN
     X[0] := 0DX;
     X[1] := 0AX;
     DispString(X)
END DispNL;
PROCEDURE DispRepeat( N : CARDINAL; S : ARRAY OF CHAR);
VAR I : CARDINAL;
BEGIN
     FOR I := 1 TO N DO
        DispString(S)
     END
END DispRepeat;
PROCEDURE Reverse(VAR S:ARRAY OF CHAR);
VAR
        C : CHAR;
        I, J : CARDINAL;
BEGIN
        I := 0;
        J := Length(S)-1;
        WHILE (I<J) DO
                C := S[I];
                S[I] := S[J];
                S[J] := C;
                INC(I);
                DEC(J)
        END;
END Reverse;
PROCEDURE DispCard(C:CARDINAL;W:CARDINAL);
VAR I : CARDINAL;
    S : ARRAY [0..5] OF CHAR;
BEGIN
        I := 0;
        REPEAT
                S[I] := CHR( C MOD 10 + ORD("0"));
                INC(I);
                C := C DIV 10;
        UNTIL C <= 0;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           DispRepeat(W-I," ")
        END;
        DispString(S);

END DispCard;
PROCEDURE DispLongCard(L:LONGCARD;W:CARDINAL);
VAR I : CARDINAL;
    S : ARRAY [0..12] OF CHAR;
BEGIN
        I := 0;
        REPEAT
                S[I] := CHR( SHORT(L MOD 10L + LONG(ORD("0"))));
                INC(I);
                L := L DIV 10L;
        UNTIL L <= 0L;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           DispRepeat(W-I," ")
        END;
        DispString(S);

END DispLongCard;
PROCEDURE DispLine( S : ARRAY OF CHAR);
BEGIN
        DispString(S);
        DispNL
END DispLine;
PROCEDURE DispText( S : ARRAY OF CHAR);
VAR
        Of,SE : CARDINAL;
        NewS  : ARRAY [0..255] OF CHAR;
BEGIN
        Concat(S,"$",NewS);
        SE := OFFSET(NewS);
        Of := SEGMENT(NewS);
        ASM
                PUSH    DS
                PUSH    BP
                MOV     AX,Of
                MOV     DS,AX
                MOV     DX,SE
                MOV     AH,9
                INT     21X
                POP     BP
                POP     DS
        END;
END DispText;

BEGIN
END IO.

