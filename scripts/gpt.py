from subprocess import run
from pyperclip import copy
import openai

with open('keys') as f:
  openai.api_key = f.readline()

print(openai.api_key)

sel = run('xsel', capture_output=True, text=True).stdout

out = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages = [
    {"role": "system", "content": "You briefly respond to multiple choice and short answer questions"},
    {"role": "user", "content": sel},
  ]
)

res = out["choices"][0]["message"]["content"]
copy(res)
