These config files make the BIND RPG books look and act the way they do.

# Usage

To make a book, start a git, then do:

> git submodule add https://gitlab.com/bindrpg/config config

> git commit -m"add config submodule"

> cp config/main.tex config/.gitignore .

Edit 'main.tex', and input your tex files by writing `\include{my_file.tex}`.

# Docs

You can create the [documentation][docs] with

> make docs

Test your changes before committing with

> make test

# TeXnical Details

This thing's handled as a submodule in the other documents, so changing it will change all BIND books.
Any changes to the master branch should be tested in the `core` and `aif` projects first.

And when pulling, remember to do:

> git pull --recurse-submodules

[docs]: https://gitlab.com/bindrpg/config/-/jobs/artifacts/master/raw/docs.pdf?job=compile_pdf
