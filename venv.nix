{
    buildInputs,
    requirements,
    venvName,

    pip,
    stdenv
}:
stdenv.mkDerivation {
    name = venvName;
    buildInputs = buildInputs;

    builder = builtins.toFile "venv-builder.sh" ''
        source $stdenv/setup

        unset SOURCE_DATE_EPOCH
        mkdir -p $out
        PIP_PREFIX=$out ${pip}/bin/pip install -r ${requirements}
    '';
}
