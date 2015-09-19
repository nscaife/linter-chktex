{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      default: ""
      type: 'string'
      title: 'chktex Executable Path'

  activate: (state) ->
    require("atom-package-deps").install("linter-chktex")
      .then ->
        console.log 'linter-chktex loaded'
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.config.observe 'linter-chktex.executablePath',
          (executablePath) =>
            @executablePath = executablePath

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['text.tex.latex', 'text.tex.latex.beamer', 'text.tex.latex.memoir']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) =>
        return new Promise (resolve, reject) =>
          filePath = textEditor.getPath()
          results = []
          cmd = if @executablePath? then @executablePath + "chktex" else "chktex"
          process = new BufferedProcess
            command: cmd
            args: [filePath, '-I0', '-wall','-n22','-n30','-e16','-f%l:%c:%d:%k:%n:%m\\n' ]
            stdout: (data) ->
              lines = data.split('\\n')
              lines.pop()
              lines = lines.map (line) -> line.split(':')
              for line in lines when line.length == 6
                do (line) ->
                  [lineStart, colStart, colLen] = line[0..2].map (entry) ->
                    parseInt(entry,10)
                  result = {
                    range: [
                      [lineStart - 1, colStart - 1],
                      [lineStart - 1, colStart - 1 + colLen]
                    ]
                    type: line[3] + " " + line[4]
                    text: line[5]
                    filePath: filePath
                  }
                  results.push result
            exit: (code) ->
              return resolve [] unless code is 0
              return resolve [] unless results?
              resolve results
          process.onWillThrowError ({error,handle}) ->
            atom.notifications.addError "Failed to run #{@executablePath}",
              detail: "#{error.message}"
              dismissable: true
            handle()
            resolve []
