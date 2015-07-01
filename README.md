# linter-chktex package

This Atom package provides a [Linter](https://github.com/AtomLinter/linter) interface for the LaTeX `chktex` utility.  It provides real-time stylistic suggestions as you write.

## Installation

1. Install the Linter package. If Linter is not installed, please follow the instructions [here](https://github.com/AtomLinter/Linter).  
2. Install `chktex` if it is not already installed.  `chktex` is installed by default with [TeX Live](https://www.tug.org/texlive/), but you may have to install it separately with other distributions.
3. `apm install linter-chktex`
4. If `chktex` is not in your PATH, you will need to set the `chktexExecutablePath` to point to the directory containing `chktex`.

## Settings
You can configure linter-chktex by editing ~/.atom/config.cson (choose Open Your Config in Atom menu):
```
'linter-chktex':
    chktexExecutablePath: "C:\\texlive\\2014\\bin\\win32"
```

## Contributing
If you would like to contribute, please submit a pull request!
