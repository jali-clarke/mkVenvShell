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

    requirements = [./requirements-dev.txt ./requirements.txt]; # notice lack of double quotes; assumes `requirements*.txt` exists in cwd
in mkVenvShell {
    projectName = "cool-project-name"; # required
    python = "python38"; # required - the items nixpkgs."${python}Full" and nixpkgs."${python}Packages" must exist
    requirements = <path-to-requirements-file>; # required

    pipIndex = <url-to-pip-index>; # optional - defaults to PyPi
    buildInputs = [list-of-other-inputs]; # optional - defaults to empty list
    nixpkgs = <...>; # optional - defaults to `import <nixpkgs> {}`

    shellHook = ''
        <...>
    ''; # optional - shell hook analogous to shellHook for nixpkgs.mkShell
}
```

## known issues / caveats

* does not support nested references to `requirements` files on the local file system (i.e. `-r` cannot be used with a local file within a `requirements` file, only remote ones)
* does not support `-e` within `requirements` files
* no wheel-level / package-level build caching.  if you change even a single package in your `requirements` file(s), all will be redownloaded and reinstalled if not done so already
* you cannot install packages to the created virtual environment via `pip` after the fact; once created, a virtual environment is frozen
