﻿#SingleInstance,Off
#Include *i VarTreeGui.ahk
#SingleInstance,Off
#Include *i VarEditGui.ahk
#SingleInstance,Off
#Include *i dbgp.ahk
#SingleInstance,Off

#Include *i tools\DebugVars\VarTreeGui.ahk
#SingleInstance,Off
#Include *i tools\DebugVars\VarEditGui.ahk
#SingleInstance,Off
#Include *i tools\DebugVars\dbgp.ahk
#SingleInstance,Off

if( instr(A_LineFile, A_ScriptName ))
	exitapp

global g_config

DvArg(dbg, a) { ; Quote parameter value 'a' if appropriate/supported
    if !InStr(a, " ")
        return a
    ; Parameter values including a space "must" be quoted, according to
    ; the spec (draft 21, 2018-01-09), but this requires v1.1.30+.
    if !ObjHasKey(dbg, "can_quote") { ; Support not yet determined
        dbg.feature_get("-n ""feature_get""", response)
        ObjRawSet(dbg, "can_quote", InStr(response, "supported=""1""") != 0)
    }
    return dbg.can_quote ? """" RegExReplace(a, "[""\\]", "\$0") """" : a
}

DvInspectProperty(dbg, fullname, extra_args:="", show_opt:="") {
    dbg.feature_set("-n max_depth -v 1")
    ; 1MB seems reasonably permissive.  Note that -m 0 (unlimited
    ; according to the spec) doesn't work with v1.1.24.02 and earlier.
    dbg.property_get("-m 1048576 -n" DvArg(dbg, fullname) (extra_args="" ? "" : " " extra_args), response)
    dbg.feature_set("-n max_depth -v 0")
    prop := DvLoadXml(response).selectSingleNode("/response/property")
    
    if (prop.getAttribute("name") = "(invalid)") {
        MsgBox, 48,, Invalid variable name: %fullname%
        return false
    }
    
    type := prop.getAttribute("type")
    if (type != "object") {
        isReadOnly := prop.getAttribute("facet") = "Builtin"
        value := DBGp_Base64UTF8Decode(prop.text)
        dv := new DebugVarGui(dbg, {name: fullname, value: value, type: type, readonly: isReadOnly, args: extra_args})
    }
    else {
        dv := new DebugVarsGui(new DvPropertyNode(dbg, prop))
    }
    dv.Show(show_opt)
}

class DebugVarGui extends VarEditGui
{
    __New(dbg, var) {
        base.__New(var)
        this.dbg := dbg
    }
    
    OnSave(value, type) {
        DvSetProperty(this.dbg, this.var.name, value, type, this.var.args)
        this.var.value := value
        this.var.type := type
        DvRefreshAll()
    }
}

DvSetProperty(dbg, fullname, ByRef value, type, args:="", ByRef response:="") {
    if (type = "integer")
        value := format("{:i}", value) ; Force decimal format.
    if (type = "integer" || type = "float") && dbg.no_base64_numbers
        data := value
    else
        data := DBGp_Base64UTF8Encode(value)
    dbg.property_set("-n" DvArg(dbg, fullname) " -t" type (args="" ? "" : " " args) " -- " data, response)
}

class DvNodeBase extends TreeListView._Base
{
    expanded {
        set {
            if value {
                ; Expanded for the first time: populate.
                this.children := this.GetChildren()
                ObjRawSet(this, "expanded", true)
            }
            return value
        }
        get {
            return false
        }
    }
    
    SetValue(value) {
        return false
    }
    
    Clone() {
        node := ObjClone(this)
        node.children := this.GetChildren()
        return node
    }
    
    Update(tlv) {
        for i, child in this.children
            child.Update(tlv)
    }
}

class DvPropertyParentNode extends DvNodeBase
{
    UpdateChildren(tlv, props, args:="") {
        children := this.children
        if !children {
            if !props.length
                return
            this.children := children := []
        }
        np := 0, nc := 1
        loop {
            if (np < props.length) {
                prop := props.item(np)
                if (nc > children.Length() || prop.getAttribute("name") < children[nc].name) {
                    tlv.InsertChild(this, nc, new DvPropertyNode(this.dbg, prop, args))
                    ++nc, ++np
                    continue
                }
                if (prop.getAttribute("name") = children[nc].name) {
                    children[nc].Update(tlv, prop, args)
                    ++nc, ++np
                    continue
                }
            }
            if (nc > children.Length())
                break
            tlv.RemoveChild(this, nc)
        }
    }
}

