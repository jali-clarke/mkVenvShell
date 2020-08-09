# mkVenvShell

## what is this

this project is intended to ease python developers into using `nix` by using `requirements.txt` files to generate a virtual environment which is loaded / activated via `nixpkgs.mkShell`.  if you use this project, the hope is that you eventually move to a completely `nix`-managed process instead of this hybrid-ish approach.

## how to use

in a `shell.nix`:

```
let mkVenvShell = import(
        builtins.fetchGit {
            url = "https://github.com/jali-clarke/mkVenvShell.git"; # can also clone via ssh
            # also consider pinning revisions
        }
    );

    requirements = ./requirements.txt; # notice lack of double quotes; assumes `requirements.txt` exists in cwd
in mkVenvShell {
    venvName = "cool-venv-name"; # required
    python = "python38"; # required - the items nixpkgs."${python}Full" and nixpkgs."${python}Packages" must exist
    requirements = <path-to-requirements-file>; # required

    buildInputs = [list-of-other-inputs]; # optional - defaults to empty list
    nixpkgs = <...>; # optional - defaults to `import <nixpkgs> {}`
}
```
