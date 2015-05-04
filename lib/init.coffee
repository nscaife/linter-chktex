module.exports =
  config:
    chktexExecutablePath:
      default: null
      title: 'chktex Executable Path'
      type: 'string'

  activate: ->
    console.log 'activate linter-chktex'
