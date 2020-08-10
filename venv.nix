{
    buildInputs,
    pipIndex,
    projectName,
    requirements,

    listLib,
    pip,
    stdenv
}:
let requirementsPipOpts = builtins.toString (map (req: "-r ${req}") requirements);
    indexOpts = "-i ${pipIndex}";
    otherPipOpts = "--no-warn-script-location --disable-pip-version-check";
    pipOpts = builtins.toString [
        otherPipOpts
        indexOpts
        requirementsPipOpts
    ];
in stdenv.mkDerivation {
    name = "${projectName}-venv";
    buildInputs = buildInputs ++ [pip];

    builder = builtins.toFile "venv-builder.sh" ''
        source $stdenv/setup

        unset SOURCE_DATE_EPOCH
        mkdir -p $out

        PIP_PREFIX=$out pip install ${pipOpts}
    '';
}
