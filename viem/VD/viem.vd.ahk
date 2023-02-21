#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
ListLines Off
SetBatchLines -1
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#KeyHistory 0
#WinActivateForce

Process, Priority,, H

SetWinDelay -1
SetControlDelay -1
curVD := VD.getCurrentDesktopNum()
Menu Tray, Icon, %curVD%.ico

; VD library (https://github.com/FuPeiJiang/VD.ahk)
#Include %A_LineFile%\..\VD.ahk

; Hiding invisible programs that have a window.
WinHide, % "Fluent Search"

VD.createUntil(2) ; make sure we have at least 2 VD

Return

#1::
    VD.goToDesktopNum(1)
    Menu Tray, Icon, 1.ico
    Return
#2::
    VD.goToDesktopNum(2)
    Menu Tray, Icon, 2.ico
    Return

; VD cycle w/ wrap
#+j::
    VD.goToRelativeDesktopNum(-1)
    curVD := VD.getCurrentDesktopNum()
    Menu Tray, Icon, %curVD%.ico
    Return
#+l::
    VD.goToRelativeDesktopNum(+1)
    curVD := VD.getCurrentDesktopNum()
    Menu Tray, Icon, %curVD%.ico
    Return

; Move window to next/prev VD
#^j::
    VD.MoveWindowToRelativeDesktopNum("A", -1)
    curVD := VD.getCurrentDesktopNum()
    Menu Tray, Icon, %curVD%.ico
    Return
#^l::
    VD.MoveWindowToRelativeDesktopNum("A", 1)
    curVD := VD.getCurrentDesktopNum()
    Menu Tray, Icon, %curVD%.ico
    Return

; Move window to next/prev VD & follow it
; #^j::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", -1))
; #^l::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", 1))

; Create/remove a VD
; #+n::VD.createDesktop()
; #+q::VD.removeDesktop(VD.getCurrentDesktopNum())