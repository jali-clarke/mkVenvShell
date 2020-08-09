{
    venvName,
    python,
    requirements,

    buildInputs ? [],
    nixpkgs ? import <nixpkgs> {}
}:
let pythonNix = nixpkgs."${python}Full";
    pip = nixpkgs."${python}Packages".pip;
    venv = import ./venv.nix {
        inherit buildInputs requirements venvName pip;
        stdenv = nixpkgs.stdenv;
    };
in nixpkgs.mkShell {
    name = "${venvName}-shell";
    buildInputs = buildInputs ++ [python pip];

    shellHook = ''
        unset SOURCE_DATE_EPOCH
        export PIP_PREFIX="${venv}"
        export PATH="$PIP_PREFIX/bin:$PATH"
        export PYTHONPATH="$PIP_PREFIX/lib/python$(${python}/bin/python --version | ${nixpkgs.gnugrep}/bin/grep -o '[0-9]\\.[0-9]')/site-packages:$PYTHONPATH"
    '';
}