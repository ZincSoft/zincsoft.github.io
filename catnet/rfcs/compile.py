#!/usr/bin/python3

import markdown2
import sys

assert(len(sys.argv) == 3)

data = ""

with open("template.html", "r") as f:
    data = f.read()

with open(sys.argv[1], "r") as f:
    data = data.replace("<!-- INSERT_MARKDOWN_TO_HTML_HERE -->", markdown2.markdown(f.read()))
    data = data.replace("<!-- TITLE -->", sys.argv[2])
  
assert(".md" in sys.argv[1])

with open(sys.argv[1].replace(".md", ".html"), "w+") as f:
    f.truncate();
    f.write(data)
