﻿; These functions and labels are related maintenance of the actionList



lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , "i am started. actionList=`n" actionList )

; t


;/¯¯¯¯ setTrayIcon ¯¯ 181107175114 ¯¯ 07.11.2018 17:51:14 ¯¯\
setTrayIcon(status := "loaded" ){
	
	global g_isListBoxDisabled
	if(g_isListBoxDisabled){
		Menu, Tray, Icon, %A_ScriptDir%\icon\abc123\GI-gray-gradient.ico
		return
	}
	if(status == "RecomputeMatches" && A_Is64bitOS){
		Menu, Tray, Icon, shell32.dll, 240 ; pretty green clock
		return
	}
	
	if(status == "create_al_Address" && A_Is64bitOS){
		Menu, Tray, Icon, shell32.dll, 250 ; pretty green stick
		return
	}
	
	if(status <> "loaded" && A_Is64bitOS){
		Menu, Tray, Icon, shell32.dll, 266 ; pretty black clock
    ;  Menu, Tray, Icon, shell32.dll, 44 ; star
		
		return
	}
	
	; G:\fre\git\github\global-IntelliSense-everywhere-Nightly-Build\Source\icon\abc123\GI-nightly.gif
	; if(inst
	
	if(g_config.tray.iconFileAddress){
		iconAdress := g_config.tray.iconFileAddress
	}else{
		ScriptNameLetter2 := SubStr(A_ScriptName, 1 , 2)
		iconAdress=%A_ScriptDir%\icon\abc123\%ScriptNameLetter2%.ico
	}
	Menu, Tray, Icon, %iconAdress%
}
;\____ setTrayIcon __ 181107175118 __ 07.11.2018 17:51:18 __/









;/¯¯¯¯ ObjToStrTrim ¯¯ 181111193648 ¯¯ 11.11.2018 19:36:48 ¯¯\
ObjToStrTrim(o, showEmpty := false){
	ret := ((s:=Trim(ObjToStr(o, showEmpty)," `t`r`n")) ? ">" s "<`n" : "")
    ; MsgBox,16,% ret,,1
	return ret
}
;\____ ObjToStrTrim __ 181111193651 __ 11.11.2018 19:36:51 __/



;/¯¯¯¯ ObjToStr ¯¯ 181111193656 ¯¯ 11.11.2018 19:36:56 ¯¯\
; https://autohotkey.com/board/topic/66496-object-fromto-file-or-string-data-structures/
ObjToStr(Obj,  showEmpty := false, Rows="`n", Equal=" = ", Indent="`t", Depth=7, CurIndent="") {	; converts object to string
	For k,v in Obj
	{
		if(!showEmpty && !v)
			continue
		ToReturn .= CurIndent (IsObject(v) && depth>1 ? Rows ObjToStr(v
		,  showEmpty ,Rows, Equal, Indent, Depth-1, CurIndent Indent) : Equal ? "   " k "= """ v """" : "") Rows
	}
	return RTrim(ToReturn, Rows)
}	; http://www.autohotkey.com/forum/post-426623.html#426623
;\____ ObjToStr __ 181111193702 __ 11.11.2018 19:37:02 __/

;/¯¯¯¯ ObjSToStrTrim ¯¯ 181113093456 ¯¯ 13.11.2018 09:34:56 ¯¯\
ObjSToStrTrim(ByRef str, o*) {
	; This is interesting for debugging. control to see is actually happening. 18-11-12_18-16
	; fileappend, % "#/¯ contDoObj(" A_LineNumber ")=`n" ObjToStrTrim(contDoObj) , % devTestTxtFile, UTF-8
	; For each, param in o
	For nr, param  in o
	{
		strNew := ObjToStrTrim(param) 
		if(strNew)
			str .= nr ":" strNew
	}
	str .= "\_________________________________/`n" 
}
;\____ ObjSToStrTrim __ 181113093505 __ 13.11.2018 09:35:05 __/






;/¯¯¯¯ doAsimpleCopyOfLine ¯¯ 181117000836 ¯¯ 17.11.2018 00:08:36 ¯¯\
doAsimpleCopyOfLine(ByRef rootCmdTypeObj,infoBox := ""){
	doAsimpleCopy  := ( 	(	!rootCmdTypeObj.is_rr 
	&&	!rootDoObj.collectBlock
	&& 	!rootCmdTypeObj.is_IndexedAhkBlock
	&& 	!rootCmdTypeObj.is_multiline_r
	&& 	!rootCmdTypeObj.is_multiline_rr
	&& 	!rootCmdTypeObj.is_synonym  )
	|| 		rootCmdTypeObj.is_str )
			; && 	!rootCmdTypeObj.is_without_keywords
	if(false){
		m =
		(
doAsimpleCopy = >>%doAsimpleCopy%<<
infoBox = >>%infoBox%<<
		)
		ObjSToStrTrim(s:="",rootCmdTypeObj) 
		infoBox .= "`n" m "`n---------------`n" s "("  A_LineNumber ")"
		MsgBox, % infoBox
	}
	return doAsimpleCopy 
}
;\____ doAsimpleCopyOfLine __ 181117000840 __ 17.11.2018 00:08:40 __/




;/¯¯¯¯ isWithValueArea ¯¯ 181117000848 ¯¯ 17.11.2018 00:08:48 ¯¯\
isWithValueArea(ByRef rootCmdTypeObj,infoBox := ""){
	if(rootCmdTypeObj.is_str)
		hasValueArea  := false
	else
		hasValueArea  := true
	if(infoBox){
		m =
		(
		)
		ObjSToStrTrim(s:="",rootCmdTypeObj) 
		infoBox .= m "`n---------------`n" s "("  A_LineNumber ")"
		MsgBox, % infoBox
	}
	return hasValueArea
}
;\____ isWithValueArea __ 181117000853 __ 17.11.2018 00:08:53 __/












; https://stackoverflow.com/questions/27157174/autohotkey-source-code-line-break
; Method #1: A line that starts with "and", "or", ||, &&, a comma, or a period is automatically merged with the line directly above it (in v1.0.46+, the same is true for all other expression operators except ++ and --). In the following example, the second line is appended to the first because it begins with a comma:

;/¯¯¯¯ Loop_Parse_ParseWords_LoopField ¯¯ 181110211433 ¯¯ 10.11.2018 21:14:33 ¯¯\
; thats the place very updates from the file are inserted into the database. this you shuld never delte.
Loop_Parse_ParseWords_LoopField( IsAtEOF
, Aindex, ByRef ALoopField
, ByRef strDebug4insert, ByRef strDebugByRef
, ByRef rootLineObj, ByRef rootCmdTypeObj, ByRef rootCollectObj, ByRef rootDoObj
, ByRef contLineObj, ByRef contCmdTypeObj, ByRef contCollectObj, ByRef contDoObj ){

global g_ignReg
; g_actionListID < == helsp debugging logfile names 19-04-05_08-21
; toolTipGui(actionList "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")" ,,,"_",A_LineNumber,"Purple")  ; x will be offset if y is symbolic


if(1 && g_config.debug.active ){
	g_ignReg["feedbackMsgBox"]["tit"]  := ( Aindex >= 1 ) ? ".^" : "." ; ".^"  means ingnores nothing
	g_ignReg["saveLogFiles"]["scriptName"] := ".^" ; g_ignReg["feedbackMsgBox"]["tit"]
}else{
	g_ignReg["saveLogFiles"]["scriptName"] := "." ; following ".^"  means ingnores nothing
	g_ignReg["feedbackMsgBox"]["tit"]  := "." ; following ".^"  means ingnores nothing
}

lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , A_ThisFunc " i am started" )

lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )


if(!Aindex){
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	msgBox, that schould never happens %Aindex% : %ALoopField%
	Return "continue"
}


; here is  the entry point where it always starts. outside of a blog
; since we are not in a block
; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"),Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )

if( !rootLineObj.Aindex
	|| rootLineObj.Aindex == contLineObj.Aindex){  ; maybe cont is empty thats ok then.
	rootLineObj := { value:ALoopField, Aindex: Aindex }
	
	; rootLineObj := { value:ALoopField, Aindex: Aindex }
    ; isCommandType := setCommandTypeS(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj ) ; <=
	
    ; rootDoObj.collectBlock := ""
	if(rootDoObj.collectBlock)
		msgbox,% "ups. rootDoObj.collectBlock= " rootDoObj.collectBlock "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
}
if( rootLineObj.Aindex == contLineObj.Aindex ){ ; maybe cont is empty thats ok then. 
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	if(1 && g_config.debug.active ){
		ToolTip, % "Oops should not happen 18-11-15_14-10 " rootLineObj.Aindex " == " contLineObj.Aindex
		msgbox, % "Oops should not happen 18-11-15_14-10 " rootLineObj.Aindex " == " contLineObj.Aindex
	}
}

; isCommandType := setCommandTypeS(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj ) ; <= this has destoid  is_multiline_r
if(!rootDoObj.collectBlock){ ; dont need it it was may done into the content loop. probalby only first time.
	
	if( RegExMatch( ALoopField, "^[ ]*([#;]|[ ]*$)" )) ; if not in block cut out includes, comments and empty lines from the beginnern
		Return "continue"
	
	ALoopField := RegExReplace(ALoopField, "^[ ]+","") ; if not in block cut out leading spaces
	
	rootLineObj := { value:ALoopField, Aindex: Aindex }
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	isCommandType := setCommandTypeS(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
}

doAsimpleCopy := doAsimpleCopyOfLine( rootCmdTypeObj ) ; ,rootLineObj.value "?=" ALoopField)
if(doAsimpleCopy){
	
	if( rootDoObj.createKeys || rootCmdTypeObj.is_without_keywords ) {
		AddWordReplacement :=  substr(rootLineObj.value, rootCmdTypeObj.pos_value )
		rootLineObj.newKeywords := getAutoKeywords(AddWordReplacement)
		rootLineObj.value := rootLineObj.newKeywords rootLineObj.value
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , Aindex ":00000>" rootLineObj.newKeywords "<0000=rootLineObj.newKeywords" )
		
	}
	
	if(isValid:=CheckValid( rootLineObj.value )){
		AddWordToList(rootCmdTypeObj,strDebug4insert
		,strDebugByRef
		,A_LineNumber
		,Aindex
		, rootLineObj.value
		, 0
		,"ForceLearn"
		,LearnedWordsCount
		,rootCmdTypeObj.is_IndexedAhkBlock
		,doAsimpleCopy)
	}
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , isValid "=isValid`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	deepCopy_contObj_2_rootObj(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj ; Now we can reuse the END as the BEGINNING (copy that):
	, contLineObj, contCmdTypeObj, contCollectObj, contDoObj)
	Return "break" ; free for everything happens next	
}

if(isWithValueArea(rootCmdTypeObj)){
	; rootLineObj.posBehindKeywords := (p:=instr(rootLineObj.value,"|")) ? p : 1
	if( rootLineObj.posBehindKeywords := instr(rootLineObj.value,"|") )
		rootLineObj.oldKeywords := substr(rootLineObj.value,1, rootLineObj.posBehindKeywords - 1)
	else
		rootLineObj.oldKeywords := rootLineObj.value
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
}

; we got it and the contant we take during the next loops 18-11-15_15
if( rootDoObj.collectBlock && Aindex == rootLineObj.Aindex ) ; first contact
{
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	Return "continue"
}







if(!rootDoObj.collectBlock && ( rootCmdTypeObj.is_str || rootCmdTypeObj.is_r)){
	if(rootLineObj.value){
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), " oldKeywords=" oldKeywords "`n"  " newKeywords=" newKeywords "`n" ObjSToStrTrim(s:="", rootCollectObj) s )
		valud2DB := rootLineObj.value ; add a replacment or simple sting 13.11.2018 10:26
		AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, valud2DB , 0,"ForceLearn",LearnedWordsCount, rootCmdTypeObj.is_IndexedAhkBlock)
	}
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	return "break"
}


lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )


if( !rootDoObj.collectBlock && !rootDoObj.createKeys && CheckValid(rootLineObj.value) ){
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	
	AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, rootLineObj.value , 0,"ForceLearn",LearnedWordsCount, isIndexedAhkBlock)
	if(g_config["FuzzySearch"]["enable"] && Aindex < g_config["FuzzySearch"]["MAXlines"]){
		addFuzzySearch_in_generatedList(rootLineObj.value, actionList,Aindex,LearnedWordsCount,g_config["FuzzySearch"]["keysMAXperEntry"],g_config["FuzzySearch"]["minKeysLen"])
	}
	Return "continue"
}

firstWordInLine := ( RegexMatch(ALoopField,"i)^\s*(\w+)",Match) ) ? Match1 : ""
; Tooltip, % firstWordInLine

        ;/¯¯¯¯ if(rootDoObj.collectBlock) ¯¯ 181111201107 ¯¯ 11.11.2018 20:11:07 ¯¯\
if(rootDoObj.collectBlock && ( Aindex <> rootLineObj.Aindex ) ){	
	; lets waiting for the end of the Block 18-11-12_20-13
	cto := rootCmdTypeObj ; For shorter reading
	isPrefixMultilineAHK := ( cto.codePrefixChar == "(" || cto.codePrefixChar == "[" )
	strDebugByRef .= "`n  /" ALoopField "≠" rootLineObj.value "└" cto.codePrefixChar "=" rootCmdTypeObj.codePrefixChar "┘  " 
	
	if(isPrefixMultilineAHK && trim(ALoopField) == ")"){
        ; ObjSToStrTrim(strDebugByRef,rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj)
		rootCollectObj.value .= "send,`% it`n"
		valud2DB := rootLineObj.value  "`n" rootCollectObj.value
		AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, valud2DB , 0,"ForceLearn",LearnedWordsCount, isIndexedAhkBlock)
					; if(g_config["FuzzySearch"]["enable"] && Aindex < g_config["FuzzySearch"]["MAXlines"])
					; 	addFuzzySearch_in_generatedList(valud2DB, actionList,Aindex,LearnedWordsCount,g_config["FuzzySearch"]["keysMAXperEntry"],g_config["FuzzySearch"]["minKeysLen"])
					; break ; <============= debugging
		if(IsAtEOF){
			msgbox,% A_LineNumber   "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
			BreakOrContinue := "break"
		}
		
		; deeo copy here is wrong.
		; deepCopy_contObj_2_rootObj(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj , contLineObj, contCmdTypeObj, contCollectObj, contDoObj)
		
		rootLineObj := { value: "", Aindex: 0, oldKeywords:"", newKeywords:"" }
		rootCmdTypeObj :=  { is_str: false , is_r: false , is_rr: false, is_multiline_r: false, is_multiline_rr: false }
		rootCollectObj := { value: "", is_ended: false } ; .value .is_ended
		rootDoObj := { collectBlock: false, createKeys: false}
		
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
		
		Return "continue"
	}
	
	
	if(RegExMatch( ALoopField , "i)\bGi\s*\:\s*do_indexFollowingLines4search\s*[\:]?=\s*true\b" )) { ; Gi: do_indexFollowingLines4search := true
		rootCmdTypeObj.is_IndexedAhkBlock := true
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		; Return "continue"
		; comments: https://autohotkey.com/boards/viewtopic.php?f=6&t=45684&p=242652&hilit=do_indexFollowingLines4search#p242652
		; no entry: https://g-intellisense.myjetbrains.com/youtrack/issues?q=project:%20g-IntelliSense%20do_indexFollowingLines4search
		
		return "continue" ; dont store the meta-command into the database so let this row out.
	}	
	
	if(contLineObj.Aindex <= rootLineObj.Aindex &&  contLineObj.Aindex){ ; contLineObj.Aindex  is at the beginning empty
		m := contLineObj.Aindex " < " rootLineObj.Aindex	
		if(1 && g_config.debug.active )
			ToolTip, % m " never happens ??? 18-11-15_00" "`n(" actionList ">" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	}
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	
	; lets waiting for the end of the Block 18-11-12_20-13
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	if(Aindex <> rootLineObj.Aindex ){
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
		contLineObj := { value:ALoopField, Aindex: Aindex }
		isCommandType_inBlock := setCommandTypeS(contLineObj, contCmdTypeObj, contCollectObj, contDoObj )
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	}
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	;ObjSToStrTrim(strOfAllResultsForAnalysisOrDebugging,contLineObj, contCmdTypeObj, contCollectObj, contDoObj )
;	feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	
	; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"),Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"),Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	; g_ignReg["feedbackMsgBox"]["tit"] := "."
	
	
	; if(isCommandType_inBlock)
	; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), isCommandType_inBlock "=isCommandType_inBlock , " ObjSToStrTrim(s:="", rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" IsAtEOF  "'=IsAtEOF `n"  ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	
	
	isIndexEqual := ( contLineObj.Aindex <> rootLineObj.Aindex ) 
	isRelavantCommandFound := ( contDoObj.collectBlock
	|| contCmdTypeObj.is_r
	|| contLineObj.is_without_keywords ) ; !isIndexEqual && 
	if( isRelavantCommandFound || IsAtEOF ){
		if( rootDoObj.collectBlock && !isRelavantCommandFound ){
			rootCollectObj.value .= contLineObj.value "`n"
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n#####" rootCollectObj.value  "#####")
		}
		
		if( !rootLineObj.newKeywords 
			&& ( rootDoObj.createKeys || rootCmdTypeObj.is_without_keywords ) ) {
			rootLineObj.newKeywords := getAutoKeywords(temp:= firstWordInLine " " rootLineObj.oldKeywords " " rootCollectObj.value)
			tempK := rootLineObj.newKeywords
			if(0){
				tip =
                (
                %tempK%#%temp%
                )
				clipboard := tip
				tooltip,% tip
				pause
			}
			
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , Aindex ":00000>" rootLineObj.newKeywords "<0000=rootLineObj.newKeywords" )
		}
		if(isPrefixMultilineAHK){
			rootCollectObj.value := rTrim(rootCollectObj.value," `t`r`n")
			rootCollectObj.value .= "`n)`nSend,% it"
		}
		if(0 && rootCmdTypeObj.is_without_keywords){
			strDebugByRef .= ">>>>>" rootCmdTypeObj.is_without_keywords
			msgBox, % strDebugByRef "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
		}
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		; if(0 && rootDoObj.collectBlock && !rootDoObj.is_without_keywords ){
		if(rootDoObj.createKeys || rootCmdTypeObj.is_without_keywords ){
			; newKeyWords := getAutoKeywords(temp:= rootLineObj.value " "  rootLineObj.oldKeywords " " rootCollectObj.value)
			valud2DB := setInNewKeywordsIntoLine( rootLineObj.newKeywords , rootLineObj.value ) "`n" rootCollectObj.value 
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , rootLineObj.newKeywords ":" newKeyWords )
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" rootLineObj.value "'=ALoopField`n###" valud2DB "###")
		}else{
			valud2DB := rootLineObj.value  "`n" rootCollectObj.value 
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" rootLineObj.value "'=ALoopField`n###" valud2DB "###")
		}
		if(0 && !instr(rootCollectObj.value,"bit of "))
			pause 
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" rootLineObj.value "'=ALoopField`n#" rootCollectObj.value  "#")
		
		
		if(0){
		; doAsimpleCopy := true
			tempLineObj :=  { value:valud2DB, Aindex: Aindex }
			isCommandType_temp := setCommandTypeS(tempLineObj, tempCmdTypeObj, tempCollectObj, tempDoObj )
			msgbox,% valud2DB "########################"
		}
		
		AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, valud2DB , 0,"ForceLearn",LearnedWordsCount, isIndexedAhkBlock,doAsimpleCopy)
		
        ; dirty bugfid: 26.11.2018 13:49 todo: prettyfy
		if(contCmdTypeObj.is_r)
			AddWordToList(contCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, contLineObj.value , 0,"ForceLearn",LearnedWordsCount, isIndexedAhkBlock,doAsimpleCopy)
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		if( false && rootCmdTypeObj.is_without_keywords) { ; ; && g_config["FuzzySearch"]["enable"] ; && Aindex < g_config["FuzzySearch"]["MAXlines"]
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
			addFuzzySearch_in_generatedList(valud2DB, actionList,Aindex,LearnedWordsCount
			,g_config["FuzzySearch"]["keysMAXperEntry"],g_config["FuzzySearch"]["minKeysLen"])
			; Pause,On
		}
		if(IsAtEOF){
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>IsAtEOF='" IsAtEOF )
		}
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">cont>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
		deepCopy_contObj_2_rootObj( rootLineObj
		, rootCmdTypeObj
		, rootCollectObj
		, rootDoObj
		, contLineObj
		, contCmdTypeObj
		, contCollectObj
		, contDoObj) ; ; Now we can reuse the END as the BEGINNING (copy that):
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">cont>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
		Return "continue"
	} ; EndOf isCommandType_inBlock
	;\____ isCommandType_inBlock __ 181125225846 __ 25.11.2018 22:58:46 __/
	;\____ isCommandType_inBlock __ 181125225846 __ 25.11.2018 22:58:46 __/
	
	if(cto.is_IndexedAhkBlock && !IsAtEOF ){
		if(trimLineInBlock := trim(contLineObj.value," `t`r`n")){
			newKeywords := getAutoKeywords(trimLineInBlock)
		;	feedbackMsgBox(RegExReplace(A_LineFile,".*\\") ">" A_LineNumber, " oldKeywords=" oldKeywords "`n"  " newKeywords=" newKeywords "`n" ObjSToStrTrim(s:="", rootCollectObj) s )
			valud2DB := newKeywords "|r|" trimLineInBlock "`n" ; add a replacment or simple sting 13.11.2018 10:26
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , AIndex ":" valud2DB )
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
			
			AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, valud2DB , 0,"ForceLearn",LearnedWordsCount, rootCmdTypeObj.is_IndexedAhkBlock)
		}
	}  
	
	if( 1 && ALoopField == "|r|"){ 
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
		msgbox,%A_LineNumber% could never happen 18-11-15_14-52
	}	
	rootCollectObj.value .= ALoopField "`n"  ; there may not be any no content object here
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , AIndex ":## rootCollectObj = ##" rootCollectObj.value "####" )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	
	; weeee are inside a block ... 
	backup := g_ignReg["feedbackMsgBox"]["tit"] ;
	g_ignReg["feedbackMsgBox"]["tit"]  :=  backup
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
	Return "continue"
} ; EndOf: if(rootDoObj.collectBlock)
;\____ if(rootDoObj.collectBlock)
; Return "continue"
if(ALoopField == "|r|"){
	msgbox,%A_LineNumber%: could never happen 18-11-15_14-52
}
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ":'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",contLineObj, contCmdTypeObj, contCollectObj, contDoObj) s )
Return "break"
}
;\____ Loop_Parse_ParseWords_LoopField __ 181117033800 __ 17.11.2018 03:38:00 __/


;_
; tool msg __ 


;/¯¯¯¯ deepCopy_contObj_2_rootObj ¯¯ 181117032957 ¯¯ 17.11.2018 03:29:57 ¯¯\
deepCopy_contObj_2_rootObj(rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj
, contLineObj, contCmdTypeObj, contCollectObj, contDoObj){
		; rootLineObj.Aindex := contLineObj.Aindex
rootLineObj.Aindex := contLineObj.Aindex ; this explicite copy of eache attribute does no speccel effect. dont need it probalby 18-11-14_23-24
contLineObj.Aindex := 0

rootLineObj.value                   := contLineObj.value
rootLineObj.oldKeywords             := "" ; contCmdTypeObj.oldKeywords
rootLineObj.newKeywords             := "" ; contCmdTypeObj.oldKeywords
; rootDoObj.collectBlock := ""
; rootDoObj.collectBlock := true
rootDoObj.collectBlock              := contDoObj.collectBlock
rootDoObj.createKeys                := contDoObj.createKeys

rootCmdTypeObj.pos_value            := contCmdTypeObj.pos_value
rootCmdTypeObj.codePrefixChar       := contCmdTypeObj.codePrefixChar
rootCmdTypeObj.is_ended             := contCmdTypeObj.is_ended
rootCmdTypeObj.is_IndexedAhkBlock   := contCmdTypeObj.is_IndexedAhkBlock ;
rootCmdTypeObj.is_multiline_r       := contCmdTypeObj.is_multiline_r
rootCmdTypeObj.is_multiline_rr      := contCmdTypeObj.is_multiline_rr
rootCmdTypeObj.is_r                 := contCmdTypeObj.is_r
rootCmdTypeObj.is_rr                := contCmdTypeObj.is_rr
rootCmdTypeObj.is_str               := contCmdTypeObj.is_str
rootCmdTypeObj.is_synonym           := contCmdTypeObj.is_synonym
rootCmdTypeObj.is_without_keywords  := contCmdTypeObj.is_without_keywords
backup := g_ignReg["feedbackMsgBox"]["tit"] ;
rootCollectObj.value                := contCollectObj.value
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , "ooooo>" rootCollectObj.value "<ooooo" )


		; g_ignReg["feedbackMsgBox"]["tit"]  :=  ".^"  means ingnores nothing
contLineObj.value := ""
contCollectObj.value := ""
contLineObj.oldKeywords := ""
contLineObj.newKeywords := ""
contCmdTypeObj.codePrefixChar := ""
contCmdTypeObj.is_ended := false
contCmdTypeObj.is_IndexedAhkBlock := false
contCmdTypeObj.is_multiline_r := false
contCmdTypeObj.is_multiline_rr := false
contCmdTypeObj.is_r := false
contCmdTypeObj.is_rr := false
contCmdTypeObj.is_str := false
contCmdTypeObj.is_synonym := false
contCmdTypeObj.is_without_keywords := false
contDoObj.collectBlock := false
contDoObj.createKeys := false
}
;\____ deepCopy_contObj_2_rootObj __ 181117033024 __ 17.11.2018 03:30:24 __/







;/¯¯¯¯ Loop_Parse_ParseWords ¯¯ 181114082712 ¯¯ 14.11.2018 08:27:12 ¯¯\
; ParseWords is a list entries seperated by newLine
Loop_Parse_ParseWords(ByRef ParseWords){
	global g_config
	global actionList
	global doReadThisActionListEverySeconds
	
	global strDebugByRef
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , "i am started. actionList=`n" actionList )
	
	;lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
	
	
	
	devTestTxtFile := doReadThisActionListEverySeconds "_temp.txt"
	
	; rootLineObj := { value: "" }
	
	rootLineObj := { value: "", Aindex: 0, oldKeywords:"", newKeywords:"" }
	rootCmdTypeObj :=  { is_str: false , is_r: false , is_rr: false, is_multiline_r: false, is_multiline_rr: false }
	rootCollectObj := { value: "", is_ended: false } ; .value .is_ended
	rootDoObj := { collectBlock: false, createKeys: false}
	
	contLineObj := { value: "", Aindex: 0, oldKeywords:"", newKeywords:"" }
	contCmdTypeObj := { is_str: false , is_r: false , is_rr: false, is_multiline_r: false, is_multiline_rr: false }
	contCollectObj := { value: "", is_ended: false } ; .value .is_ended
	contDoObj := { collectBlock: false, createKeys: false}
	
	strOfAllResultsForAnalysisOrDebugging	:= "" ; ObjSToStrTrim(strOfAllResultsForAnalysisOrDebugging,)
	strDebug4insert	:= "" 
	strDebugByRef	:= "" ; ObjSToStrTrim(strOfAllResultsForAnalysisOrDebugging,)
	
	Aindex := 0
	ALoopField := ""
	IsAtEOF := false
	isNo_RegularSource_foundTillYet := true
	Loop, Parse, ParseWords , `n, `r
	{
		Aindex := A_Index
		
        ;/¯¯¯¯ excludeLine ¯¯ 190406211230 ¯¯ 06.04.2019 21:12:30 ¯¯\
        ; may ; is part of your sourcecode. so we may not could exlude this here
        ; is it all from the beginning not useful source? test it:
        ; || !trim(A_LoopField,"`n`r`t ") ) ){
		if(isNo_RegularSource_foundTillYet)
			if( !RegExMatch( A_LoopField, "^[ ]*([#;]|[ ]*$)" )) ; cut of includes, comments and empty lines from the beginnern
				isNo_RegularSource_foundTillYet := false
		else
			continue
        ;MsgBox,,% "found: " A_LoopField ,% A_LoopField "`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
        ;\____ excludeLine __ 190406211232 __ 06.04.2019 21:12:32 __/
		
		ALoopField := A_LoopField
		
		if(RegExMatch(ALoopField, "i)(?P<A>ToolTip)",found)){
			toolTipGui("super >" foundA "< found(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")" ,x:=1,y:=1,"_",A_LineNumber,"yellow")  ; x will be offset if y is symbolic be offset if y is symbolic
			
			; MsgBox,,% ":) ^_^ `n" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% ":(`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		}
		
		ParseWordsSubCount++
		; ALoopField := trim(A_LoopField,"`r`n")
		;ALoopField := trim(A_LoopField,"`r`n")
		
		contLineObj.value := "" ; may not needet but so more clear how it works.
		contCollectObj.value := "" ; may not needet but so more clear how it works.
		
		BreakOrContinue := Loop_Parse_ParseWords_LoopField(IsAtEOF
		, Aindex, ALoopField
		, strDebug4insert, strDebugByRef
		, rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj
		, contLineObj, contCmdTypeObj, contCollectObj, contDoObj )
		
		; msgBox, % ALineNumber
		
	}
	; msgBox , % BreakOrContinue 
	if(BreakOrContinue <> "break"){ ; The loop is artificially kept alive one time. so that the event enofOfFile can be responded inside there.
		IsAtEOF := true
		Aindex++
		ALoopField := ""
		; msgBox , % Aindex
		
		contLineObj.value := "" ; may not needet but so more clear how it works.
		contCollectObj.value := "" ; may not needet but so more clear how it works.
		
		Loop_Parse_ParseWords_LoopField(IsAtEOF ; only this shows that the file is at the end. everything else stays the same
		, Aindex, ALoopField ; simulate a longer run.
		, strDebug4insert, strDebugByRef
		, rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj
		, contLineObj, contCmdTypeObj, contCollectObj, contDoObj )
	}
	
	;msgBox, % "strDebugByRef = " strDebugByRef  "`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\")
	
	return strDebug4insert ; strDebugByRef ; interesting its not be changed in this function but it is passed by reference } }}  } } } } } } } } } 
	
	   ; https://autohotkey.com/boards/viewtopic.php?f=6&t=45684&p=242652&hilit=do_indexFollowingLines4search#p242652
        ; if(rootDoObj.collectBlock){
        ; 	if(RegExMatch( A_LoopField , "i)\bGi\s*\:\s*do_indexFollowingLines4search\s*[\:]?=\s*true\b" )) {
        ; 		    ; Gi: do_indexFollowingLines4search := true
        ; 		rootCmdTypeObj.is_IndexedAhkBlock := true
        ; 		rootDoObj.collectBlock := false
        ; }	}
	
	
        ; ALoopField  := RegExReplace(ALoopField, "^\s+" , "" ) ; like ltrim or the same? 06.11.2017 18:28
        ;	if(RegExMatch( ALoopField , "i)^([^; ]*[^\n]+\|rr\|[ ]*$",  m )){
        ;		; if(0 && g_config.debug.active)
        ;		speak("Synonym found","PROD")
	
        ; regIs_r_synonym := "^([^\|\n]+?)\|r\|[ ]*$"
        ; if(RegExMatch( ALoopField , regIs_r_synonym ,  m )){
        ;	rX := {key:m1, rr:"r", send:"", lang:"" ,code:""}
            ; create a working synonym:
        ;	ALoopField := rX["key"] "|rr||ahk|"
		;\____ Loop __ 181109170852 __ 09.11.2018 17:08:52 __/
        ; } until (File.AtEOF)
	
}











;/¯¯¯¯ setCommandTypeS ¯¯ 181110182307 ¯¯ 10.11.2018 18:23:07 ¯¯\
;/¯¯¯¯ setCommandTypeS ¯¯ 181110182307 ¯¯ 10.11.2018 18:23:07 ¯¯\
;/¯¯¯¯ setCommandTypeS ¯¯ 181110182307 ¯¯ 10.11.2018 18:23:07 ¯¯\
;/¯¯¯¯ setCommandTypeS ¯¯ 181110182307 ¯¯ 10.11.2018 18:23:07 ¯¯\
;/¯¯¯¯ setCommandTypeS ¯¯ 181110182307 ¯¯ 10.11.2018 18:23:07 ¯¯\
; Whether you pass an object as ByRef or not ByRef, any changes to the object are permanent. Does whether a parameter is ByRef or not have any effect on objects? Are there performance advantages/disadvantages, or other consequences? https://autohotkey.com/boards/viewtopic.php?t=46310
setCommandTypeS(rootLineObj
, rootCmdTypeObj
, rootCollectObj
, rootDoObj ){
		; .is_str .is_r .is_rr .is_multiline_r .is_multiline_rr .codePrefixChar
		; .value .is_ended
    ; rootCmdTypeObj := { is_str: ...
    ; rootCollectObj := { value: value, is_ended: is_ended }
    ; Speak( A_ThisFunc, "PROD" )
if(trim(!rootLineObj.value)){
	return false
}

    ;/¯¯¯¯ initialization ¯¯ 181125235523 ¯¯ 25.11.2018 23:55:23 ¯¯\
    ; wee dont need it... was try to bugfix
rootCmdTypeObj.is_multiline_r := false
rootCmdTypeObj.is_without_keywords := false
    ;\____ initialization __ 181125235527 __ 25.11.2018 23:55:27 __/



regIs_r  := "^([^\|\n]*?)\|r\|.+"
if(RegExMatch( rootLineObj.value , regIs_r ,  m )){
	rootDoObj.collectBlock := false
	rootCmdTypeObj.is_r := true
	rootCmdTypeObj.pos_value := strlen(m1) + 4
		; msgbox,% rootLineObj.value "`n(" A_LineFile "~" A_LineNumber ")"
	if(!m1)
		rootCmdTypeObj.is_without_keywords := true
}else{
	rootCmdTypeObj.is_r := false
}

regIs_multiline_r  := "^([^\|\n]+?)\|r\|([ ]*?)$"
if(!rootCmdTypeObj.is_r && RegExMatch( rootLineObj.value , regIs_multiline_r ,  m )){
	rootDoObj.collectBlock := true
	rootCmdTypeObj.is_multiline_r := true
	rootCmdTypeObj.pos_value := strlen(m1) + 4
	rootCollectObj.value := ALoopField ; <=== === is always empty ??? ;) :D
		;msgbox, % substr(rootLineObj.value, rootCmdTypeObj.pos_value - 2 )
		; msgbox,% rootLineObj.value "`n(" A_LineFile "~" A_LineNumber ")"
}

if(0){
	   ; deprecated since 22.10.2018 12:13
	if(g_config.debug.active)
		msgBox,% ALoopField "??? deprecated since 22.10.2018 12:13(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	regIs_r_synonym := "^([^\|\n]+?)\|r\|[ ]*$"
	if(RegExMatch( ALoopField , regIs_r_synonym ,  m )){
		rX := {key:m1, rr:"r", send:"", lang:"" ,code:""}
                                ; create a working synonym:
		ALoopField := rX["key"] "|rr||ahk|"
                                ; msgBox,% ALoopField "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	}
}

; regIsXXXcode := "^([^\|\n]+?)\|(rr)\|(?:([^\n]*?)(?:\|([a-zA-Z_]{3,45})\|)+(.*?)$)*" ; since today we using ahk blocks. newline could be posible
regExRunner := "[a-zA-Z_]{3,45}"

if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|rr\|[ ]*$",  m )){
	rootCmdTypeObj.is_rr := true
	rootCmdTypeObj.is_synonym := true
	if(1 && g_config.debug.active){
			; speak("Synonym found","PROD")
		tooltip,% ALoopField "`nSynonym found :)`n" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% ":)`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		msgbox,% ALoopField "`nSynonym found :)`n" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% ":)`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	}
}else
	rootCmdTypeObj.is_rr := false

	; if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|ahk\|)[^\s]{2,}+",  m )){
if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|" regExRunner "\|)[^\s]{2,}+",  m )){
	rootCmdTypeObj.is_rr := true
	rootCmdTypeObj.is_IndexedAhkBlock := false ; maybe its set in next line
}


if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|ahk\|)([^\s]?)[ ]*$",  m )){
	rootCmdTypeObj.is_rr := true
	rootCmdTypeObj.is_IndexedAhkBlock := false ; maybe its set in next line
	if(m2){
		if(m2 == "(" || m2 == "["){
			if(m2 == "[")
				rootCmdTypeObj.is_IndexedAhkBlock := true
			rootCmdTypeObj.codePrefixChar := m2
			m2 := "`it =`n(`n"
                ; MsgBox,% codePrefixChar "=codePrefixChar(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
                ; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , codePrefixChar "=codePrefixChar" )
			rootDoObj.collectBlock := true ; may not  unnecessary action
			rootCmdTypeObj.is_multiline_rr := true ; may not  unnecessary action
		}
		if(m2 == "q"){
			rootCmdTypeObj.is_rr := true
			rootCmdTypeObj.is_synonym := true
			if(1 && g_config.debug.active)
				speak("Synonym found","PROD")
		}else
			rootCollectObj.value := m2 ; A_LineNumber "ö"
		
			; rootCollectObj.value := m1 m2
		
	}
        ; msgbox,% rootCollectObj.value
}



	; if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|rr\|)(ahk\|)[ ]*$",  m )){
if(RegExMatch( rootLineObj.value , "i)^([^; ]*[^\n]+\|rr\|)(" regExRunner "\|)[ ]*$",  m )){
	msg := "Maybe an ERROR?"
	if(1 && g_config.debug.active){
		speak("Maybe an ERROR?","PROD")
		MsgBox,262160,% msg ":(`n" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% ":(`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		sleep,2000
	}
	probablyTried := (m2) ? m1 "|ahk|" : m1 "|ahk|"
	rootCmdTypeObj.is_rr := true
	rootLineObj.value := ""
    					;MsgBox,262208,% "Maybe an ERROR?",% ALoopField "`n is recognized as a simple text.`n Or do you actually want : `n`n" probablyTried "`n`n ? Thats what you want? :)`n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
}

rootCmdTypeObj.is_multiline_rr := false ; todo: thats a dirty bugfix . 10.11.2018 23:19
	; if(RegExMatch( rootLineObj.value , "i)^([^;\n ]*[^\n]+\|ahk\|)([^\s\n]?)[ ]*$",  m )){
if(RegExMatch( rootLineObj.value , "i)^([^;\n ]*[^\n]+\|" regExRunner "\|)([^\s\n]?)[ ]*$",  m )){
	if(m2 <> "q"){
            ; MsgBox,% codePrefixChar "=codePrefixChar(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
            ; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , codePrefixChar "=codePrefixChar" )
		rootCmdTypeObj.is_multiline_rr := true
		rootDoObj.collectBlock := true
	}
}

    ;/¯¯¯¯ collectBlock ¯¯ 181111082347 ¯¯ 11.11.2018 08:23:47 ¯¯\
regIs_without_keywords  := "^\|(r|rr)\|[ ]*$"
if(RegExMatch( rootLineObj.value , regIs_without_keywords, m )){
	if(m1=="r"){
			; rootLineObj.value := "" A_ThisFunc A_LineNumber " " rootLineObj.value ; for testing during deevlopment 06.11.2018 11:15
			; rootCmdTypeObj.is_r := true
		rootCmdTypeObj.is_multiline_r := true
	}if(m1=="rr"){
			;rootCmdTypeObj.is_rr := true
		rootCmdTypeObj.is_multiline_rr := true
	}
	rootCmdTypeObj.is_without_keywords := true 
		; rootCollectObj.value := "" 
	rootDoObj.createKeys := true ; https://g-intellisense.myjetbrains.com/youtrack/issues?q=project:%20g-IntelliSense#issueId=GIS-65
	rootDoObj.collectBlock := true
		 ; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), ObjSToStrTrim(s:="", rootLineObj, rootCmdTypeObj, rootCollectObj, rootDoObj) s )
} 
    ;\____ collectBlock __ 181111082353 __ 11.11.2018 08:23:53 __/


if(rootDoObj.collectBlock){
	if(!rootCmdTypeObj.codePrefixChar)
		rootCollectObj.value := "" ; initialice so later you could use .=
}

	; now plausibility checks. proof of programer does Bullshit or was lazy 10.11.2018 09:47
o := rootCmdTypeObj ; https://autohotkey.com/boards/viewtopic.php?f=76&t=58979&p=248157#p248157

if(!o.is_multiline_rr){
	rootCmdTypeObj.is_IndexedAhkBlock := false
	rootCmdTypeObj.codePrefixChar := ""
}
if(o.is_multiline_rr){
	rootCmdTypeObj.is_str := false
	o.is_r := false
	o.is_rr := false
	o.is_multiline_r := false
        ; o.is_multiline_rr := false
	
	
}else if(o.is_multiline_r){
	rootCmdTypeObj.is_str := false
	o.is_r := false
	o.is_rr := false
        ;o.is_multiline_r := false
	o.is_multiline_rr := false
}else if(o.is_rr){
	
	    ; rootDoObj.collectBlock ; o.is_rootCollectObj: = false
	
	o.is_str := false
	o.is_r := false
        ; o.is_rr := false
        ;o.is_multiline_r := false
        ;o.is_multiline_rr := false
}else if(o.is_r){
	
		    ; rootDoObj.collectBlock ; o.is_rootCollectObj: = false
	
	o.is_str := false
        ; o.is_r := false
	o.is_rr := false
        ;o.is_multiline_r := false
        ;o.is_multiline_rr := false
}else if(!o.is_r && !o.is_rr && !o.is_multiline_r && !o.is_multiline_rr ){
	
	    ; rootDoObj.collectBlock ; o.is_rootCollectObj: = false
	   	; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), ObjSToStrTrim(s,rootLineObj) s )
	o.is_str := true
}
if(o.is_str){
	o.is_r := false
	rootDoObj.collectBlock := false
	rootDoObj.createKeys := false 		
        ; o.is_multiline_r := false
        ; o.is_multiline_rr := false
	   	; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), ObjSToStrTrim(s,rootLineObj) s )
	
	return false
}
return true
}
;\____ setCommandTypeS







;/¯¯¯¯ addListOpenAction_ifNotAlreadyInTheList ¯¯ 181107004221 ¯¯ 07.11.2018 00:42:21 ¯¯\
addListOpenAction_ifNotAlreadyInTheList(ByRef contentActionList,ByRef actionList){
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
	return
; thats a way how you could add actionList lines vocabularies inside onlive 12.08.2017 23:24
; if you may destroy your path to your config file, thats a way to find it again.
;                        foundOpenLibLine := 0
	
	regEx__ := "m)^\s*__+[^`n]*\|rr\|\|ahk\|"
	
;                        foundOpenLibLine  := RegExMatch(A_LoopField, regEx__ )
;/¯¯¯¯ beginnings ¯¯ 181117101035 ¯¯ 17.11.2018 10:10:35 ¯¯\
; only in first lines is searched !!!
; so please put open dialog at beginnings
	contentActionList_first432lines := SubSTr( contentActionList , 1 , 123 ) ; we dont wann search the complete file.
;\____ beginnings __ 181117101038 __ 17.11.2018 10:10:38 __/
	
; adds a ___open library if not into the actionList
	
	postFixGenerated := "._Generated.ahk"
	actionListPostFix  := SubStr(actionList, - StrLen(postFixGenerated) + 1 )
	itsAGeneratedList := ( postFixGenerated == actionListPostFix )
        ; MsgBox,% msg "its a " postFixGenerated "`n ==> leave it hidden (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	if(!itsAGeneratedList && !RegExMatch(contentActionList_first432lines, regEx__ ) ){
		ToolTip,% actionList "`n`n " A_LineNumber   " "   RegExReplace(A_LineFile,".*\\")   " "   A_thisFunc
		SplitPath, actionList, , , , OutNameNoExt
		temp := "___open " OutNameNoExt "(actionList.ahk~" A_LineNumber "|rr||ahk|openInEditor," OutNameNoExt ".ahk"
		
		if(true){
			AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, temp,0,"ForceLearn",LearnedWordsCount)   ; springt dann in zeile 490 ungefähr
		}else{
			
            ; ; work but now we use the database direcly 18-10-03_21-51 OR???? ; work but now we use the database direcly 18-10-03_21-51 todo: need to be discussed. not importend
            ; or: regPatt := "^[^\n]*?([^\.\\\n]+)[^\\\n]*$"
            ; temp := RegExReplace(temp, "\._Generated\.txt\s*$", "")
			
			; its mow ByRef 18-11-17_09-14
			contentActionList .= "`n" . temp
            ; info := SubSTr( contentActionList , 1 , 150 ) ;     tooltip,%info% ... `n (%A_LineFile%~%A_LineNumber%) `
                        ; Msgbox,% temp "`n into `n`n" actionList "`(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"
		}
		return true 
	}
	return false
	; return contentActionList
}
;\____ addListOpenAction_ifNotAlreadyInTheList __ 181107004230 __ 07.11.2018 00:42:30 __/





; too msg kk

;/¯¯¯¯ addFuzzySearch_in_generatedList ¯¯ 181107004148 ¯¯ 07.11.2018 00:41:48 ¯¯\
; addFuzzySearch_in_generatedList(ALoopField)
addFuzzySearch_in_generatedList(ActionStr, actionList, lineNr, ByRef LearnedWordsCount, addKeysMAX := 7, minKeysLen := 4, doValueCopy := true){
	
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
    ; || !instr(actionList,"Generated.ahk")
	if( !lineNr ){
		Msgbox,% lineNr " `n= lineNr actionList=" actionList "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		return false
	}
	
	if( !ActionStr ){ ;_ahk_global.ahk._Generated.ahk
        ; examples log 02.10.2018 19:56: ..\actionLists\_globalActionLists\pfade.ahk(378 actionList.ahk)
	    ; Msgbox,% actionList "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		if(0 && instr(actionList,"Notepad_Administrator"))
			Msgbox,% actionList " `nlast=" substr(ActionStr ,0) "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		return false
	}
	
	
    ;Msgbox,% ActionStr " `nlast=" substr(ActionStr ,0) "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	if( substr(ActionStr,0) == "|" ){
		if(0 && instr(actionList,"Notepad_Administrator"))
			Msgbox,% ActionStr " `nlast=" substr(ActionStr ,0) "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		return false ; dont create synonyms from synonyms
	}
	pattern := "i)^[ ]*[^#_;\n]+\w"
	if( !RegExMatch(ActionStr, pattern ) ){
	    ; Msgbox,% ActionStr "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		return false
	}
	
    ; synonymValue|rr|     ; synonymValue|rr||ahk|q=keyValue
    ; Msgbox,% "ActionStr= " ActionStr "`n " `n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
    ;tooltip,% value " `n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	
	if(pos1 := InStr( ActionStr , "|" )){
		ActionStrKey := substr(ActionStr  ,1, pos1 - 1 )
		ActionStrVal := substr(ActionStr , pos1 )
		; Msgbox,% ActionStr "`n`nk= " ActionStrKey ", v= " ActionStrVal "`n `n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	}else{
		ActionStrKey := ActionStr
		ActionStrVal := ""
	}
	
	
    ; asdlkasdlf alsdk aösldkf aösldkfjasdölfkj
	
	camelCaseOr := "([^A-Z])[A-Z][a-z]+"
	normalOr := "([\W_-])[a-z]+"
	regEx := "(?:(" camelCaseOr "|" normalOr "))"
	StartingPosition  := 2
	addedKeysCounter := 0
	while(foundPos := RegexMatch( " " ActionStrKey, "O)" regEx, Match, StartingPosition - 1 )){
		StartingPosition := Match.Pos(1) + Match.Len(1)
		
		if(addedKeysCounter >= addKeysMAX)
			break
		if(a_index == 1) ; the first is stored into the complete actionList
			continue
		preCar1 := Match.Value(2)
		preCar2 := Match.Value(3)
		;if(preCar1=="|" || preCar2=="|")
		;	break
		keyTemp := Match.Value(1)
		if(0 && instr(actionList,"Notepad_Administrator"))
			MsgBox,% keyTemp "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		if(strlen(keyTemp)-1 < minKeysLen ){
			if(0 && instr(actionList,"Notepad_Administrator"))
				MsgBox,% keyTemp "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
			continue
		}
		key := SubStr(   keyTemp  , 2)
		; MsgBox,% key " , " keyTemp "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		
        ; global g_config := { FuzzySearch:{ enable: true, keysMAXperEntry : 6, doValueCopy : false } } ; difficult to implement symlink copy for not rr lines doValueCopy. todo: issue . doValueCopy : false  is not fully implemented
		if(ActionStrVal){
			
			; MsgBox,% substr(ActionStrVal,1,4) "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
			
			
			msg =
			(
			>>%key%<<
			>>%ActionStrKey%<<
			>>%ActionStrVal%<<
			)
			; MsgBox,% msg  "`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
			
			if(substr(ActionStrVal,1,3)=="|r|")
				newListSynonym := key "" ActionStrVal
			else if(substr(ActionStrVal,1,4)=="|rr|"){
				newListSynonym := key "" ActionStrVal ; <=== eigentlich sollte es ja so gehen
			}else
				newListSynonym := key "|rr|ahk|" ActionStrVal ; <=== eigentlich sollte es ja so gehen
			; newListSynonym := key "|rr|ahk|" ActionStr ; <=== eigentlich sollte es ja so gehen
		;	newListSynonym := key ActionStrVal
		}else{
			newListSynonym := key "|r|" ActionStr
			; MsgBox,% newListSynonym "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		}
        ; newListSynonym := key "|rr|" ; <=== eigentlich sollte es ja so gehen
		
        ; Msgbox,% a_index ":`n" newListSynonym "`n ^- newListSynonym`n" newListSynonym "`n`n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
        ; Msgbox,% a_index ":`n" ActionStr "`n ^-ActionStr`n" newListSynonym "`n`n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		if(0)
			msg =
		(
%ActionStr%

v= %ActionStrVal%
k= %ActionStrKey%

new = %newListSynonym%
		)
		msg .= "`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		if(0 && instr(actionList,"Notepad_Administrator")){
            ; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), msg )
			tooltip,% msg , 1 ,1
            ;MsgBox,% msg
			sleep,3000
		}
		; AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef,A_LineNumber,Aindex, newListSynonym ,0,"ForceLearn") ; <==== NOT WORKING !!!
		; AddWordToList(ByRef rootCmdTypeObj,ByRef strDebug4insert, ByRef strDebugByRef,fromLine				,lineNr			, AddWord		  ,ForceCountNewOnly,ForceLearn:= false, ByRef LearnedWordsCount := false,
		AddWordToList(rootCmdTypeObj,strDebug4insert		,strDebugByRef		,lineNr " >" A_LineNumber " "	, lineNr 			, newListSynonym ,0				,"ForceLearn"		,LearnedWordsCount)   ; springt dann in zeile 490 ungefähr
		addedKeysCounter++
		; tooltip,% newListSynonym " `n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	} ; endOf while
	return true
} ; endIf addFuzzySearch_in_generatedList
;\____ addFuzzySearch_in_generatedList __ 181106192805 __ 06.11.2018 19:28:05 __/








;/¯¯¯¯ ReverseWordNums ¯¯ 181116123236 ¯¯ 16.11.2018 12:32:36 ¯¯\
ReverseWordNums(LearnedWordsCount){
   ; This function will reverse the read numbers since now we know the total number of words
	global prefs_LearnCount
	global g_actionListDB
	global actionList
	global g_actionListID
	
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	LearnedWordsCount+= (prefs_LearnCount - 1)
	
	sql := "SELECT word FROM Words WHERE count IS NOT NULL actionList = '" actionList "';"
	LearnedWordsTable := g_actionListDB.Query(sql)
	msgbox,%sql% 18-03-25_06-03
   ; LearnedWordsTable := g_actionListDB.Query("SELECT word FROM Words WHERE count IS NOT NULL;")
	
	g_actionListDB.BeginTransaction()
	For each, row in LearnedWordsTable.Rows
	{
		SearchValue := row[1]
		StringReplace, SearchValueEscaped, SearchValue, ', '', All
		WhereQuery := "WHERE word = '" SearchValueEscaped "' AND actionListID = '" g_actionListID "'"
		g_actionListDB.Query("UPDATE words SET count = (SELECT " . LearnedWordsCount . " - count FROM words " . WhereQuery . ") " . WhereQuery . ";")
	}
	g_actionListDB.EndTransaction()
	; too ti t ms lui tip uu
	Return
}
;\____ ReverseWordNums __ 181116123242 __ 16.11.2018 12:32:42 __/













;/¯¯¯¯ getAutoKeywords ¯¯ 181209222042 ¯¯ 09.12.2018 22:20:42 ¯¯\
; this i a triy of new getAutoKeywords
; but it not works in all cases sorry
getAutoKeywords_NEWTRY(ByRef oldKeywords
, addKeysMAX := 9 , minLength := 4, doFirstWord := true
, regEx := "\b((\w+?(?=[A-Z]|\b))([A-Z][a-z]*)?)([A-Z][a-z]*)?"
, elseIfResulsEmpty := "without keywords" ){
                		   ; this function works also multiline. you must not use g)


    ; AddWord rootDoObj.createKeys https://g-intellisense.myjetbrains.com/youtrack/issues?q=project:%20g-IntelliSense#issueId=GIS-65
	; https://github.com/sl5net/global-IntelliSense-everywhere/blob/master/Source/Includes/actionList.ahk#L1438
    ; https://stackoverflow.com/questions/53345266/generate-search-words-from-text-with-camelcase-by-using-regex
oldKeywords := trim(oldKeywords," `t`r`n")
newKeyWords := " " oldKeywords " " ; !!!! <= for Camail Case !!!! you really need this space at the beginnin !!
	;               ^---- importand space !!!!! example: setTitleMatchMode => setTitleMatchMode  setTitleMatch Mode setTitle MatchMode TitleMatchMode

Array := [] ; or Array := Array()
resultStr  := ""

if(doFirstWord){
	firstWord := RegExMatch(newKeyWords,"(\w+)",m) ? m1 : ""
	Array.Push(firstWord) ; Append this line to the array.
	resultStr := firstWord
}

StartingPosition  := 2
addedKeysCounter := 0
while(foundPos := RegexMatch( newKeyWords, "(" regEx ")", Match, StartingPosition )){
		; StartingPosition := Match.Pos(1) + Match.Len(1)
	StartingPosition += strlen(Match1)
	
	if(addedKeysCounter >= addKeysMAX)
		break
	loop,3
	{
		word := Match%A_Index%
			; strlenWord := MatchLen%A_Index% ; works not 
			; strlenWord := Match.Len(1) ; works not 
			; MsgBox, % len " (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		
			; StartingPosition += strlenWord
		if(0){
			strlenWord := strlen(word)
			wordPast := SubStr(newKeyWords, Match.Pos(1) + strlenWord ) ; + Match.Len(1) ) ; strlenWord +  
			MsgBox,% ">" wordPast "<  (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
				; MsgBox,% ">" word "<  (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		}
		word := trim(word," `t`r`n")
		strlenWord := strlen(word)
		if(!HasVal(Array,word)){
			if(minLength <= strlen(word)){
				Array.Push(word) ; Append this line to the array.
				resultStr .= " " word
				ArrayCount++
			}
		}
		rest := lTrim(SubStr( oldKeywords , strlenWord + 1 )," `t`r`n")  ; strlenWord
            ; if(pos := Instr(rest," ")){
		if(pos := RegExMatch( rest, "m)\s" )){
			rest := SubStr( rest , 1, pos-1) ; strlenWord
		}
            ; msgbox,% "oldKeywords=>" oldKeywords "< , rest=>" rest "<"
		if(!HasVal(Array,rest)){
			temp := minLength "<=" strlen(rest)
			if(minLength <= strlen(rest)){
				Array.Push(rest) ; Append this line to the array.
				resultStr .=  " " rest
                    ;resultStr .= ">" strlenWord "~" rest "-" temp "<"
				ArrayCount++
			}
				; resultStr .= "  " ArrayCount ":" word " " rest
				; resultStr .= "  " ArrayCount ":" word " (" rest ") "
		}
	}
}
	; MsgBox,% ">" resultStr "<  `n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
return RTrim( resultStr )
}
;\____ getAutoKeywords __ 181209222049 __ 09.12.2018 22:20:49 __/




;/¯¯¯¯ getAutoKeywords ¯¯ 181106121229 ¯¯ 06.11.2018 12:12:29 ¯¯\
; getAutoKeywords_used_till_181209(ByRef oldKeywords
getAutoKeywords(ByRef oldKeywords
, addKeysMAX := 9 , minLength := 4, doFirstWord := true
, regEx := "\b((\w+?(?=[A-Z]|\b))([A-Z][a-z]*)?)([A-Z][a-z]*)?"
, elseIfResulsEmpty := "without keywords" ){
		   ; this function works also multiline. you must not use g)

    ; AddWord rootDoObj.createKeys https://g-intellisense.myjetbrains.com/youtrack/issues?q=project:%20g-IntelliSense#issueId=GIS-65
	; https://github.com/sl5net/global-IntelliSense-everywhere/blob/master/Source/Includes/actionList.ahk#L1438
    ; https://stackoverflow.com/questions/53345266/generate-search-words-from-text-with-camelcase-by-using-regex


; for some reason we need a leading white space at the beginning !! 18-12-09_21-11

newKeyWords := " " ltrim( oldKeywords," `t`r`n") ; usefull for comparsison later with first wird is already insiede.
	; MsgBox,% ">" resultStr "<  `n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
resultStr  := ""

Array := [] ; or Array := Array()
if(doFirstWord){
	firstWord := RegExMatch(newKeyWords,"^\s*(\w+)",m) ? m1 : ""
	if(firstWord){
		resultStr := firstWord " "
		Array.Push(firstWord)
		if( RegexMatch(firstWord,"([A-Z][a-z0-9]+)$",Match) ){
			lastWordInWord := Match1
			if(strlen(lastWordInWord) >= minLength && !HasVal(Array,lastWordInWord) ){
				Array.Push(lastWordInWord) ; Append this line to the array.
				ArrayCount++
				resultStr .= lastWordInWord " "
                ; msgbox,% lastWordInWord " (123456789)"
			}
		}
	}
}

StartingPosition  := 2
addedKeysCounter := 0
while(foundPos := RegexMatch( newKeyWords, "(" regEx ")", Match, StartingPosition )){
		; StartingPosition := Match.Pos(1) + Match.Len(1)
	StartingPosition += strlen(Match1)
	
	loop,3
	{
		word := Match%A_Index%
			; MsgBox,% ">" word "<  (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		if(!HasVal(Array,word)){
			if(!firstWord){
				firstWord := word
				resultStr .= firstWord " "
			}
			if(strlen(word) >= minLength ){
				Array.Push(word) ; Append this line to the array.
				ArrayCount++
				resultStr .= word " "
			}
		}
		if( RegexMatch(word,"([A-Z][a-z0-9]+)$",Match) ){
			lastWordInWord := Match1
            ; msgbox,% lastWordInWord " (123456789+++)"
			if(strlen(lastWordInWord) >= minLength && !HasVal(Array,lastWordInWord) ){
				Array.Push(lastWordInWord) ; Append this line to the array.
				ArrayCount++
				resultStr .= lastWordInWord " "
				; msgbox,% ">" lastWordInWord "<"
			}
		}
	}
	if(ArrayCount >= addKeysMAX)
		break			
}
resultStr := Trim(resultStr)
if(!resultStr)
	resultStr := elseIfResulsEmpty ; "without keywords"
	    ; MsgBox,% ">" resultStr "<  `n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
return resultStr
}
;\____ getAutoKeywords __ 181106121233 __ 06.11.2018 12:12:33 __/









;/¯¯¯¯ HasVal ¯¯ 181116205402 ¯¯ 16.11.2018 20:54:02 ¯¯\
HasVal(haystack, needle) { ; return index
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
	{
		if (value = needle)
			return index
	}
	return 0
}
;\____ HasVal __ 181116205406 __ 16.11.2018 20:54:06 __/




;/¯¯¯¯ setInNewKeywordsIntoLine ¯¯ 181119012306 ¯¯ 19.11.2018 01:23:06 ¯¯\
; BTW please add keywords into the index row of your database.
; i you want use this anyway ... use it :) 19.11.2018 10:01
setInNewKeywordsIntoLine(	  newKeyWords := "" 
, ByRef line := ""
, posEndKeywords := 0
, doSetItBehindLastKeyword := true
, noOp:=false ){ ; <= has no function only for layout in this function
newLine := ""

newKeyWords := trim(newKeyWords)
line := trim(line)

if(!newKeyWords)
	newKeyWords := getAutoKeywords(firstWordInLine newKeyWords line)
if(!firstWordInLine)
	firstWordInLine := ( RegexMatch(ALoopField,"i)^\s*(\w+)",Match) ) ? Match1 : ""

if(doSetItBehindLastKeyword := true  ){ 
	posSeperator := instr(Line,"|") 
	posEndKeywords := ( posSeperator ) ? posSeperator  : StrLen(line)
	if(!posSeperator)
		newLine := line " " newKeyWords
	else{
		if(posSeperator>1)
			newLine := substr(line,1,posEndKeywords -1 ) " " newKeyWords substr(line, posEndKeywords )
		else
			newLine := newKeyWords substr(line, posEndKeywords )
	}
}
return newLine
}
;\____ setInNewKeywordsIntoLine __ 181119012311 __ 19.11.2018 01:23:11 __/









;/¯¯¯¯ AddWordToList(rootCmdTypeObj,strDebug4insert,strDebugByRef, ¯¯ 181106113409 ¯¯ 06.11.2018 11:34:09 ¯¯\
AddWordToList(  ByRef rootCmdTypeObj
, ByRef strDebug4insert
, ByRef strDebugByRef
, fromLine
, lineNr
, AddWord
, ForceCountNewOnly
, ForceLearn:= false
, ByRef LearnedWordsCount := false
, is_IndexedAhkBlock := false
, doAsimpleCopy := false) {

   ;AddWord = Word to add to the list
   ;ForceCountNewOnly = force this word to be permanently learned even if learnmode is off
   ;ForceLearn = disables some checks in CheckValid
   ;LearnedWordsCount = if this is a stored learned word, this will only have a value when LearnedWords are read in from the actionList
global prefs_DoNotLearnStrings
global prefs_ForceNewWordCharacters
global prefs_LearnCount
global prefs_LearnLength
global prefs_LearnMode
global g_actionListDone
global g_actionListDB
global actionList
;  foundPos := RegExMatch( "str" , "i)" )
INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)

;prefs_LearnMode := "On"

if(0){
	if(rootCmdTypeObj.is_str)
		msgbox,% ".is_str`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	
	if(rootCmdTypeObj.is_r)
		msgbox,% "is_r`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	
	if(rootCmdTypeObj.is_rr)
		msgbox,% "rr`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	
	if(rootCmdTypeObj.is_multiline_r)
		msgbox,% "is_multiline_r`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" Aindex ">ROOT>'" ALoopField "'=ALoopField`n" ObjSToStrTrim(s:="",rootLineObj) s )
	ObjSToStrTrim(s:="",rootLineObj) s
	msgbox,% fromLine ":`n" s "`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
}

if(0 && rootCmdTypeObj.is_multiline_r)
	msgbox,% "is_multiline_r`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"

if(0 && rootCmdTypeObj.is_without_keywords)
	msgbox,% "is_without_keywords`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"

if(0 && rootCmdTypeObj.is_str)
	msgbox,% "is_str`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"





;/¯¯¯¯ is_str ¯¯ 181126002547 ¯¯ 26.11.2018 00:25:47 ¯¯\
if(rootCmdTypeObj.is_str || rootCmdTypeObj.is_rr || rootCmdTypeObj.is_multiline_rr){
	
        ; TransformWord normalizes the word, converting it to uppercase and removing certain accented characters.
	TransformWord(AddWord, AddWordReplacement, AddWordDescription, AddWord_Transformed, AddWordIndex_Transformed, AddWordReplacement_Transformed, AddWordDescription_Transformed)
	
	INSERT_INTO_words := "REPLACE INTO words(wordindexed, word , count , wordreplacement , actionListID, lineNr) `n"
	VALUES := "VALUES ('" AddWordIndex_Transformed 	"', '" AddWord_Transformed "', '" LearnedWordsCount++ "', '" AddWordReplacement_Transformed "' , " g_actionListID ", " lineNr ");"
	INSERT_INTO_words .= VALUES
	try{
		
            ; NormalizeTable := g_actionListDB.Query(select)
		if(!doUseNewMethodStartOfImplementing22march2019)
			NormalizeTable := g_actionListDB.Query(INSERT_INTO_words)
		else{
			If !DB.GetTable(INSERT_INTO_words, NormalizeTable){
				if(!DB.HasKey("SQL")){
					MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
				}
				clipboard := INSERT_INTO_words
				MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			}
		}
		
		
		strDebug4insert .= Trim(AddWord," `t`r`n") "`n"  ; interesting for debugging
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	} catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		
					; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		; Toolip
		
		tip .= "`n sqlLastError=" sqlLastError "`n sql=" INSERT_INTO_words " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc "_SQL-ERROR" ,tip)
		tooltip, `% tip
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		Clipboard := tip
		msgbox, % tip
		if(A_ScriptName == "unitTests.ahk" && AddWord)
			tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  "`n`n`n" INSERT_INTO_words
	}
    ; msgbox,% "is_multiline_r`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	return true
}
;\____ is_str __ 181126002549 __ 26.11.2018 00:25:49 __/


ObjSToStrTrim(s:="",rootCmdTypeObj) s
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc "`n" s )
; msgbox,% fromLine ":`n" s "`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"


;/¯¯¯¯ is_multiline_r ¯¯ 181125204706 ¯¯ 25.11.2018 20:47:06 ¯¯\
if(rootCmdTypeObj.is_multiline_r || rootCmdTypeObj.is_r){
	if(rootCmdTypeObj.is_without_keywords){
		regIs_multiline_r  := "^([^\|\n]*?)\|r\|"
		if(RegExMatch( AddWord , regIs_multiline_r ,  m )){
			rootCmdTypeObj.pos_value := strlen(m1) + 4
		}else
			msgbox,% "ups. should not happens `n`n line:" fromline ">" A_LineNumber ":" substr(AddWord, rootCmdTypeObj.pos_value ) "`n------`n>" AddWord "<"
	}
	
        ; msgbox,% A_LineNumber ":" AddWordReplacement "`n------`n" AddWord "`n" A_LineNumber
	AddWordReplacement :=  substr(AddWord, rootCmdTypeObj.pos_value )
	AddWord :=          substr(AddWord, 1, rootCmdTypeObj.pos_value - 4 )
        ; msgbox,% A_LineNumber ":" AddWordReplacement "`n------`n" AddWord "`n" A_LineNumber
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": AddWord :" AddWord )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": AddWordReplacement :" AddWordReplacement )
	
   ; TransformWord normalizes the word, converting it to uppercase and removing certain accented characters.
	TransformWord(AddWord, AddWordReplacement, AddWordDescription, AddWord_Transformed, AddWordIndex_Transformed, AddWordReplacement_Transformed, AddWordDescription_Transformed)
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": AddWordReplacement :" AddWordReplacement )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": AddWordReplacement_Transformed :" AddWordReplacement_Transformed )
	
	INSERT_INTO_words := "REPLACE INTO words(wordindexed, word , count , wordreplacement , actionListID, lineNr) `n"
	VALUES := "VALUES ('" AddWordIndex_Transformed 	"', '" AddWord_Transformed "', '" LearnedWordsCount++ "', '" AddWordReplacement_Transformed "' , " g_actionListID ", " lineNr ");"
	INSERT_INTO_words .= VALUES
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": INSERT_INTO_words :" INSERT_INTO_words )
	try{
		if(!doUseNewMethodStartOfImplementing22march2019)
			g_actionListDB.Query(INSERT_INTO_words)
			    ; NormalizeTable := g_actionListDB.Query(INSERT_INTO_words)
		else{
			if(!DB.Exec(INSERT_INTO_words)){
				if(!DB.HasKey("SQL")){
					MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
				}
				clipboard := INSERT_INTO_words
				MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			}
		}
		
		strDebug4insert .= Trim(AddWord "|r|" AddWordReplacement," `t`r`n") "`n"  ; interesting for debugging
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
		
	} catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		
 					; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		tip .= "`n sqlLastError=" sqlLastError "`n sql=" INSERT_INTO_words " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		tooltip, `% tip
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		Clipboard := tip
		msgbox, % tip
		if(A_ScriptName == "unitTests.ahk" && AddWord)
			tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  "`n`n`n" INSERT_INTO_words
	}
    ; msgbox,% "is_multiline_r`n`n" AddWord "`n= AddWord`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	return true
}
;\____ is_multiline_r __ 181125204711 __ 25.11.2018 20:47:11 __/


if(1 && g_config.debug.active){
	if(0 && instr(AddWord,"|r|")){
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , AIndex ":" )
		m := % " AddWord == ""|r|"" `n`n`n " actionList " `n`n`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"
		tooltip, % m
		msgBox,reload 44444444444444444
		reload
		sleep, 5555
		return false
	}
	if(trim(AddWord," `t`r`n")  == "|r|"){
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc , AIndex ":" )
		m := % " AddWord == ""|r|"" `n`n`n " actionList " `n`n`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"
		tooltip, % m
		sleep, 5555
		return false
	}
}

	; ms to


;     Msgbox,% insert " = insert(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"

strDebugByRef .= "_____(" fromLine ">" A_LineNumber ")________________`n" ; interesting for debugging
strDebugByRef .= Trim(AddWord," `t`r`n") "`n" ; interesting for debugging

   ;AddWord = Word to add to the list
if(A_ScriptName == "unitTests.ahk" && AddWord)
	tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  


	;/¯¯¯¯ doAsimpleCopy ¯¯ 181124212755 ¯¯ 24.11.2018 21:27:55 ¯¯\
if( rootCmdTypeObj.is_r ){ ; || (!LearnedWordsCount && !doAsimpleCopy ) ) { ; doAsimpleCopy){ ; !LearnedWordsCount) {
	StringSplit, SplitAddWord,  AddWord, | ; old method 17.03.2017 17:54 17-03-17_17-54
         ; SplitAddWord := StrSplit(AddWord, "|")
         ; Tooltip,%A_LineNumber%: %AddWord%  ; show others its loading all this vocabularies 17.03.2017 19:44 17-03-17_19-44
	if(false){
			;MsgBox,4 ,MaxIndex, % SplitAddWord.MaxIndex(), 5
			; if( SplitAddWord.MaxIndex() > 3 )
			; 	MsgBox, ,MaxIndex, % SplitAddWord.MaxIndex() . "`n" . AddWord ; z.B. 4 elements: eins|r|zwei|drei
		if(SplitAddWord2)
			tooltip, '%SplitAddWord2%' = SplitAddWord2 `n '%SplitAddWord3%' = SplitAddWord3 `n (line:%A_LineNumber%)
		if(SplitAddWord3)
			tooltip, '%SplitAddWord3%' = SplitAddWord3 `n (line:%A_LineNumber%) `n
		if(SplitAddWord4)
			tooltip, '%SplitAddWord4%' = SplitAddWord4  `n (line:%A_LineNumber%) `n
	}
	
	IfEqual, SplitAddWord2, D
	{
		AddWordDescription := SplitAddWord3
		AddWord := SplitAddWord1
		IfEqual, SplitAddWord4, R
		{
			AddWordReplacement := SplitAddWord5
		}
	} 
	else IfEqual, SplitAddword2, R
	{
		AddWordReplacement := SplitAddWord3
		AddWord := SplitAddWord1
		IfEqual, SplitAddWord4, D
		{
			AddWordDescription := SplitAddWord5
		}
	}
	else IfEqual, SplitAddword2, r
	{
		AddWordReplacement := SplitAddWord3
		AddWord := SplitAddWord1
		IfEqual, SplitAddWord4, D
		{
			AddWordDescription := SplitAddWord5
		}
		tooltip, '%SplitAddWord3%' = SplitAddWord3  `n (line:%A_LineNumber%) `n
	}
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": `n" fromLine ":`n" AddWord )
} ; endOf if (is_WordReplacement)
	;\____ doAsimpleCopy __ 181124212807 __ 24.11.2018 21:28:07 __/
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )




if(1 && !CheckValid(AddWord,ForceLearn, is_IndexedAhkBlock)){
        ; msgbox,% ">>" AddWord "<<`n is NOT valid(" A_LineNumber ": " A_ThisFunc " " RegExReplace(A_LineFile, ".*\\") ")"
	if(1 && g_config.debug.active){
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )			
			; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" INSERT_INTO_words )			
		Speak(" not valid:" AddWord "( from:" A_LineNumber  ")","PROD")
			; pause
	}
	if(A_ScriptName == "unitTests.ahk" && AddWord)
		tooltip, % "return false <==== " AddWord  "`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	return false
}


if(A_ScriptName == "unitTests.ahk" && AddWord)
	tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  



        ; msgBox,% "is valid: " AddWord "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
   ; TransformWord normalizes the word, converting it to uppercase and removing certain accented characters.
TransformWord(AddWord, AddWordReplacement, AddWordDescription, AddWord_Transformed, AddWordIndex_Transformed, AddWordReplacement_Transformed, AddWordDescription_Transformed)

if(1 && A_ScriptName == "unitTests.ahk" && AddWord){
	tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  
		; sleep,1000
}

If(g_actionListDone) ;if this is read from the actionList
{
	if(A_ScriptName == "unitTests.ahk" && AddWord)
		tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n g_actionListDone= >" g_actionListDone "<`n`n" AddWord
}

if(0 && doAsimpleCopy && instr(AddWord,"|r|") && !AddWordReplacement_Transformed ){
	m = instr(AddWord,"|r|") && !AddWordReplacement_Transformed
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	msgbox, % m "`n`n`nthat should never happens. `n fromLine= `n" fromLine "`n`n>" AddWord "<=AddWord`n`n(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	return false
}

lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ": prefs_LearnMode: `n" prefs_LearnMode )
; g_actionListDone := 0 ; thats a dirty bugfix. dont know what happens

if( g_actionListDone == "0"){ ;if this is read from the actionList ; 1 ||
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	if(1 || LearnedWordsCount){ ;if this is a stored learned word, this will only have a value when LearnedWords are read in from the actionList
			; must update wordreplacement since SQLLite3 considers nulls unique
		INSERT_INTO_words := "REPLACE INTO words(wordindexed, word , count , wordreplacement , actionListID, lineNr) `n"
		VALUES := "VALUES ('" AddWordIndex_Transformed 	"', '" AddWord_Transformed "', '" LearnedWordsCount++ "', '" AddWordReplacement_Transformed "' , " g_actionListID ", " lineNr ");"
		INSERT_INTO_words .= VALUES 
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": INSERT_INTO_words :" INSERT_INTO_words )
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
		
			;INSERT_INTO_words := "REPLACE INTO words(wordindexed, word, worddescription, wordreplacement, actionListID, lineNr)
			;"VALUES ('"  AddWordIndex_Transformed  "','"  AddWord_Transformed . "',"  WordDescriptionQuery  ","  WordReplacementQuery  "," g_actionListID ", " lineNr ");"
		
		
		
        ; msgbox,% INSERT_INTO_words "`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		
		if(1 && A_ScriptName == "unitTests.ahk" && AddWord){
			tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  
				; sleep,1000
		}
		
		try{
			if(!doUseNewMethodStartOfImplementing22march2019)
				g_actionListDB.Query(INSERT_INTO_words)
			else{
				if(!DB.Exec(INSERT_INTO_words)){
					if(!DB.HasKey("SQL")){
						MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
					}
					clipboard := INSERT_INTO_words
					MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
				}
			}
			strDebug4insert .= Trim(AddWord," `t`r`n") "`n"  ; interesting for debugging
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
			
		} catch e{
			tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
			
            ; sqlLastError := SQLite_LastError()
			if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
				sqlLastError := %oFunc%()
			else
				toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
			
			tip .= "`n sqlLastError=" sqlLastError "`n sql=" INSERT_INTO_words " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
			tooltip, `% tip
			feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
			Clipboard := tip
			msgbox, % tip
			if(A_ScriptName == "unitTests.ahk" && AddWord)
				tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  "`n`n`n" INSERT_INTO_words
		}
		if(A_ScriptName == "unitTests.ahk" && AddWord)
			tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  "`n`n`n" INSERT_INTO_words
		
		
	} else {
		if (AddWordReplacement)
		{
			WordReplacementQuery := "'" . AddWordReplacement_Transformed . "'"
		} else {
			WordReplacementQuery := "''"
		}
		
		if (AddWordDescription)
		{
			WordDescriptionQuery := "'" . AddWordDescription_Transformed . "'"
		} else {
			WordDescriptionQuery := "NULL"
		}
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
		INSERT_INTO_words := "REPLACE INTO words(wordindexed, word, worddescription, wordreplacement, actionListID, lineNr) VALUES ('"  AddWordIndex_Transformed  "','"  AddWord_Transformed . "',"  WordDescriptionQuery  ","  WordReplacementQuery  "," g_actionListID ", " lineNr ");"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": INSERT_INTO_words :" INSERT_INTO_words )
		
		
		
        ; msgbox,% INSERT_INTO_words "`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		
		if(1 && A_ScriptName == "unitTests.ahk" && AddWord){
			tooltip, % "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")`n`n`n" AddWord  
				; sleep,1000
		}
		
		
		try{
			if(!doUseNewMethodStartOfImplementing22march2019)
				g_actionListDB.Query(INSERT_INTO_words)
                ; NormalizeTable := g_actionListDB.Query(INSERT_INTO_words)
			else{
				if(!DB.Exec(INSERT_INTO_words)){
					if(!DB.HasKey("SQL")){
						MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
					}
					clipboard := INSERT_INTO_words
					MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
				}
			}
			
			strDebug4insert .= Trim(AddWord," `t`r`n") "`n"  ; interesting for debugging
			if(1 && g_config.debug.active){
				lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " INSERT_INTO_words )
			}
			; ############ here it runs :) 18-11-12_18-46
			if(0 && g_config.debug.active){
                    ;if(1 && instr(rootLineObj.value,"nasenbar")){
				Speak(A_LineNumber "" ,"PROD")
				msgbox,% "never used???? 18-11-12_18-41" INSERT_INTO_words "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
                    ;}
			}
			
			
		} catch e{
			tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
			
            ; sqlLastError := SQLite_LastError()
			if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
				sqlLastError := %oFunc%()
			else
				toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
			
			tip .= "`n sqlLastError=" sqlLastError "`n sql=" INSERT_INTO_words " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
			tooltip, `% tip
			feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
			Clipboard := tip
			msgbox, % tip
		}
		
		
		
	}
      ; Yes, wordindexed is the _Transformed word that is actually searched upon.
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	
} else if (prefs_LearnMode = "On" || ForceCountNewOnly == 1)
{
      ; If this is an on-the-fly learned word
	AddWordInList := g_actionListDB.Query("SELECT * FROM wordsre WHERE word = '" . AddWord_Transformed . "';")
	if(0 && g_config.debug.active)
		msgbox,% AddWord_Transformed  " was ist das????`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )
	
	IF !( AddWordInList.Count() > 0 ) ; if the word is not in the list
	{
		IfNotEqual, ForceCountNewOnly, 1
		{
			    ;/¯¯¯¯ return ¯¯  181110065558 ?? 10.11.2018 06:55:58 ??\
			IF (StrLen(AddWord) < prefs_LearnLength) ; don't add the word if it's not longer than the minimum length for learning if we aren't force learning it
			{
				lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " INSERT_INTO_words )
				return false
			}
			if AddWord contains %prefs_ForceNewWordCharacters%
			{
				lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " INSERT_INTO_words )					
				return false
			}
			if AddWord contains %prefs_DoNotLearnStrings%
			{
				lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " INSERT_INTO_words )					
				return false
			}
                ;\____ return __ 181110065602 __ 10.11.2018 06:56:02 __/
			
			CountValue = 1
			
		} else {
			CountValue := prefs_LearnCount ;set the count to LearnCount so it gets written to the file
		}
			; 
		
         ; must update wordreplacement since SQLLite3 considers nulls unique
		INSERT_INTO_words := "REPLACE INTO words(wordindexed, word, count, wordreplacement, actionListID, lineNr)"
		INSERT_INTO_words .= "VALUES ('" AddWordIndex_Transformed "','"  AddWord_Transformed  "','"  CountValue  "','" AddWordReplacement "', " g_actionListID ", " lineNr ");"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": INSERT_INTO_words :" INSERT_INTO_words)
		; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": INSERT_INTO_words :" INSERT_INTO_words)
		
		
			; msgbox,% INSERT_INTO_words "`n(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"

		; Ti too Tii

		try{
			
			if(!doUseNewMethodStartOfImplementing22march2019)
				g_actionListDB.Query(INSERT_INTO_words)
                    ; NormalizeTable := g_actionListDB.Query(INSERT_INTO_words)
			else{
				if(!DB.Exec(INSERT_INTO_words)){
					if(!DB.HasKey("SQL")){
						MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
					}
					clipboard := INSERT_INTO_words
					MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
				}
			}
			strDebug4insert .= Trim(AddWord," `t`r`n") "`n"  ; interesting for debugging
			if(0 && g_config.debug.active){
				Speak(A_LineNumber ":" INSERT_INTO_words ,"PROD")
				msgbox,% "never used????" INSERT_INTO_words "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
			}
			
		} catch e{
			tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
			
					; sqlLastError := SQLite_LastError()
			if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
				sqlLastError := %oFunc%()
			else
				toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
			
			tip .= "`n sqlLastError=" sqlLastError "`n sql=" INSERT_INTO_words " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
			tooltip, `% tip
			feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
			Clipboard := tip
			msgbox, % tip
		}
		
		
	} else IfEqual, prefs_LearnMode, On
	{
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )				
		IfEqual, ForceCountNewOnly, 1
		{
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )					
			For each, row in AddWordInList.Rows
			{
				CountValue := row[3]
				break
			}
			
			IF ( CountValue < prefs_LearnCount )
			{
				update := "UPDATE words SET count = ('" prefs_LearnCount "') WHERE word = '"  AddWord_Transformed "' AND actionListID = '" . g_actionListID . "';"
				lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":`n" update )					
				g_actionListDB.QUERY(update)
			}
		} else {
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )					
			UpdateWordCount(AddWord,0) ;Increment the word count if it's already in the list and we aren't forcing it on
		}
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )	
		
	}
}
lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": " fromLine ":" AddWord )	

Return true
}
;\____ AddWordToList __ 181106193901 __ 06.11.2018 19:39:01 __/




;/¯¯¯¯ CheckValid ¯¯ 181106193909 ¯¯ 06.11.2018 19:39:09 ¯¯\
CheckValid(Word,ForceLearn:= false, is_IndexedAhkBlock := false){
	
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
	Ifequal, Word,  ;If we have no word to add, skip out.
	{
		msg = If we have no word to add, skip out.
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid. " msg " Word=>" Word "<" )
		Return
	}
	
	if Word is space ;If Word is only whitespace, skip out.
	{
		msg = If Word is only whitespace, skip out.
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid. " msg  )
		Return
	}
	
	if(is_IndexedAhkBlock){
		if(!RegExMatch( Word , "\S" ))
		{
			msg = search a nonspace in it
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid" msg )
			return
		}
	}else{
		if ( Substr(Word,1,1) = ";" ) ;If first char is ";", clear word and skip out.
		{
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid"  )
			Return
		}
		
    ;	if ( Substr(Word,1,1) = " " ) ; If first char is " ", clear word and skip out. spaces now have a special meaning. with spaces is not a kay. with spaces it could be eventually a value of a block
    ;		Return
        ; ALoopField  := RegExReplace(ALoopField, "^\s+" , "" ) ; anfangs leerzeichen raus 06.11.2017 18:28
		
		IF ( StrLen(Word) <= g_min_searchWord_length ){
			msg = don't add the word if it's not longer than the minimum length
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid. " msg )
			Return
		}
	}
	
   ;Anything below this line should not be checked if we want to Force Learning the word (Ctrl-Shift-C or coming from actionList . txt)
	If ForceLearn
		Return, 1
	
	IfEqual, A_IsUnicode, 1
	{
		if ( RegExMatch(Word, "S)\pL") = 0 )
		{
			msg = if Word does not contain at least one alpha character, skip out.
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid." msg )
			return
		}
	} else if ( RegExMatch(Word, "S)[a-zA-ZÃ -Ã¶Ã¸-Ã¿Ã€-Ã–Ã˜-ÃŸ]") = 0 )
	{
		
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": is NOT CheckValid 19-04-05_14-01"  )
		Return
	}
	
	Return, 1
}
;\____ CheckValid __ 181106193917 __ 06.11.2018 19:39:17 __/






;/¯¯¯¯ TransformWord ¯¯ 181106193925 ¯¯ 06.11.2018 19:39:25 ¯¯\
TransformWord(AddWord
, AddWordReplacement
, AddWordDescription
, ByRef AddWord_Transformed
, ByRef AddWordIndex_Transformed
, ByRef AddWordReplacement_Transformed
, ByRef AddWordDescription_Transformed) {

    ; TransformWord normalizes the word, converting it to uppercase and removing certain accented characters.

INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)

	;/¯¯¯¯ AddWordIndex ¯¯ 181125203603 ¯¯ 25.11.2018 20:36:03 ¯¯\
AddWordIndex := AddWord
   ; normalize accented characters
AddWordIndex := StrUnmark(AddWordIndex) ; MsgBox % StrUnmark("ÁáÀàÂâǍǎĂă
StringUpper, AddWordIndex, AddWordIndex
	;\____ AddWordIndex __ 181125203613 __ 25.11.2018 20:36:13 __/

	;/¯¯¯¯ Transformed ¯¯ 181125203915 ¯¯ 25.11.2018 20:39:15 ¯¯\
AddWord_Transformed := StrReplace( AddWord, "'", "''")
AddWordIndex_Transformed := StrReplace(  AddWordIndex, "'", "''")
if (AddWordReplacement){
	AddWordReplacement_Transformed := StrReplace(  AddWordReplacement, "'", "''")
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": wordreplacement :" wordreplacement )
	lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc  , A_ThisFunc ": AddWordReplacement_Transformed :" AddWordReplacement_Transformed )
	
}
if (AddWordDescription) 
	AddWordDescription_Transformed := StrReplace(  AddWordDescription, "'", "''")
	;\____ Transformed __ 181125203920 __ 25.11.2018 20:39:20 __/
}
;\____ TransformWord __ 181106193931 __ 06.11.2018 19:39:31 __/




;/¯¯¯¯ DeleteWordFromList ¯¯ 181106193941 ¯¯ 06.11.2018 19:39:41 ¯¯\
DeleteWordFromList(DeleteWord){
	
	
	global prefs_LearnMode
	global g_actionListDB
	global actionList
	
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	Ifequal, DeleteWord,  ;If we have no word to delete, skip out.
	Return
	
	if DeleteWord is space ;If DeleteWord is only whitespace, skip out.
		Return
	
	IfNotEqual, prefs_LearnMode, On
	Return
	
	StringReplace, DeleteWordEscaped, DeleteWord, ', '', All
   ; g_actionListDB.Query("DELETE FROM words WHERE word = '" . DeleteWordEscaped . "';")
	g_actionListDB.Query("DELETE FROM words WHERE word = '" . DeleteWordEscaped . "' AND actionListID = '" . g_actionListID . "';")
	
	Return
}
;\____ DeleteWordFromList __ 181106193948 __ 06.11.2018 19:39:48 __/



;/¯¯¯¯ UpdateWordCount ¯¯ 181106193956 ¯¯ 06.11.2018 19:39:56 ¯¯\
UpdateWordCount(word,SortOnly){
	global prefs_LearnMode
	global g_actionListDB
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
   ;Word = Word to increment count for
   ;SortOnly = Only sort the words, don't increment the count
	
   ;Should only be called when LearnMode is on
	IfEqual, prefs_LearnMode, Off
	Return
	
	IfEqual, SortOnly,
	Return
	
	StringReplace, wordEscaped, word, ', '', All
	g_actionListDB.Query("UPDATE words SET count = count + 1 WHERE word = '" . wordEscaped . "';")
	
	Return
}
;\____ UpdateWordCount __ 181106194005 __ 06.11.2018 19:40:05 __/



;/¯¯¯¯ CleanupEntriesOfThisActionList ¯¯ 181106194013 ¯¯ 06.11.2018 19:40:13 ¯¯\
CleanupEntriesOfThisActionList(g_actionListID){
	global g_actionListDB
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
   ;Function cleans up all words from given actionList
	; Msgbox,not yet implemented `n (%A_LineFile%~%A_LineNumber%)
	sql := "DELETE FROM Words WHERE actionListID = " g_actionListID ";"
	try{
		
		if(!doUseNewMethodStartOfImplementing22march2019)
			g_actionListDB.Query(sql)
		else{
			if(!DB.Exec(sql)){
                    if(!DB.HasKey("SQL")){
					MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
                    }
                    clipboard := sql
				MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			}
		}
		
		
		
	} catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		
            ; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		tip .= "`n sqlLastError=" sqlLastError "`n sql=" select " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		tooltip, `% tip
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		Clipboard := tip
		msgbox, % tip
	}
    ; msgbox,% sql "`n`n deleted?? `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
}
;\____ CleanupEntriesOfThisActionList __ 181106194018 __ 06.11.2018 19:40:18 __/





;/¯¯¯¯ CleanupActionListAll_ofLittleWordCount ¯¯ 181106194030 ¯¯ 06.11.2018 19:40:30 ¯¯\
CleanupActionListAll_ofLittleWordCount(LearnedWordsOnly := false){
	
   ;Function cleans up all words that are less than the LearnCount threshold or have a NULL for count
   ;(NULL in count represents a 'actionList . txt' word, as opposed to a learned word)
	global g_ScriptTitle
	global g_actionListDB
	global actionList
	global prefs_LearnCount
;   Progress, M, Please wait..., Cleaning actionList, %g_ScriptTitle%
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	if (LearnedWordsOnly) {
		g_actionListDB.Query("DELETE FROM Words WHERE count < " . prefs_LearnCount . " AND count IS NOT NULL AND actionListID = '" . g_actionListID . "';")
	} else {
		g_actionListDB.Query("DELETE FROM Words WHERE (count < " . prefs_LearnCount . " OR count IS NULL) AND actionListID = '" . g_actionListID . "';")
	}
   ;Progress, Off
}
;\____ CleanupActionListAll_ofLittleWordCount __ 181106194042 __ 06.11.2018 19:40:42 __/



;/¯¯¯¯ MaybeUpdateActionList ¯¯ 181106194051 ¯¯ 06.11.2018 19:40:51 ¯¯\
MaybeUpdateActionList(){
	return ; learnd words. dont need 07.02.2018 17:10
	global g_LegacyLearnedWords
	global g_actionListDB
	global actionList
	global g_actionListID
	global g_actionListDone
	global prefs_LearnCount
	
   ; Update the Learned Words
	IfEqual, g_actionListDone, 1
	{
    ;
		SELECT := "SELECT Word FROM Words WHERE count >= " . prefs_LearnCount . " AND count IS NOT NULL AND actionListID = '" . g_actionListID . "' ORDER BY count DESC; "
		msgbox,% SELECT " 18-03-25_06-05"
        ;Clipboard := SELECT
		SortActionList := g_actionListDB.Query(SELECT)
		
		for each, row in SortActionList.Rows
		{
			TempActionList .= row[1] . "`r`n"
		}
		
		If ( SortActionList.Count() > 0 )
		{
			StringTrimRight, TempActionList, TempActionList, 2
			
			FileDelete, %A_ScriptDir%\Temp_actionListLearned.ahk
			FileAppendDispatch(TempActionList, A_ScriptDir . "\Temp_actionListLearned.ahk")
			FileCopy, %A_ScriptDir%\Temp_actionListLearned.ahk, %A_ScriptDir%\actionListLearned.ahk, 1
			FileDelete, %A_ScriptDir%\Temp_actionListLearned.ahk
			
         ; Convert the Old actionList file to not have ;LEARNEDWORDS;
			IfEqual, g_LegacyLearnedWords, 1
			{
				TempActionList =
				toolTipGui("FileRead, ParseWords (" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")" ,,-50,"_/",A_LineNumber,"green")
				
				FileRead, ParseWords, %A_ScriptDir%\%actionList%
				LearnedWordsPos := InStr(ParseWords, "`;LEARNEDWORDS`;",true,1) ;Check for Learned Words
				TempActionList := SubStr(ParseWords, 1, LearnedwordsPos - 1) ;Grab all non-learned words out of list
				ParseWords =
				FileDelete, %A_ScriptDir%\Temp_actionList.ahk
				FileAppendDispatch(TempActionList, A_ScriptDir . "\Temp_actionList.ahk")
;            FileCopy, %A_ScriptDir%\Temp_actionList.txt, %A_ScriptDir%\actionList.txt, 1
				FileCopy, %A_ScriptDir%\Temp_actionList.ahk, %actionList%, 1 ; 02.03.2018 12:37 18-03-02_12-37
				FileDelete, %A_ScriptDir%\Temp_actionList.ahk
			}
		}
	} ; __ __
	
	g_actionListDB.Close(),
	
} ; EndOf: MaybeUpdateActionList
;\____ MaybeUpdateActionList __ 181106194100 __ 06.11.2018 19:41:00 __/





;/¯¯¯¯ StrUnmark ¯¯ 181106194109 ¯¯ 06.11.2018 19:41:09 ¯¯\
; Removes marks from letters.  Requires Windows Vista or later.
; Code by Lexikos, based on MS documentation
StrUnmark(string) {
	
	global g_OSVersion
	global g_NormalizationKD
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	if (g_OSVersion < 6.0)
	{
		return string
	}
	
    ;return string ; todo disabling has no sideEffects ?
    ;MsgBox,% "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
	
	
	len := DllCall("Normaliz.dll\NormalizeString", "int", g_NormalizationKD, "wstr", string, "int", StrLen(string), "ptr", 0, "int", 0)  ; Get *estimated* required buffer size.
	Loop {
		VarSetCapacity(buf, len * 2)
		len := DllCall("Normaliz.dll\NormalizeString", "int", g_NormalizationKD, "wstr", string, "int", StrLen(string), "ptr", &buf, "int", len)
		if len >= 0
			break
		if (A_LastError != 122) ; ERROR_INSUFFICIENT_BUFFER
			return string
		len *= -1  ; This is the new estimate.
	}
   ; Remove combining marks and return result.
	string := RegExReplace(StrGet(&buf, len, "UTF-16"), "\pM")
	
	if(false){
		StringReplace, string, string, ?, ae, All
		StringReplace, string, string, ?, AE, All
		StringReplace, string, string, ?, oe, All
		StringReplace, string, string, ?, OE, All
		StringReplace, string, string, ?, ss, All
	}
	
	return, string
}
;\____ StrUnmark __ 181106194133 __ 06.11.2018 19:41:33 __/




;/¯¯¯¯ getActionListID ¯¯ 181106194141 ¯¯ 06.11.2018 19:41:41 ¯¯\
getActionListID(sql_template_dir, actionList){
	
	global g_actionListDB
	global g_actionListDBfileAdress
	global g_actionList_UsedByUser_since_midnight
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
	
	
;/¯¯¯¯ doUseNewMethodStartOfImplementing22march2019 ¯¯ 190322183522 ¯¯ 22.03.2019 18:35:22 ¯¯\
    ;doUseNewMethodStartOfImplementing22march2019 := true
	if(doUseNewMethodStartOfImplementing22march2019){
		SELECT =
        (
    SELECT id, lastUsedByUser_since_midnight FROM actionLists WHERE
    actionList = '%actionList%' ;
        )
		
		If (!DB.HasKey("SQL")) {
			tip := "ups !DB.HasKey(""SQL"") `n`n" SELECT "`n`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
			toolTip2sec( tip  )
			MsgBox, 16, % tip , % tip
			return false
			MsgBox, 16, SQLite Error, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			ExitApp
		}
		
   ; MsgBox, 16, % DB.Version "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		
		
		/*
			SELECT id, lastUsedByUser_since_midnight FROM actionLists WHERE
			actionList = '..\actionLists\_globalActionListsGenerated\_ahk_global.ahk._Generated.ahk' ;
			
			SELECT distinct ltrim(word), ltrim(worddescription), ltrim(wordreplacement)
			FROM Words
			WHERE word LIKE '%'  ESCAPE '~'
			and ActionListID = 7
			order by ActionListID, word
			LIMIT 2;
			-- seLECT * FROM ActionLists l where l.ActionList like %isNotAProject%;
			-- An underscore (_) in the LIKE pattern matches any single character in the string.
			-- you need to reload the script after each change. be careful by changing the ware statment. its will later parsed by script.
			-- prp probab ür probab pro proba qahk s changin pro probab pro probab p proba
		*/
		
		
		If !DB.GetTable(SELECT, Table){
			
			clipboard  := "DB.HasKey(""SQL"")=" DB.HasKey("SQL") "`n" SELECT "`n" "`n" "`n" get_obj_ToString(DB)
			MsgBox,262208,% ":)`n" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% clipboard
			
			
			tip := % SELECT "`n`nDB.HasKey(""SQL"")=" DB.HasKey("SQL") "`n" " SQLite Error: GetTable, " "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			MsgBox,16,% A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% tip "`n" A_LineNumber " " RegExReplace(A_LineFile, ".*\\")
           ;MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			tooltip,% "SQLite Error: GetTable: " "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			Table.Free()
			sleep 1000
			return false
			return getActionListID(sql_template_dir, actionList)
			
			/*
				SELECT id, lastUsedByUser_since_midnight FROM actionLists WHERE
				actionList = '..\actionLists\_globalActionListsGenerated\_ahk_global.ahk._Generated.ahk' ;
			*/
			
		}
		
		
		
		
		sumStr := ""
		If (Table.HasNames) {
          ; Loop, % Table.ColumnCount
			If (Table.HasRows) {
				Loop, % Table.RowCount {
                ; RowCount := LV_Add("", "")
					RowID := A_Index
					Table.Next(Row)
					sumStr .= RowID - 1 ": "
					Loop, % Table.ColumnCount
					{
						actionListID := Row[A_Index]
						break
					}
					if(actionListID)
						break
				}
			}
		}
		
		
        ;Table.Free()
		INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
		
		
        ;tooltip,% actionListID
        ;msgbox,% actionListID "`n`n" SELECT
		return actionListID
	}
;\____ doUseNewMethodStartOfImplementing22march2019 __ 190322183533 __ 22.03.2019 18:35:33 __/
	
	if(!doUseNewMethodStartOfImplementing22march2019 && !g_actionListDB)
		g_actionListDB := DBA.DataBaseFactory.OpenDataBase("SQLite", g_actionListDBfileAdress ) ;
	if(!sql_template_dir){
		msgbox,% "!sql_template_dir`n `n (" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	}
	if(!doUseNewMethodStartOfImplementing22march2019 && !g_actionListDB){
		msgbox,% "!g_actionListDB`n `n (" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
	}
	sqlGetWLid =
    (
SELECT id, lastUsedByUser_since_midnight FROM actionLists WHERE
actionList = '%actionList%' ;
    )
	; try{
	
	if(!doUseNewMethodStartOfImplementing22march2019){
		result := g_actionListDB.Query(sqlGetWLid)
		Matches := result.Rows
	}else{
		If !DB.GetTable(sql, Matches){
			if(!DB.HasKey("SQL")){
				toolTip2sec( "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
                    MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
			}
			MsgBox, 16, % A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ,% tip "`n" A_LineNumber " " RegExReplace(A_LineFile, ".*\\")
		}
	}
	
	For each, row in Matches
	{
		g_actionListID := row[1]
		g_actionList_UsedByUser_since_midnight[g_actionListID] := row[2]
		return g_actionListID
	}
	
  ;  INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
	if(false){
	; } catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		tooltip, `% tip
		; feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		; Clipboard := tip
		
					; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		
		if( instr(sqlLastError, "no such column") || instr(sqlLastError, "no such table") ){
			RebuildDatabase(sql_template_dir)
			tooltip,% "  RebuildDatabase(sql_template_dir) ==> (" RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			sleep,2000
			reload
		}
	; }
	}
	
	size := 1 ; FIRST TIME EVER schuuld be done by reading the actionList in other function
	modified := "1111-11-11" ; FIRST TIME EVER  ; schuuld be done by reading the actionList in other function
        ; FileGetSize, actionListSize, % actionList
        ; FileGetTime, actionListModified, % actionList, M
        ; FormatTime, actionListModified, % actionListModified, yyyy-MM-dd HH:mm:ss
	
        ;INSERT_INTO_actionLists_ifNotExist(actionList, modified, size )
	try{
		
  ;  INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
		
		if(doUseNewMethodStartOfImplementing22march2019){
			If !DB.GetTable(sql, Matches){
				if(!DB.HasKey("SQL")){
					tip := "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
					toolTip2sec( tip  )
					run,tools\DebugVars\DebugVars.ahk
					MsgBox, 16, % tip , % tip
					return false
				}
				MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
			}
		}
		else{
			Matches := g_actionListDB.Query(sqlGetWLid)
			;Matches := result.Rows
		}
	} catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		
							; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		tip .= "`n sqlLastError=" sqlLastError " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		tooltip, `% tip
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		Clipboard := tip
	}
	
	
	if(doUseNewMethodStartOfImplementing22march2019){
		Matches.Next(row)
		g_actionListID := row[1]
		g_actionList_UsedByUser_since_midnight[g_actionListID] := row[2]
		return g_actionListID
	}else{
		For each, row in Matches
		{
			g_actionListID := row[1]
			g_actionList_UsedByUser_since_midnight[g_actionListID] := row[2]
			return g_actionListID
		}
	}
	msg := sql . "`n" . sqlGetWLid
	
						; sqlLastError := SQLite_LastError()
	if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
		sqlLastError := %oFunc%()
	else
		toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
	
	
; Too Tool  sett titlema
	
	msg .= "`n sqlLastError=" sqlLastError "`n `n (" . A_LineNumber . " " .  RegExReplace(A_LineFile,".*\\") ")"
	
	
	
	
	
	
	if(!g_actionListID && sqlLastError){
          ; lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,msg)
          ; clipboard := msg
          ; feedbackMsgBox("clipboard:=sql", msg)
		; msgbox,% msg " (19-03-24_05-50)"
          ; 
		if( instr(sqlLastError, "no such table") ){
            ;if(A_TickCount < 1000){
			tip := "`n Now do RebuildDatabase(sql_template_dir) because of " sqlLastError "`n g_actionListDB=" g_actionListDB
			if(1 && g_config.debug.active)
				ToolTip5sec(tip "`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
			RebuildDatabase(sql_template_dir) ; works ? 22.10.2018 05:23 todo:
			; Reported by Terka 18-11-05: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=45684&p=254473#p254473
			sleep,10
			return getActionListID(g_config["sql"]["template"]["dir"], actionList)
                ; return ; probalby enough only to wait 22.10.2018 04:56
            ;}
		}
		else if( instr(sqlLastError, "no such column") ){
			RebuildDatabase(sql_template_dir)
			msgbox,% "done: RebuildDatabase(sql_template_dir)`n `n " msg " (" . A_LineNumber . " " .  RegExReplace(A_LineFile,".*\\") ")"
			tooltip,% "  RebuildDatabase(sql_template_dir) ==> (" RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			sleep,5000
			reload
		}else{
			lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,msg)
			msgbox,% sqlLastError "`n`n = sqlLastError `n (" . A_LineNumber . " " .  RegExReplace(A_LineFile,".*\\") ")"
            ; inside: getActionListID
		}
		exitapp
	}
	
  ;  INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	
	if(A_TickCount - g_StartTime_TickCountMilli > 900 ){ ; its ok if happens at the very beginning
		m =
    (
    ERROR: this line should never visited

    actionList = %actionList%
    actionListID = %actionListID%
    sqlLastError = %sqlLastError%

    %sqlGetWLid%
    )
		
		
		tooltip,% m "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\") ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,m)
		msgbox,% m "`n `n (" A_LineNumber " "  RegExReplace(A_LineFile,".*\\") ")"
	}
	; g_actionList_UsedByUser_since_midnight[g_actionListID] := lastUsedByUser_since_midnight
    ; g_actionListDB.Query("UPDATE actionList SET lastUsedByUser_since_midnight = " g_actionList_UsedByUser_since_midnight[g_actionListID] " WHERE id = " g_actionListID ";")
	return actionListID
}
;\____ getActionListID __ 181025115249 __ 25.10.2018 11:52:49 __/



;/¯¯¯¯ INSERT_INTO_actionLists_ifNotExist ¯¯ 181106194154 ¯¯ 06.11.2018 19:41:54 ¯¯\
INSERT_INTO_actionLists_ifNotExist(sql_template_dir,actionList, actionListModified, actionListSize ){
	
	global g_actionListDB
	global g_actionListDBfileAdress
	if(!doUseNewMethodStartOfImplementing22march2019 && !g_actionListDB)
		g_actionListDB := DBA.DataBaseFactory.OpenDataBase("SQLite", g_actionListDBfileAdress ) ;
	actionListID := getActionListID(sql_template_dir, actionList) ; 24.03.2018 23:02
	if(actionListID){
		tip=Oops actionListID already exist `n actionListID = %actionListID% `n actionList=%actionList% `n  27.03.2018 22:37
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		return
	}
	INSERT_INTO_actionLists(actionList, FileGet_actionListModified, FileGet_actionListSize )
}
;\____ INSERT_INTO_actionLists_ifNotExist __ 190405135324 __ 05.04.2019 13:53:24 __/


;/¯¯¯¯ INSERT_INTO_actionLists ¯¯ 190405135358 ¯¯ 05.04.2019 13:53:58 ¯¯\
INSERT_INTO_actionLists(actionList, actionListModified, actionListSize ){
	
	global g_actionListDB
	global g_actionListDBfileAdress
	INSERT_function_call_time_millis_since_midnight( RegExReplace(A_LineFile,".*\\") , A_ThisFunc , A_LineNumber)
	if(!actionListModified){
		msg := "Error`n !actionListModified `n sql=" sql "`n" actionList "`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		tooltip,% msg ,1,1
		return false
	}
	sql := "INSERT INTO actionLists "
	sql .= " (id, actionList, actionListmodified, actionListsize) VALUES "
	sql .= " (null, '" actionList "', '" actionListModified "', '" actionListSize "' );"
	if(!doUseNewMethodStartOfImplementing22march2019 && !g_actionListDB)
		g_actionListDB := DBA.DataBaseFactory.OpenDataBase("SQLite", g_actionListDBfileAdress ) ;
	try{
		if(!doUseNewMethodStartOfImplementing22march2019)
			g_actionListDB.Query(sql)
		else{
			if(!DB.Exec(sql)){
				if(!DB.HasKey("SQL")){
					MsgBox, 16, % "ups !DB.HasKey(""SQL"") `n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")"
				}
				clipboard := sql
				MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . DB.ErrorMsg . "`nCode:`t" . DB.ErrorCode "`n`n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
			}
		}
	} catch e{
		tip:="Exception:`n" e.What "`n" e.Message "`n" e.File "@" e.Line
		
            ; sqlLastError := SQLite_LastError()
		if oFunc := Func("SQLite_LastError") ; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=63186&p=270178#p270178
			sqlLastError := %oFunc%()
		else
			toolTip2sec( SQLite_LastError " :( not found`n(" A_ThisFunc " " RegExReplace(A_LineFile,".*\\") ":"  A_LineNumber ")" )
		
		tip .= "`n sqlLastError=" sqlLastError "`n sql=" sql " `n( " RegExReplace(A_LineFile,".*\\") "~" A_LineNumber ")"
		lll( A_LineNumber , A_LineFile "-id" g_actionListID "-" A_ThisFunc ,tip)
		tooltip, `% tip
		feedbackMsgBox(A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\"), tip )
		Clipboard := tip
		msgbox, % tip
	}
}
;\____ INSERT_INTO_actionLists __ 190405135406 __ 05.04.2019 13:54:06 __/

#Include %A_ScriptDir%\inc_ahk\functions_global.inc.ahk