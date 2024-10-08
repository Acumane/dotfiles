from subprocess import run
from pyperclip import copy
from os import getenv
import openai

openai.api_key = getenv("GPT_KEY")

sel = run("xsel", capture_output=True, text=True).stdout

out = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages = [
    {"role": "system", "content": "You briefly respond to multiple choice and short answer questions"},
    {"role": "user", "content": sel},
  ]
)

res = out["choices"][0]["message"]["content"]
copy(res)
