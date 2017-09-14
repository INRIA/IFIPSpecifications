#!/bin/bash
# test il y a bien un argument
if [[ $# -ne 1 ]]; then
 echo "Erreur, il faut donner un dossier en argument"
 exit
fi

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
    if ! [ -d "XMLChapterFiles" ]
    then
		mkdir XMLChapterFiles
	fi
    ListeChapter="$(find *_Chapter -type d -prune)"   # liste des repertoires sans leurs sous-repertoires
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
			cp $NomPdfReplace ../PDFFiles
			cp $NomXml $RepOuv/XMLChapterFiles
		fi
	done
	#ajout du pdf du BookFrontmatter et renommage du pdf
	if [ -f $RepOuv/BookFrontmatter/BookFrontmatter.pdf ]
	then
		cp $RepOuv/BookFrontmatter/BookFrontmatter.pdf $RepOuv/PDFFiles/$1_BookFrontmatter.pdf
		mv $RepOuv/BookFrontmatter/BookFrontmatter.pdf $RepOuv/BookFrontmatter/$1_BookFrontmatter.pdf
	else
		echo "Erreur : le fichier BookFrontmatter/BookFrontmatter.pdf n'existe pas";
	fi
	#renommage du xml du BookFrontmatter (Attention, il faut garder les deux pour l'inclusion depuis la xslt)
	if [ -f $RepOuv/BookFrontmatter/BookFrontmatter.xml ]
	then
		cp $RepOuv/BookFrontmatter/BookFrontmatter.xml $RepOuv/BookFrontmatter/$1_BookFrontmatter.xml
	else
		echo "Erreur : le fichier BookFrontmatter/BookFrontmatter.xml n'existe pas";
	fi
	
else
	echo "Erreur le dossier $1 n'existe pas";
fi
