{ srcDir     ? ./src
, scriptPath ? "/bin/pandocx.sh"
, scriptName ?
    with lib; removeSuffix ".sh" (last (splitString "/" (toString scriptPath)))
, docxTemplate ? ./docxTemplates
, lib
, runCommandLocal
, makeWrapper
, bash, pandoc
}:
runCommandLocal scriptName {
  nativeBuildInputs = [ makeWrapper ];
} ''
  makeWrapper ${srcDir}/bin/pandocx.sh $out/bin/${scriptName} \
    --prefix PATH : ${lib.makeBinPath [
      bash pandoc
    ]}
''
