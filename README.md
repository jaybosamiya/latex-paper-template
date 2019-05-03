# LaTeX Paper Template

This repository is a template to have a good point to start from for
writing a paper/report using LaTeX.

It uses a nice build system
([latexrun](https://github.com/aclements/latexrun)) which makes it
much easier to notice build-errors etc. All necessary components are
kept within this repository, and all you should need is a proper LaTeX
installation, `make` and `python3`.

## How to Use

Simple run `make` to build the PDF. Use `make clean` to clean up the
temporary directory.

If your project uses only one `.tex` file, this will automatically do
the right thing. If your project has more than one `.tex` file, then
you should open up the [`Makefile`](./Makefile) and set up the
configuration accordingly. Instructions are present inside the file.
