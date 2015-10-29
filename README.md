# linter-chktex package

This Atom package provides a [Linter](https://github.com/AtomLinter/linter) interface for the LaTeX `chktex` utility.  It provides real-time stylistic suggestions as you write.

## Installation

1. Install `chktex` if it is not already installed.  `chktex` is installed by default with [TeX Live](https://www.tug.org/texlive/), but you may have to install it separately with other distributions.
2. `apm install linter-chktex`
3. If `chktex` is not in your PATH, you will need to set the `executablePath` to point to the `chktex` executable (see below).

## Settings
You can configure linter-chktex by editing ~/.atom/config.cson (choose Open Your Config in Atom menu).  If you want to pass additional command line arguments to `chktex` (for example, to enable or disable specific checks), you can do so using the `chktexArgs` setting.
```
'linter-chktex':
    executablePath: "C:\\texlive\\2014\\bin\\win32\\chktex.exe",
    chktexArgs: ["-wall", "-n22", "-n30", "-e16"]
```

For more information, see the `chktex` [manual](http://www.nongnu.org/chktex/ChkTeX.pdf).

## Contributing
If you would like to contribute, please submit a pull request!
