# data-visualization with Julia

## Install julia

To install julia, we recommend using juliaup, a julia version manager.

Windows users can simply install the `julia` app from the store. Other OS can run this curl script:

```sh
curl -fsSL https://install.julialang.org | sh
```

## Run julia

Julia comes with a full-featured interactive command-line REPL (read-eval-print loop) built into the julia executable. In addition to allowing quick and easy evaluation of Julia statements, it has a searchable history, tab-completion, many helpful keybindings, and dedicated help and shell modes.

### To open a REPL
Simply use the `julia` command

### One can access other modes in the REPL:

- Shell: press the `;` key
- Pkg (Package manager): press the `]` key
- Using `delete` on an empty line allows going back to the julia mode

### Maintaining julia up-to-date

In a console, use the following command

```sh
juliaup update
```

## Editors

The two most popular editors for julia out there are `vscode` and `Pluto.jl`. Here we will mainly use `Pluto.jl`, a reactive notebook manager for Julia.

### Installing Pluto.jl

In the Julia REPL:

```julia
using Pluto # Should prompt you `y` or `n` to install it
```

### Launching a Pluto session

```julia
using Pluto; Pluto.run()
```

The command above will load the package, launch a local web server (a link will be provided), and, usually open the notebooks' manager.

One can then open a new notebook, load a notebook from recent history or load a notebook at a specific path.

Note that notebook files can also be executed as julia script without any need for Pluto.
