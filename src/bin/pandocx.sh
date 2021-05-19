#!/usr/bin/env bash
defaultTemplate="base.docx"

inputFileName=`basename $1`
pushd `dirname $0` > /dev/null
scriptDir=`pwd -P`
popd > /dev/null
docxTemplates=${scriptDir%/bin}/docxTemplates

template=$2.docx
if [ ! -f $docxTemplates/$template ]; then
  template=$defaultTemplate
fi

pandoc $1 -o ${inputFileName%.*}.docx --reference-doc=$docxTemplates/$template ${@:3}
