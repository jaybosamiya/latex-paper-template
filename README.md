# LaTeX Paper Template

This repository is a template to have a good point to start from for
writing a paper/report using LaTeX.

It uses a nice build system
([latexrun](https://github.com/aclements/latexrun)) which makes it
much easier to notice build-errors etc. All necessary components are
kept within this repository, and all you should need is a proper LaTeX
installation, `make` and `python3`.

## How to Use

Run `make` to build, and `make clean` to clean up.

This should automatically do the right thing to build your PDFs. If
`make` is unable to make a decision, it will ask you to configure the
`Makefile` by giving you the right instructions.
