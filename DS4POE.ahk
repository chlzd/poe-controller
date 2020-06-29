#SingleInstance Force
#Persistent

CoordMode, Mouse, Screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CONFIG
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Auto move with left axis
AutoMove := true

; Inventory location of Portal scroll
PortalX := 1300
PortalY := 615

; Positions of flask
utilityFlask := 5
lifeFlask := 1
manaFlask := 2

; Auto use flask while attacking (Bind to RT2)
FlaskAutoToggle := true
FlaskAutoDuration := 4000
FlaskAutoPosition := 345

; Set of Shortcuts
UpPOV := "Ctrl"
DownPOV := "p"
LeftPOV := "i"
RightPOV := "Tab"

; Central position of char
defaultCenterX = 960
defaultCenterY = 520

; Joystick config
JoystickNumber := 1 ; Number of controller
JoyMultiplier := 11 ; Circle radius of left axis
JoyMultiplierPrecision := 0.3 ; Sensibility of mouse movement with right axis

JoyThreshold = 5
InvertYAxis := false

SetTimerDelay := 5 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; END OF CONFIG
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; toggleJoyLeft := true

JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

tc_flask := 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FUNCTIONS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FlaskLife(){
	global lifeFlask
	Send, %lifeFlask%
}

FlaskMana(){
	global manaFlask
	Send, %manaFlask%
}

FlaskUtility(){
	global utilityFlask
	Send, %utilityFlask%
}

FlaskAuto(ByRef tc_flask){
global FlaskAutoDuration
global FlaskAutoPosition
IfWinActive, Path of Exile
  If (A_TickCount > tc_flask + FlaskAutoDuration) {
    Send, %FlaskAutoPosition%
    tc_flask := A_TickCount
  }
}

AutoPortal(){
	global PortalX
	global PortalY
	Send, {i}
	MouseClick, right, PortalX, PortalY
	Sleep, 200
	MouseClick, left, 630, 400 ; Char Pos
}

MovementSkill(ByRef JoyMultiplier){
	GetKeyState, JoyX, %JoystickNumber%JoyX
	GetKeyState, JoyY, %JoystickNumber%JoyY
	if ((JoyX > 55 || JoyX < 45) && (JoyY > 55 || JoyY < 45)) {
		aux := JoyMultiplier
		JoyMultiplier := 12

		x := defaultCenterX + (JoyX) * JoyMultiplier 
		y := defaultCenterY + (JoyY) * JoyMultiplier  * YAxisMultiplier
		MouseMove, x, y, 0
		
		Sleep, 50
		Send, t
		Sleep, 10
		JoyMultiplier := aux
	} else
		Send, t
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; LABELS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetTimer, WatchJoyLeft, %SetTimerDelay%
SetTimer, WatchJoyRight, %SetTimerDelay%
SetTimer, WatchPOV, %SetTimerDelay%

WatchJoyLeft:
MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, JoyX, %JoystickNumber%JoyX
GetKeyState, JoyY, %JoystickNumber%JoyY
if JoyX > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := JoyX - JoyThresholdUpper
}
else if JoyX < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := JoyX - JoyThresholdLower
}
else
	DeltaX = 0
if JoyY > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaY := JoyY - JoyThresholdUpper
}
else if JoyY < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaY := JoyY - JoyThresholdLower
}
else
	DeltaY = 0
if MouseNeedsToBeMoved
{
	SetMouseDelay, -1
	x := defaultCenterX + DeltaX * JoyMultiplier 
	y := defaultCenterY + DeltaY * JoyMultiplier  * YAxisMultiplier
	MouseMove, x, y, 0

	IfWinActive, Path of Exile ; AutoMove
		if (AutoMove){
			GetKeyState, JoyU, JoyU ; Not Channeling (RT2)
			if !JoyU {
				Click, down, middle
				SetTimer, AutoMoveAux, %SetTimerDelay%
			}
		}
}
return

WatchJoyRight:
MouseNeedsToBeMoved := false
SetFormat, float, 03
GetKeyState, JoyX, %JoystickNumber%JoyZ
GetKeyState, JoyY, %JoystickNumber%JoyR
if JoyX > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaX := JoyX - JoyThresholdUpper
}
else if JoyX < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaX := JoyX - JoyThresholdLower
}
else
	DeltaX = 0
if JoyY > %JoyThresholdUpper%
{
	MouseNeedsToBeMoved := true
	DeltaY := JoyY - JoyThresholdUpper
}
else if JoyY < %JoyThresholdLower%
{
	MouseNeedsToBeMoved := true
	DeltaY := JoyY - JoyThresholdLower
}
else
	DeltaY = 0
if MouseNeedsToBeMoved
{
	SetMouseDelay, -1
	MouseMove, DeltaX * JoyMultiplierPrecision, DeltaY * JoyMultiplierPrecision * YAxisMultiplier, 0, R
}
return


WatchPOV:
POV := GetKeyState("JoyPOV")
KeyToHoldDownPrev := KeyToHoldDown
if (POV < 0)
	KeyToHoldDown := ""
else if (POV = 0) ;	Up
    KeyToHoldDown := UpPOV
else if (POV = 9000) ; Left
    KeyToHoldDown := LeftPOV
else if POV = 18000 ; Down
    KeyToHoldDown := DownPOV
else ; Right
    KeyToHoldDown := RightPOV
if (KeyToHoldDown = KeyToHoldDownPrev)
    return
SetKeyDelay -1
if KeyToHoldDownPrev
    Send, {%KeyToHoldDownPrev% up}
if KeyToHoldDown  
    Send, {%KeyToHoldDown% down}
return

AutoMoveAux:
if(MouseNeedsToBeMoved = false) {
	Click, up, middle
	SetTimer, AutoMoveAux, Off
}
return

; Hotkey support label

WaitForButtonUp2:
if GetKeyState("Joy2")
    return
Click, up, left
SetTimer, WaitForButtonUp2, Off
return

WaitForButtonUp7:
if GetKeyState("Joy7")
    return
Click, up, left
SetTimer, WaitForButtonUp7, Off
return

WaitForButtonUp8:
if GetKeyState("Joy8")
    return
Click, up, right
SetTimer, WaitForButtonUp8, Off
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; JOY REMAP
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Joy1:: ; SQUARE
MovementSkill(JoyMultiplier)
return

Joy2:: ; X
if GetKeyState("Joy7") ;; Unclick Protect
    return
Click, down, left
SetTimer, WaitForButtonUp2, %SetTimerDelay%
return

Joy3:: ; CIRCLE
FlaskUtility()
return

Joy4:: ; TRIANGLE
FlaskLife()
return

Joy5:: ; LT1
AutoPortal()
return

Joy6:: ; RT1
return

Joy7:: ; LT2
Click, down, left
SetTimer, WaitForButtonUp7, %SetTimerDelay%
return

Joy8:: ; RT2
Click, down, right
if FlaskAutoToggle
	FlaskAuto(tc_flask)
SetTimer, WaitForButtonUp8, %SetTimerDelay%
return

Joy9:: ; SHARE
Send, {Space}
return

Joy10:: ; OPTIONS
Send, {Esc}
return

Joy11:: ; LS
Send,a
return

Joy12:: ; RS
return

F3::ExitApp
F4::Reload