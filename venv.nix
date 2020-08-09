{
    buildInputs,
    pipIndex,
    projectName,
    requirements,

    listLib,
    pip,
    stdenv
}:
let requirementsPipOpts = listLib.foldr (req: rest: " -r ${req}${rest}") "" requirements;
in stdenv.mkDerivation {
    name = "${projectName}-venv";
    buildInputs = buildInputs ++ [pip];

    builder = builtins.toFile "venv-builder.sh" ''
        source $stdenv/setup

        unset SOURCE_DATE_EPOCH
        mkdir -p $out

        PIP_PREFIX=$out pip install -i ${pipIndex} ${requirementsPipOpts}
    '';
}
