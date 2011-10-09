showdown = new Showdown 'datetimes', 'abbreviations'

# Modified version of Docco's `parse` function.
parse = (ext, text) ->
  regex = regexes[ext] or regexes.default
  has_code = docs = code = ''

  sections = []
  for line in text.split '\n'
    if regex.test(line) and not /^(#!\/|\s*#\{)/.test(line)
      if has_code
        sections.push {docs, code}
        has_code = docs = code = ''
      docs += line.replace(regex, '') + '\n'
    else
      has_code = yes
      code += line + '\n'
  sections.push {docs, code}
  sections

escape = (text) ->
  text.replace /[&<>"'`]/g, (chr) -> "&##{chr.charCodeAt 0};"

render = (title, ext, text) ->
  html = '<table cellpadding=0 cellspacing=0>'
  html += "<tr><th class=docs><h1>#{title}</h1></th></tr>"
  for section in parse ext, text
    code = '<code'
    code += " class=language-#{ext}" if ext
    code += ">#{escape section.code}</code>"
    html += """
      <tr>
        <td class=docs>#{showdown.convert section.docs}</td>
        <td class=code><pre class=prettyprint>#{code}</pre></td>
      </tr> """
  html += '</table>'

symbols =
  '//': ['c', 'cpp', 'cs', 'java', 'js', 'php']
  '#' : ['coffee', 'pl', 'py', 'rb', 'sh']

regexes = default: /^\s*(#|\/\/)\s?/
for symbol, languages of symbols
  regex = new RegExp '^\\s*' + symbol + '\\s?'
  for language in languages
    regexes[language] = regex

el = document.getElementById 'docco'

# `Hashify.render` is invoked each time the editor's value changes.
Hashify.render = (text) ->
  text = text.replace /\s+$/, ''
  title = 'Untitled'
  ext = null

  if match = /^[ \t]*(.+?)[ \t]*(?:[\n\r]+|$)/.exec text
    [match, title] = match
    text = text.replace match, ''
    if match = /[.](\w+)$/.exec title
      ext = match[1]

  el.innerHTML = render title, ext, text
  do prettyPrint

# Always use presentation mode for nonempty documents.
{hash, pathname, search} = location
if pathname + hash isnt '/' and not /[?;]mode:presentation(;|$)/.test search
  location.search += (if search then '&' else '?') + 'mode:presentation'
