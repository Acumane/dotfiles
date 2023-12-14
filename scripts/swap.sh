#!/usr/bin/env python
"""
Window swapper:
- if swap against workspace edge, move it to next workspace
- if move would exceed fixed workspace count, do nothing
- option: follow to new workspace only if active empty
- shift: swap immediate
"""
from subprocess import getoutput as run
from sys import argv as args
import json
import re

windows = json.loads(run("hyprctl clients -j"))
active = json.loads(run("hyprctl activewindow -j"))
workspace = json.loads(run("hyprctl activeworkspace -j"))
nWin = workspace["windows"] - (len(active["grouped"])-1 if active["grouped"] else 0)
if nWin == 0: exit()

shift = True if re.search("S-", args[1]) else False
dir = re.search(r"(?:^|[SMAC]-)([uldr])$", args[1])
dir = dir.group(1) if dir else ""

# print(active["address"], active["at"])
if dir == 'u' or dir == 'd': run(f"hyprctl dispatch swapwindow {dir}"); exit()
for w in windows:
    if shift or nWin == 1: break
    if w["address"] in active["grouped"] or w["pid"] == -1 \
    or w["workspace"]["id"] != active["workspace"]["id"]: continue
    # print(w["address"], w["at"])

    if dir == 'l' and active["at"][0] > w["at"][0] \
    or dir == 'r' and active["at"][0] < w["at"][0]: 
        run(f"hyprctl dispatch swapwindow {dir}"); exit()

silent = "" # silent = "silent" if nWin > 1 else ""
run(f"hyprctl dispatch denywindowfromgroup on")
if dir == 'l' and active["workspace"]["id"] > 1:
    run(f"hyprctl dispatch movetoworkspace{silent} -1")
if dir == 'r' and active["workspace"]["id"] < 3: 
    run(f"hyprctl dispatch movetoworkspace{silent} +1")
run(f"hyprctl dispatch denywindowfromgroup off")

