# IFIPSpecifications README

This GitHub environment gathers resources related to the setting up of the IFIP digital library on the HAL publication repository

pp

For those who are not familiar with GitHub, you can learn more reading https://guides.github.com/ and https://help.github.com/.

# ifip.sh
Script qui gère, sur réception de mail, la récupération des volumes envoyé par IFIP

# ifip-upload-sword.ps1

Script powershell (windows 7/8/10) à placer dans une arborescence contenant les fichiers xml modifiés par sword.
Généralement sur les postes windows l'éxécution direct de powershell (extension ps1) n'est pas autorisé, il convient de faire un clic droit sur le ficheir puis cliquer sur *Exécuter avec PowerShell*.
Le script
- vérifie que tous les dossiers/fichiers dont il se sert n'existe pas déjà ; si une occurence est trouvé, le script se stope et affiche l'erreur
- parcourt les sous dossiers à la recherche de ficheir -sword.xml ; ces fichiers sont placés dans un dossier de travail temporaire 
- récupère un binaire *curl.exe* depuis https://files.inria.fr/IFIP/ifip-curl.exe
- envoie chaque fichier dans HAL via la commande curl adéquat
- sauve le résultat de chaque téléversement (un fichier xml) dans un sous dossier *ifip-log* 
- traite tous les fichiers résultats pour en extraire qq sections utiles pour les placer dans un fichier *ifip.log*
- compresse le dosier *ifip-log* (à utiliser pour débug si besoin)
- efface les dossiers/fichiers temporaire

# ifip_import.zip 

**obsolète** ceci était la version 1 d'un procédé pour envoyer automatiquement tous les fichiers xml modifiés par sword dans HAL