class DvPropertyNode extends DvPropertyParentNode
{
    __new(dbg, prop, args:="") {
        this.dbg := dbg
        this.fullname := prop.getAttribute("fullname")
        this.name := prop.getAttribute("name")
        ; this.name := "############# test ################"




        this.xml := prop
        this.args := args
        props := prop.selectNodes("property")
        if props.length {
            this.children := this.FromXmlNodes(props, dbg, args)
            ObjRawSet(this, "expanded", false)
        }
        else {
            this._value := DBGp_Base64UTF8Decode(prop.text)
        }


        ;/¯¯¯¯ doLog_matching_probNames ¯¯ 190224144433 ¯¯ 24.02.2019 14:44:33 ¯¯\
        doLog_matching_probNames := true
        if(doLog_matching_probNames){
        alw := g_config["var"]["allowRegEx"]
        ign  := g_config["var"]["ignoreRegEx"]
        if(!g_config["var"]["allowRegEx"] && !g_config["var"]["ignoreRegEx"]){
            msgbox,% "ups wrong config adjskha"
            exitapp
        }
        doUseThisVar := false
        if(RegExMatch(this.name,g_config["var"]["allowRegEx"])
        && !RegExMatch(this.name,g_config["var"]["ignoreRegEx"])){
            doUseThisVar := true
            ; tooltip,% doUseThisVar ":" this.name " ? " g_config["var"]["allowRegEx"]
            ; msgbox,% this.name " ? " g_config["var"]["allowRegEx"]
            ; tooltip,% doUseThisVar ":" this.name " ? " g_config["var"]["allowRegEx"] "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\")

            ;exitapp
        }
        if(doUseThisVar){
            ;fileContent := this.name " := """ this.GetValueString() """`n"
            if(IsObject(this._value)){
                ; it not working. never happens ; todo: 19-03-23_17-20 https://github.com/sl5net/rexEx_DebugVars/blob/master/DebugVarsGui.ahk#L192
                ObjSToStrTrim(valStr:="",this._value) valStr

if(0){
for each, Row in this._value {
        valStr := ""
        if IsObject(Row)
            loop % Options.Length() - 1
                valStr .= (Row[Col[A_Index + 1]])
        else
            valStr .= Row
}
}
                ; valStr := get_obj_ToString(valStr) s
            } else{
                ; ObjSToStrTrim(valStr:="",this._value ) valStr
                ; ObjSToStrTrim(valStr:="",this) valStr
                valStr := this._value
            }
            fileContent := this.name " := """ valStr """`n"
            ; logFileAddress: "var.log.txt", alwaysontop: "true"  } }
            ; g_config.logFileAddress.["var"]["ignoreRegEx"]
            fileappend, % fileContent, % A_ScriptDir "\" g_config.logFileAddress, UTF-8
            fileappend, % "Attention! this list may contain duplicate names!", % A_ScriptDir "\" "varnames-" g_config.logFileAddress, UTF-8
            fileappend, % "\b" this.name "\b`n", % A_ScriptDir "\" "varnames-" g_config.logFileAddress, UTF-8
            if(false){
                para2BackupFolder := A_ScriptDir "\Backups"
                para1FileAddress := "var.log.txt"
                commandLine := "SaveLast5_to_BackupSL5.ahk """ para1FileAddress """ """ para2BackupFolder """"
                msgbox,% commandLine "(" A_LineNumber " " RegExReplace(A_LineFile, ".*\\", "") ")"
                RunWait, % commandLine, % A_ScriptDir
            }

            ; tooltip,% doUseThisVar ":" this.name " ? " g_config["var"]["allowRegEx"] "(" A_ThisFunc ":" A_LineNumber " " RegExReplace(A_LineFile, ".*\\")
            ; msgbox,fileappend 19-02-24_13-49
            ;this.name := doUseThisVar ":" this.name
            this.name := "# " this.name
        }
        ; this.name := "saveIt:"doUseThisVar ":#" alw "#" ign "#line:" A_LineNumber "##" g_config["var"]["ignoreRegEx"] "#" this.name
        }
        ;\____ doLog_matching_probNames __ 190224144445 __ 24.02.2019 14:44:45 __/





        this.values := [this.name, this.GetValueString()]
    }
    
    value {
        set {
            this._value := value
            this.values[2] := this.GetValueString()
            return value
        }
        get {
            return this._value
        }
    }
    
    FromXmlNodes(props, dbg, args:="") {
        nodes := []
        for prop in props
            nodes.Push(new DvPropertyNode(dbg, prop, args))
        return nodes
    }
    
    expandable {
        get {
            return this.xml.getAttribute("children")
        }
    }
    
    GetProperty() {
        this.dbg.feature_set("-n max_depth -v 1")
        this.dbg.property_get("-n" DvArg(this.dbg, this.fullname) (this.args="" ? "" : " " this.args), response)
        this.dbg.feature_set("-n max_depth -v 0")
        xml := DvLoadXml(response)
        return this.xml := xml.selectSingleNode("/response/property")
    }
    
    GetChildren() {
        prop := this.GetProperty()
        props := prop.selectNodes("property")
        return DvPropertyNode.FromXmlNodes(props, this.dbg, this.args)
    }
    
    GetValueString() {
        if (cn := this.xml.getAttribute("classname"))
            return cn
        utf8_len := StrPut(this.value, "UTF-8") - 1
        return this.value (this.xml.getAttribute("size") > utf8_len ? "..." : "")
    }
    
    GetWindowTitle() {
        title := "Inspector - " this.fullname
        if prop := this.xml {
            if !(type := prop.getAttribute("classname"))
                type := prop.getAttribute("type")
            title .= " (" type ")"
        }
        return title
    }
    
    SetValue(ByRef value) {
        type := this.xml.getAttribute("type") ; Try to match type of previous value.
        if (type = "float" || type = "integer") && value+0 != ""
            type := InStr(value, ".") ? "float" : "integer"
        else
            type := "string"
        DvSetProperty(this.dbg, this.xml.getAttribute("fullname")
            , value, type, this.args, response)
        if InStr(response, "<error") || InStr(response, "success=""0""")
            return false
        ; Update .xml for @classname and @children, and in case the value
        ; differs from what we set (e.g. for setting A_KeyDelay in v2).
        this.GetProperty()
        this.value := value := DBGp_Base64UTF8Decode(this.xml.text)
    }
    
    Update(tlv, prop:="", args:="") {
        (args != "") && this.args := args
        had_children := this.xml.getAttribute("children")
        if !prop
            || this.expanded  ; Children were visible.
                && prop.getAttribute("children")  ; Still has children.
                && !prop.selectSingleNode("property")  ; None present in the XML.
            prop := this.GetProperty()
        else {
            if had_children && !this.expanded {
                ObjDelete(this, "expanded")  ; Force update on next expansion.
                ObjDelete(this, "children")
            }
            this.xml := prop
        }
        props := prop.selectNodes("property")
        value2 := this.values[2]
        this.value := props.length ? "" : DBGp_Base64UTF8Decode(prop.text)
        if !(this.values[2] "" == "" value2) ; Prevent unnecessary redraw and flicker.
            || (had_children != prop.getAttribute("children"))
            tlv.RefreshValues(this)
        this.UpdateChildren(tlv, props, this.args)
    }
}

class DvContextNode extends DvPropertyParentNode
{
    static expandable := true
    static depth := 0
    
