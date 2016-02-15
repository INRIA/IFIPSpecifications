#!/bin/bash
#récupération de tous les pdf de l'ouvrage et copie dans un répertoire PDFFiles
if [ -d $1 ]; then
	echo "Dossier : $1"
	CurRep=`pwd`;
	RepOuv="$CurRep/$1";
    cd $RepOuv;
    if ! [ -d "PDFFiles" ]
    then
		mkdir PDFFiles
	fi
    ListeChapter="$(find */*_Chapter -type d -prune)"   # liste des repertoires sans leurs sous-repertoires
	for Rep in ${ListeChapter}; do
		echo "Chapter $Rep";
		cd "$RepOuv/$Rep";
		NBXml=`find . -name "*Chapter.xml" | wc -l`; 
		if [ $NBXml != 1 ]
		then
			echo "Erreur plus de 1 fichier xml";
		else
			NomXml=`find . -name "*Chapter.xml"`;
			NomFicXml=$(basename "$NomXml")
			NomPdf=`find . -name "*.pdf"`;
			NomFicPdf=$(basename "$NomPdf")
			BaseXml=${NomFicXml%%.*};
			NomPdfReplace=$BaseXml."pdf"
			Cde="mv \"$NomFicPdf\" $NomPdfReplace"
			eval "$Cde"
			cp $NomPdfReplace $RepOuv/PDFFiles
		fi
		mv "$RepOuv/$Rep" $RepOuv
	done
	#on supprime à la fin les répertoire qui contenaient les parties et qui sont vides
	rm -rf $RepOuv/*Part
	#copie du pdf du BookFrontmatter
	cp $RepOuv/*BookFrontmatter/*.pdf $RepOuv/PDFFiles
else
	echo "Erreur le dossier $1 n'existe pas";
fi
