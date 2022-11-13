#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input

GroupAdd Browser, ahk_exe brave.exe
GroupAdd Browser, ahk_exe msedge.exe
GroupAdd Browser, ahk_exe chrome.exe

;##############################  APP-SPECIFIC KEYS  ##############################

;——— Browser features ——————————————————————————————————————————————————————————
#IfWinActive ahk_group Browser
!+j::Send !{PgUp}               ; shift/move tabs
!+l::Send !{PgDn}
![::                            ; expand/collapse groups
!]::
	Send !+6
Return
!^l::                           ; move to next window
!^j::
	Send !+7
Return
!^i::Send !+8
!BackSpace::Send !{Del}         ; close duplicate tabs
!r::Send ^+t                    ; open recently closed

!p::Send ^p                     ; print dialog
!h::Send ^h                     ; history
!b::Send ^+b                    ; bookmarks bar
^b::^d                          ; bookmark site
^+b::^+d                        ; bookmark all tabs
!c::Send {F6}                   ; focus address bar
!s::Send ^e                     ; search
~!z::Send {F11}                 ; fullscreen
!`::                            ; console
!/::
	Send {F12}
Return

;——— Google Tasks (embed) ——————————————————————————————————————————————————————
#IfWinActive Tasks ahk_exe brave.exe
Tab::Send ^]                    ; indent
+Tab::Send ^[                   ; unindent

;——— Visual Studio Code ————————————————————————————————————————————————————————
#IfWinActive ahk_exe Code.exe
^Tab::Send ^+t                  ; Markdown bullet points (cycle)
#r::Send, {F10}
Media_Play_Pause::Send, {F5}    ; run/debug

;——— Krita —————————————————————————————————————————————————————————————————————
#IfWinActive ahk_exe krita.exe
!m::Send ^.                     ; side-menu

;——— Files —————————————————————————————————————————————————————————————————————
#IfWinActive ahk_exe Explorer.EXE
^h::Send {F2}                   ; rename
^=::SendInput ^{WheelUp}        ; resize/scale
^-::SendInput ^{WheelDown}

;——— Discord ———————————————————————————————————————————————————————————————————
#IfWinActive ahk_exe Discord.exe
!i::Send ^+{Tab}                ; vertical tab alternation
!k::Send ^{Tab}
!m::Send ^u                     ; side menu
!c::Send ^k                     ; quick panel
!.::Send ^e                     ; emoji picker
^m::Send ^+m                    ; mute
!p::Send ^p                     ; pins
!z::Send ^+f                    ; fullscreen
!l::
!j::
    Send ^!{Right}
Return

;——— Spotify ———————————————————————————————————————————————————————————————————
#IfWinActive ahk_exe Spotify.exe
!,::Send ^p                     ; settings
^j::Send +{Left}                ; scrub backward
^l::Send +{Right}               ; scrub forward
!s::Send ^l                     ; search

;——— Epic Pen ——————————————————————————————————————————————————————————————————
#If true
#w::Send ^!i                      ; toggle ink layer
!w::Send ^!t                      ; toggle toolbar
^w::Send ^!p                      ; switch to pen
#BackSpace::Send ^!{c}            ; clear
;Esc                                unfocus
;^],[                               brush size
#If

;——— Unreal Editor —————————————————————————————————————————————————————————————
#IfWinActive ahk_exe UnrealEditor.exe
LShift::q

;####################################  GAMES  ###################################
;——— Minecraft —————————————————————————————————————————————————————————————————
#IfWinActive ahk_exe javaw.exe
`::F3                               ; debug
^r::SendInput, {F3 down}{A}{F3 up}  ; reload chunks
~c::Send {Blind}{F1}
; WheelLeft::1                        ; first slot
; WheelRight::9                       ; last slot

;——— Star Citizen ——————————————————————————————————————————————————————————————
#IfWinActive ahk_exe starcitizen.exe
F2::                                ; cancel all yaw/pitch vel
	KeyWait F2
	KeyWait F2, D T.075
	if !ErrorLevel
		Send {F3}
        Sleep 200 ; (wait 50ms) 
		Send {F3}
Return

~z & Space::                        ; reset freelook
	Send {x down}
	Sleep 25
	Send {NumpadMult down}
	Sleep 200
	Send {NumpadMult up}
	Send {x up}
Return

#IfWinActive ahk_exe KSP_x64.exe
WheelUp::Send =
WheelDown::Send -

#IfWinActive