    __new(dbg, context) {
        this.dbg := dbg
        this.context := context
    }
    
    values {
        get {
            return [this.GetWindowTitle(), ""]
        }
    }
    
    GetProperties() {
        this.dbg.context_get("-c" this.context " -d" this.depth, response)
        xml := DvLoadXml(response)
        return xml.selectNodes("/response/property")
    }
    
    GetChildren() {
        props := this.GetProperties()
        return DvPropertyNode.FromXmlNodes(props, this.dbg, "-c" this.context " -d" this.depth)
    }
    
    GetWindowTitle() {
        return this.context=0 ? "Local vars" : "Global vars"
    }
    
    Update(tlv) {
        props := this.GetProperties()
        this.UpdateChildren(tlv, props, "-c" this.context " -d" this.depth)
    }
}

class Dv2ContextsNode extends DvNodeBase
{
    static expandable := true
    
    __new(dbg) {
        this.dbg := dbg
    }
    
    GetChildren() {
        children := []
        Loop 2 {
            children[A_Index] := new DvContextNode(this.dbg, A_Index-1)
            children[A_Index].expanded := true
        }
        return children
    }
    
    GetWindowTitle() {
        return "Variables"
    }
}

class DebugVarsGui extends VarTreeGui
{
    Show(options:="", title:="") {
        return base.Show(options
            , title != "" ? title : this.TLV.root.GetWindowTitle())
    }
    
