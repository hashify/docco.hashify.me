(function() {
  var el, escape, hash, language, languages, parse, pathname, regex, regexes, render, search, showdown, symbol, symbols, _i, _len;

  showdown = new Showdown('datetimes', 'abbreviations');

  parse = function(ext, text) {
    var code, docs, has_code, line, regex, sections, _i, _len, _ref;
    regex = regexes[ext] || regexes["default"];
    has_code = docs = code = '';
    sections = [];
    _ref = text.split('\n');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      line = _ref[_i];
      if (regex.test(line) && !/^(#!\/|\s*#\{)/.test(line)) {
        if (has_code) {
          sections.push({
            docs: docs,
            code: code
          });
          has_code = docs = code = '';
        }
        docs += line.replace(regex, '') + '\n';
      } else {
        has_code = true;
        code += line + '\n';
      }
    }
    sections.push({
      docs: docs,
      code: code
    });
    return sections;
  };

  escape = function(text) {
    return text.replace(/[&<>"'`]/g, function(chr) {
      return "&#" + (chr.charCodeAt(0)) + ";";
    });
  };

  render = function(title, ext, text) {
    var code, html, section, _i, _len, _ref;
    html = '<table cellpadding=0 cellspacing=0>';
    html += "<tr><th class=docs><h1>" + (escape(title)) + "</h1></th></tr>";
    _ref = parse(ext, text);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      section = _ref[_i];
      code = '<code';
      if (ext) code += " class=language-" + ext;
      code += ">" + (escape(section.code)) + "</code>";
      html += "<tr>\n  <td class=docs>" + (showdown.convert(section.docs)) + "</td>\n  <td class=code><pre class=prettyprint>" + code + "</pre></td>\n</tr> ";
    }
    return html += '</table>';
  };

  symbols = {
    '//': ['c', 'cpp', 'cs', 'java', 'js', 'php'],
    '#': ['coffee', 'pl', 'py', 'rb', 'sh']
  };

  regexes = {
    "default": /^\s*(#|\/\/)\s?/
  };

  for (symbol in symbols) {
    languages = symbols[symbol];
    regex = new RegExp('^\\s*' + symbol + '\\s?');
    for (_i = 0, _len = languages.length; _i < _len; _i++) {
      language = languages[_i];
      regexes[language] = regex;
    }
  }

  el = document.getElementById('docco');

  Hashify.render = function(text) {
    var ext, match, title, _ref;
    text = text.replace(/\s+$/, '');
    title = 'Untitled';
    ext = null;
    if (match = /^[ \t]*(.+?)[ \t]*(?:[\n\r]+|$)/.exec(text)) {
      _ref = match, match = _ref[0], title = _ref[1];
      text = text.replace(match, '');
      if (match = /[.](\w+)$/.exec(title)) ext = match[1];
    }
    el.innerHTML = render(title, ext, text);
    return prettyPrint();
  };

  hash = location.hash, pathname = location.pathname, search = location.search;

  if (pathname + hash !== '/' && !/[?;]mode:presentation(;|$)/.test(search)) {
    location.search += (search ? '&' : '?') + 'mode:presentation';
  }

}).call(this);
