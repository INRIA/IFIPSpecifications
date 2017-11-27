#!/bin/bash
#récupération de tous les pdf de l'ouvrage et copie dans un répertoire PDFFiles
	CurRep=`pwd`;
	RepOuv="$CurRep";
    if ! [ -d "PDFFiles" ]
    then
		mkdir PDFFiles
	fi
    ListeChapter="$(find LNCS* -type d -prune)"   # liste des repertoires sans leurs sous-repertoires
	for Rep in ${ListeChapter}; do
		cd "$RepOuv/$Rep";
		NomPdf=`find . -name "*.pdf"`;
		#NomFicPdf=$(basename "$NomPdf");
		NomFicPdf=$NomPdf;
		BaseXml=${NomFicXml%%.*};
		NomPdfReplace=$Rep".pdf"
		#Cde="mv \"$NomFicPdf\" $NomPdfReplace"
		#eval "$Cde"
		cp $NomFicPdf ../PDFFiles/$NomPdfReplace
	done
