import sys
import os
import pycmarkgfm

class HighlighterRenderer(m.HtmlRenderer):
    def blockcode(self, text, lang):
        try:
            lexer = get_lexer_by_name(lang, stripall=True)
        except ClassNotFound:
            lexer = None

        if lexer:
            formatter = HtmlFormatter()
            return highlight(text, lexer, formatter)

        return '\n<pre><code>{}</code></pre>\n'.format(
                            h.escape_html(text.strip()))

if len(sys.argv) == 1:
    print('Please supply a subcommand.')
elif sys.argv[1] == '--help' or sys.argv[1] == '-h':
    print('''Usage: rfc_util.py [SUBCOMMAND]

Subcommands:
    pull    Pull the newest RFCs in markdown form.
    html    Transpile all the markdown into HTML.''')
elif sys.argv[1] == 'pull':
    old = os.getcwd();
    os.chdir('../../');

    os.system('git fetch catnet-rfcs main')
    os.system('git subtree pull --prefix catnet/rfcs/markdown catnet-rfcs main --squash')

    os.chdir(old)
elif sys.argv[1] == 'html':
    template_html = ''
    with open('template.html') as f:
        template_html = f.read()


print(pycmarkgfm.gfm_to_html("Hello ~world~"))
