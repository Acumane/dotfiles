from sys import argv as args
from os import makedirs as mkdir, path
from subprocess import getoutput as run
from rich import print
from re import split

links = args[1]
base_dir = path.dirname(links)

with open(links, 'r') as file:
	for line in file:
		line = line.strip()
		if line.startswith("#"): continue
		if line:
			print(line)
			src, sep, dest = split(r'\ *(->|~>)\ *', line)
			no_sym = "true" if '-' in sep else "false"
			pat = "-path *" if '/' in src else "-name " # disambiguation
			src_path = run(f"find {base_dir} {pat}{src}").strip()
			
			if src_path:
				print(f"'{dest}'")
				mkdir(path.dirname(dest), exist_ok=True)
				args = f'{src_path} {dest}'
				out = run(f"ln -f {args} || {no_sym} && cp -f {args} || ln -fs {args}")
				errs = [l.rsplit(":", 1)[1].strip() for l in out.split('\n')]
				print(errs)
				if errs:
					for e in reversed(errs):
						if "Permission" in e:
							print(f"[red]{e}; retry as sudo"); exit(1)
						if "cross-device" in e:
							if '~' in sep: print(f'[green]Symlinked "{src}" [yellow](cross-dev/vol)')
							if '-' in sep: print(f'[green]Copied "{src}" [yellow](cross-devl/vol)')
							break
						if "same" in e: # can't cp -f over symlink to same file
							run(f"rm -f {dest} && cp -f {args}")
							continue
						if "No such" in e: print(f"[red]Invalid dest"); exit(1)
				else: print(f'[green]Hardlinked "{src}"')

			else: print(f"{src} not found")
