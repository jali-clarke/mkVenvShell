{
    projectName,
    python,
    requirements,

    buildInputs ? [],
    nixpkgs ? import <nixpkgs> {}
}:
let pythonNix = nixpkgs."${python}Full";
    pip = nixpkgs."${python}Packages".pip;
    venv = import ./venv.nix {
        inherit buildInputs requirements projectName pip;
        stdenv = nixpkgs.stdenv;
    };

    grep = nixpkgs.gnugrep;
in nixpkgs.mkShell {
    name = "${projectName}-shell";
    buildInputs = buildInputs ++ [pythonNix pip];

    shellHook = ''
        unset SOURCE_DATE_EPOCH
        export PIP_PREFIX="${venv}"
        export PATH="$PIP_PREFIX/bin:$PATH"
        export PYTHONPATH="$PIP_PREFIX/lib/python$(${pythonNix}/bin/python -c 'import sys; version = sys.version_info; print(f"{version.major}.{version.minor}")')/site-packages:$PYTHONPATH"
    '';
}