{
    projectName,
    python,
    requirements,

    pipIndex ? "https://pypi.python.org/simple",
    buildInputs ? [],
    nixpkgs ? import <nixpkgs> {},
    shellHook ? ""
}:
let pythonNix = nixpkgs."${python}Full";
    pip = nixpkgs."${python}Packages".pip;

    pythonBuildPackages = with nixpkgs."${python}Packages"; [
        setuptools
    ];

    venv = import ./venv.nix {
        inherit projectName pip pipIndex requirements;
        stdenv = nixpkgs.stdenv;
        listLib = nixpkgs.lib.lists;
        buildInputs = buildInputs ++ pythonBuildPackages;
    };

    grep = nixpkgs.gnugrep;
in nixpkgs.mkShell {
    name = "${projectName}-shell";
    buildInputs = buildInputs ++ pythonBuildPackages ++ [pip pythonNix];

    shellHook = ''
        unset SOURCE_DATE_EPOCH
        export PIP_PREFIX="${venv}"
        export PATH="$PIP_PREFIX/bin:$PATH"
        export PYTHONPATH="$PIP_PREFIX/lib/python$(${pythonNix}/bin/python -c 'import sys; version = sys.version_info; print(f"{version.major}.{version.minor}")')/site-packages:$PYTHONPATH"
    '' + "\n" + shellHook;
}