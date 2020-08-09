{
    buildInputs,
    requirements,
    projectName,

    pip,
    stdenv
}:
stdenv.mkDerivation {
    name = "${projectName}-venv";
    buildInputs = buildInputs;

    inherit pip requirements;
    builder = builtins.toFile "venv-builder.sh" ''
        source $stdenv/setup

        unset SOURCE_DATE_EPOCH
        mkdir -p $out
        PIP_PREFIX=$out $pip/bin/pip install -r $requirements
    '';
}
