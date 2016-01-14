aofr-sword.xsd : schéma xml pour sword fourni par le CCSD
IFIP2TEI.xsl : feuille de style à appliquer aux fichiers fournis par IFIP pour produire des fichiers xml prêts pour l'import SWORD dans HAL
ToC.xsl : Feuille de style qui permet de construire la table des matières en html à partir du résultat d'une requête Solr HAL (Ex: http://api.archives-ouvertes.fr/search/?q=collCode_s:IFIP-LNCS-6033&fl=title_s,authFullName_s,page_s,uri_s&rows=100&sort=submittedDate_tdate%20asc&wt=xml)
modif_pdf.bash : script à lancer sous Linux depuis le répertoire dézippé fourni par IFIP pour renommer les pdf
	usage : modif_pdf.bash nom_du_répertoire"
