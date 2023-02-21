#Warn
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
DetectHiddenWindows On
SetTitleMatchMode 2
SetKeyDelay, 0, 50
mainON := 1
symON := 0

GroupAdd Terminal, ahk_exe Code.exe
GroupAdd Terminal, ahk_exe WindowsTerminal.exe

GroupAdd noGlobal, ahk_exe krita.exe
GroupAdd noGlobal, ahk_exe starcitizen.exe
GroupAdd noGlobal, ahk_exe javaw.exe
GroupAdd noGlobal, ahk_exe KSP_x64.exe


if !A_IsAdmin
    Run, % "*RunAs " (A_IsCompiled ? "" : A_AhkPath " ") Chr(34) A_ScriptFullPath Chr(34)

Menu Tray, Icon, viem.ico, , 1

Run %A_ScriptDir%\viem.sym.ahk
Run %A_ScriptDir%\viem.apps.ahk
Run %A_ScriptDir%\VD\viem.vd.ahk
; Run %A_ScriptDir%\viem.spell.ahk


^+r::Reload

;############################  SYSTEM-WIDE KEYBINDS  ############################

!F1::
    Suspend Toggle
    mainON := !mainON ; toggle
    If mainON {
        If symON
            Menu Tray, Icon, viem.sym.ico
        Else
            Menu Tray, Icon, viem.ico
    }
    Else {
        If symON
            Menu Tray, Icon, viem.sym-off.ico
        Else
            Menu Tray, Icon, viem-off.ico
    }
    Return

;——— Symbolic layer ————————————————————————————————————————————————————————————
!F2::
    symON := !symON
    PostMessage 0x0111, 65305, , , viem.sym.ahk - AutoHotkey
    If symON
        Menu Tray, Icon, viem.sym.ico
    Else
        Menu Tray, Icon, viem.ico
    Return

;——— Win (#) ———————————————————————————————————————————————————————————————————
#+i::Send {F11}                 ; fullscreen
#i::
    Send {Blind}{Up}
    KeyWait i
    KeyWait i, D T.075
    If !ErrorLevel
        Send {F11}
    Return

#+k::Send #d                    ; minimize ALL
#IfWinNotActive ahk_exe FluentSearch.exe
#k::Send {Blind}{Down}
#j::Send {Blind}{Left}          ; Window positioning
#l::Send {Blind}{Right}
#q::WinClose A                  ; close window
#IfWinNotActive


#w::Return
#Space::Send #+s                ; Win screenshots
#p::Send {Blind}v               ; clipboard
#m::#n                          ; Win side-menu
#,::#i                          ; settings 
#c::#a                          ; connect

#f::#e                          ; Files
#e::Run "%A_Programs%\Gmail"    ; Gmail
#t::Run "%A_Programs%\Tasks"    ; Tasks
#s::Run "%A_Programs%\Spotify"  ; Spotify
#b::Run "%A_Programs%\Brave"    ; Browser
#/::Run "%A_Programs%\Terminal" ; Terminal
#Esc::Run "%A_Programs%\Taskmgr" ; Terminal

#IfWinNotActive ahk_group Terminal
#r::Send ^r                     ; refresh
^p::Send {Blind}v               ; mnemonic paste, (un/re)do
^u::Send {Blind}z
^r::Send {Blind}+z
#IfWinNotActive


;——— Alt navigation ————————————————————————————————————————————————————————————

LAlt::
    KeyWait LAlt
    KeyWait LAlt, D T.1
    If !ErrorLevel
        Send {Browser_Back}
    Return

RAlt::
    KeyWait RAlt
    KeyWait RAlt, D T.1
    If !ErrorLevel
        Send {Browser_Forward}
    Return

Alt::
    If WinActive("ahk_group AltTabWindow") {
        l::AltTab
        j::ShiftAltTab
    }
    Return

!l::
    Send ^{Tab}                 ; next/prev tab
    SendInput {Ctrl Up}
    Return

!j::
    Send ^+{Tab}
    SendInput {Ctrl Up}{Shift Up}
    Return

#If (!WinActive("ahk_group noGlobal"))
;↓↓↓

;——— Other (^,!,+) —————————————————————————————————————————————————————————————
!-::Send —

^d::Send {Del}                  ; accessible Del/Esc
Ctrl::Send {Esc}
Alt & Esc::Return
Ctrl & Esc::Return
Shift & Esc::Return
+BackSpace::Send ^{BackSpace}   ; consistent Backspace

#IfWinNotActive ahk_exe FluentSearch.exe
^i::SendInput {Up}              ; arrows -> ijkl
^k::SendInput {Down}
^j::SendInput {Left}
^l::SendInput {Right}
#IfWinNotActive ahk_exe FluentSearch.exe

^+j::SendInput ^{Left}          ; power L/R
^+l::SendInput ^{Right}


;#############################  TAB-BASED APP KEYS  #############################

!n::Send ^t                     ; new tab
#n::Send ^n                     ; new window

!z::Send, {F11}                 ; fullscreen
#+n::Send ^+n                   ; new private/special window
!q::Send ^w                     ; close tab

; !,::Send ^,                   ; settings
!`::Send ^``                    ; console
