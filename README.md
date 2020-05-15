# LaTeX Paper Template

This repository is a template to have a good point to start from for
writing a paper/report/homework/assignments using LaTeX.

It uses a nice build system
([latexrun](https://github.com/aclements/latexrun)) which makes it
much easier to notice build-errors etc. All necessary components are
kept within this repository, and all you should need is a proper LaTeX
installation, `make` and `python3`.

## How to Use

Run `make` to build, and `make clean` to clean up.

This should automatically do the right thing to build your PDFs. If
`make` is unable to make a decision, it will ask you to configure the
`Makefile` by giving you the right instructions. In particular,
irrespective of how many `.tex` files are in the current directory, it
will try to figure out the best course of action based on the files,
and if it cannot, then it will recommend setting up a configuration
variable to guide it.

## How to make pretty PDF diffs

If you are in `MAIN_TARGET` mode, then the `make diff-*` set of
commands are unlocked. They can be used to get a diff against any git
commit, easily. For example `make diff-abcde` will create a new PDF
file with a diff against the commit `abcde`.

To make it more convenient to do such diffs, however, you can set up
the `DIFF_REVISIONS` variable, which will automatically unlock the
`make diff` command which will perform a diff against all the
revisions specified.

Requires `latexdiff` to be installed on your system. Can be installed
via `sudo apt install latexdiff` or similar command based on your
package manager.

## How to make pretty standalone HTML

If you set up `HTML_GENERATION` variable to a non-empty value, after
installing
[`pdf2htmlEX`](https://coolwanglu.github.io/pdf2htmlEX/). This should
generate a (standalone) HTML file beside each PDF generated.

## Updating to the latest Makefile

Run `make update-makefile` to update to the latest version of the 
Makefile.