    UnregisterHwnd() {
        base.UnregisterHwnd()
        this.SetAutoRefresh(0)
    }
    
    class Control extends VarTreeGui.Control
    {
        LV_Key_F5() {
            VarTreeGui.Instances[this.hGui].Refresh()
        }
        
        LV_Key_Enter(r, node) {
            DvInspectProperty(node.dbg, node.fullname, node.args)
        }
    }
    
    OnContextMenu(node, isRightClick, x, y) {
        try Menu DvContext, DeleteAll  ; In case we're interrupting a prior call.
        if node.base != DvPropertyNode
            Menu DvContext, Add, New window, DV_CM_NewWindow
        else
            Menu DvContext, Add, Inspect, DV_CM_InspectNode
        Menu DvContext, Add, Refresh, DV_CM_Refresh
        Menu DvRefresh, Add, Off, DV_CM_AutoRefresh
        Menu DvRefresh, Add, 0.5 s, DV_CM_AutoRefresh
        Menu DvRefresh, Add, 1.0 s, DV_CM_AutoRefresh
        Menu DvRefresh, Add, 5.0 s, DV_CM_AutoRefresh
        static refresh_intervals := [0, 500, 1000, 5000]
        for i, interval in refresh_intervals
            Menu DvRefresh, % interval=this.refresh_interval ? "Check" : "Uncheck", %i%&
        Menu DvContext, Add, Auto refresh, :DvRefresh
        Menu DvContext, Show, % x, % y
        try Menu DvContext, Delete
        return
        DV_CM_NewWindow:
        DV_CM_InspectNode:
        this[SubStr(A_ThisLabel,7)](node)
        return
        DV_CM_Refresh:
        this.Refresh()
        return
        DV_CM_AutoRefresh:
        this.SetAutoRefresh(refresh_intervals[A_ThisMenuItemPos])
        return
    }
    
    OnDoubleClick(node) {
        if node.base != DvPropertyNode
            this.NewWindow(node)
        else
            this.InspectNode(node)
    }
    
    InspectNode(node) {
        DvInspectProperty(node.dbg, node.fullname, node.args)
    }
    
    NewWindow(node) {
        dv := new this.base(node.Clone())
        dv.Show()
    }
    
    refresh_interval := 0
    SetAutoRefresh(interval) {
        this.refresh_interval := interval
        timer := this.timer
        if !interval {
            if timer {
                SetTimer % timer, Delete
                this.timer := ""
            }
            return 
        }
        if !timer
            this.timer := timer := ObjBindMethod(this, "Refresh")
        SetTimer % timer, % interval
    }
    
    Refresh() {
        this.TLV.root.Update(this.TLV)
        WinSetTitle % "ahk_id " this.hGui,, % this.TLV.root.GetWindowTitle()
    }
}

DvRefreshAll() {
    for hwnd, dv in VarTreeGui.Instances
        dv.Refresh()
}

DvLoadXml(ByRef data) {
    o := ComObjCreate("MSXML2.DOMDocument")
    o.async := false
    o.setProperty("SelectionLanguage", "XPath")
    o.loadXml(data)
    return o
}


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
get_obj_ToString(obj){
   s= (line:%A_LineNumber%) `n `n
   For key,value in obj
      s .= key . " = '" . value . "' `n "
   s = %s% `n `n
   return s
}


