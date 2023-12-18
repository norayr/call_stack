MODULE callStack;
  IMPORT lists;


TYPE
        TObject* = List.TObject;
  TObjectDesc* = List.TObjectDesc;
       pstring* = strTypes.pstring;
       pstrings* = strTypes.pstrings;

  TString* = POINTER TO TStringDesc;

  TStringDesc =RECORD (TObjectDesc)
      str* : pstring
  END;

     Node* = List.Node;
 NodeDesc* = List.NodeDesc;

    msg* = RECORD END;

		roll*        = PROCEDURE (VAR m: msg): BOOLEAN;
		rollback*    = PROCEDURE (VAR m: msg);

     couple* = POINTER to coupleDesc;
 coupleDesc* = RECORD(TObjectDesc);
          r* : roll;
	  		  rb* : rollback;
 END;

    clstack* = POINTER TO clstackDesc;
  clstackDesc* = RECORD (List.TListDesc);

PROCEDURE createCouple(VAR proc: roll; VAR procback: rollback): couple;
VAR c: couple;
BEGIN
  NEW(c);
	c.r := proc; c.rb := procback;
	RETURN c
END createCouple;

PROCEDURE push*(VAR l: clstack; VAR c: couple);
BEGIN
	l.Append(l, c);
END push;

PROCEDURE runAllWithMsg*(lst: clstack; m: Msg);
VAR c: couple;
	b: BOOLEAN;
BEGIN
  REPEAT
	  c := lst.first;
		b := c.r(m);
    IF ~b THEN c.rb END;
		c := c.next
	UNTIL c = NIL
END run;

END callStack.
