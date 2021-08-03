#!/usr/bin/python3

import markdown2
import sys
import os
import subprocess
import json
import hashlib
import misaka


##### CATNET RCCS ######
os.chdir("catnet/rfcs/")

rfc_post_template = """
<div style="padding-bottom: 25px">
<a class="no-underline h5 bold text-accent" title="{ TO }" href="{ TO }">RFC { RFC_NUMBER }</a>
<h2 class="h1 lh-condensed col-9 mt-0"><a class="link-primary" title="{ TO }" href="{ TO }">{ TITLE }</a></h2>
<a class="no-underline h5 bold text-accent" title="{ TO_MARKDOWN} " href="{ TO_MARKDOWN }">download raw</a>
</div>
"""

persistant = ""
with open("persistant", "r") as f:
    persistant = f.read()

persistant = json.loads(persistant)

for filename in os.listdir():
    if not '.html' in filename: continue
    if not 'rfc' in filename: continue
    if os.path.exists("markdown/" + filename.replace(".html", ".md")): continue
    os.remove(filename)

## Actually compile the markdown
os.chdir("markdown")
for filename in os.listdir():
    if not ".md" in filename:
        continue

    m = hashlib.sha256()

    data = ""
    with open("../template.html", "r") as f:
        data = f.read()

    with open(filename, "r") as f:
        file_data = f.read()
        _hash = hashlib.sha256(file_data.encode('utf-8')).hexdigest()

        if ("all" in sys.argv) or (not filename in persistant) or (not _hash == persistant[filename]):
            print('processing: ' + filename + '....')
            
            title = file_data.split("\n")[0]
            data = data.replace("<!-- INSERT_MARKDOWN_TO_HTML_HERE -->", subprocess.check_output(["ruby", "../markdown.rb", filename]).decode('utf-8')) # misaka.html("\n".join(file_data.split("\n")[1:]))) # markdown2.markdown("\n".join(file_data.split("\n")[1:])))

            data = data.replace("<!-- TITLE -->", title)

            if type(_hash) == str:
                persistant[filename] = _hash
            else:
                persistant[filename] = _hash.hexdigest()

            with open("../" + filename.replace(".md", ".html"), "w+") as f:
                f.truncate();
                f.write(data)

## Write the persistant
os.chdir("../")
with open("persistant", "w") as f:
    f.write(json.dumps(persistant))


## Populate the index.html with posts
posts = ""
for filename in os.listdir():
    if (not ".html" in filename) or (not 'rfc' in filename):
        continue

    rfc_number = filename.split('-')[1]
    title = " ".join(filename.split('-')[2:]).replace(".html", "").title().replace("Rfcs", "RFCs").replace("Ip", "IP").replace("Cip", "CIP")
    to = filename
    to_markdown = "markdown/" + filename.replace(".html", ".md")

    posts += rfc_post_template.replace("{ TO }", to).replace("{ TO_MARKDOWN }", to_markdown).replace("{ RFC_NUMBER }", rfc_number).replace("{ TITLE }", title)

    posts += "<br/>"

## Write the templated index.html
with open("index.html", "w+") as index:
    with open("index.html.template", "r") as template:
        index.write(template.read().replace("<!-- INSERT_RFCS -->", posts))

os.chdir("../../")
