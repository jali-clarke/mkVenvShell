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
        PYTHON_VERSION=python$(${pythonNix}/bin/python -c 'import sys; version = sys.version_info; print(f"{version.major}.{version.minor}")')
        SITE_PACKAGES_SUBDIR=lib/$PYTHON_VERSION/site-packages

        export PIP_PREFIX=$PWD/.mkVenvShell
        mkdir -p $PIP_PREFIX

        export PATH="$PIP_PREFIX/bin:${venv}/bin:$PATH"
        export PYTHONPATH="$PIP_PREFIX/$SITE_PACKAGES_SUBDIR:${venv}/$SITE_PACKAGES_SUBDIR:$PYTHONPATH"
    '' + "\n" + shellHook;
}
