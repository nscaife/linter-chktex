{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'
helpers = require 'atom-linter'
XRegExp = require('xregexp').XRegExp

xcache = new Map

module.exports =
  config:
    executablePath:
      type: 'string'
      default: "chktex"
      description: 'Path to chktex executable'
    chktexArgs:
      type: 'array'
      default: ["-wall", "-n22", "-n30", "-e16"]
      description: 'Additional chktex Command Line Arguments'
    showId:
      type: 'boolean'
      default: false
      description: 'Display ID of Warning/Error'


  activate: (state) ->
    require("atom-package-deps").install("linter-chktex")
      .then ->
        console.log 'linter-chktex loaded'
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.config.observe 'linter-chktex.executablePath',
          (executablePath) =>
            console.log 'observe ' + executablePath
            @executablePath = executablePath
        @subscriptions.add atom.config.observe 'linter-chktex.chktexArgs',
              (chktexArgs) =>
                console.log 'observe ' + chktexArgs
                @chktexArgs = chktexArgs
        @subscriptions.add atom.config.observe 'linter-chktex.showId',
              (showId) =>
                console.log 'observe ' + showId
                @showId = showId

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      name: 'chktex'
      grammarScopes: ['text.tex.latex', 'text.tex.latex.beamer', 'text.tex.latex.memoir', 'text.tex.latex.knitr']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        if fs.existsSync(textEditor.getPath())
          return @lintFile textEditor.getPath()
            .then @parseOutput
        console.log 'file does not exist'
        return []

  lintFile: (filePath) ->
    args = [filePath, '-q', '-I0', '-f%f:%l:%c:%d:%k:%n:%m\\n\\n']
    if chktexArgs
      for x in chktexArgs
        args.push x
    return helpers.exec(executablePath, args, options: {stream: 'stdout'})

  parseOutput: (output, filePath) ->
    # all chktex will output is the length of the error from starting pos
    # so we need to do some math to get correct highlighting
    console.log output
    rawRegex = '^(?<file>.+):(?<line>[0-9]+):(?<colStart>[0-9]+):(?<colLength>[0-9]+):(?<type>.+):(?<id>[0-9]+):(?<message>.+)$'
    toReturn = []
    if xcache.has(rawRegex)
      regex = xcache.get(rawRegex)
    else
      xcache.set(rawRegex, regex = XRegExp(rawRegex))
    #for line in output.split(/\r?\n/)
    for line in output.split('\\n\\n')
      match = XRegExp.exec(line, regex)
      if match
        # console.log 'file ' + match.file
        # console.log 'line ' + match.line
        # console.log 'colStart ' + match.colStart
        # console.log 'colLength ' + match.colLength
        # console.log 'type ' + match.type
        # console.log 'message ' + match.message
        lineStart = 0
        lineStart = parseInt(match.line,10) - 1 if match.line
        colStart = 0
        colStart = parseInt(match.colStart,10) - 1 if match.colStart
        lineEnd = 0
        lineEnd = parseInt(match.line,10) - 1 if match.line
        colEnd = 0
        colEnd = colStart + parseInt(match.colLength,10) if match.colLength
        message = match.message
        message = '<span style="width: 2em; text-align: center" class="inline-block highlight-warning">' + match.id + '</span> ' + message if showId
        toReturn.push(
          type: match.type,
          html: message,
          filePath: match.file,
          range: [[lineStart, colStart], [lineEnd, colEnd]]
        )
      # console.log toReturn
    return toReturn
