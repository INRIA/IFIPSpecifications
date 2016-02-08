aofr-sword.xsd : schéma xml pour sword fourni par le CCSD
IFIP2TEI.xsl : feuille de style à appliquer aux fichiers fournis par IFIP pour produire des fichiers xml prêts pour l'import SWORD dans HAL
IFIP2TEI_embargo.xsl : idem mais avec un embargo jusqu'au 01/01/2017
CountryCode.xml : Reference table for country codes (ISO 3166 a2 and a3)
ToC.xsl : Feuille de style qui permet de construire la table des matières en html à partir du résultat d'une requête Solr HAL (Ex: http://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-LNCS-6033&fl=title_s,authFullName_s,page_s,uri_s&rows=100&wt=xml)
modif_pdf.bash : script à lancer sous Linux depuis le répertoire dézippé fourni par IFIP pour renommer les pdf
	usage : bash modif_pdf.bash nom_du_répertoire"
modif_pdf_avec_part.bash : script à lancer s'il y a des partie (dans ce cas, il y a un dossier par partie et les chapters sont mis dans les parties
	usage : bash modif_pdf_avec_part.bash nom_du_répertoire"

