#####################################################################################################################################################
### Script powershell (windows 7/8/10) à placer dans une arborescence contenant les fichiers xml modifiés par sword. 
### Généralement sur les postes windows l'éxécution direct de powershell (extension ps1) n'est pas autorisé :
### il convient de faire un clic droit sur le ficheir puis cliquer sur Exécuter avec PowerShell. 
### Le script
### 1.vérifie que tous les dossiers/fichiers dont il se sert n'existe pas déjà ; si une occurence est trouvé, le script se stope et affiche l'erreur
### 2.parcourt les sous dossiers à la recherche de ficheir -sword.xml ; ces fichiers sont placés dans un dossier de travail temporaire
### 3.récupère un binaire curl.exe depuis https://files.inria.fr/IFIP/ifip-curl.exe
### 4.envoie chaque fichier dans HAL via la commande curl adéquat
### 5.sauve le résultat de chaque téléversement (un fichier xml) dans un sous dossier ifip-log
### 6.traite tous les fichiers résultats pour en extraire qq sections utiles pour les placer dans un fichier ifip.log
### 7.compresse le dosier ifip-log (à utiliser pour débug si besoin)
### 8.efface les dossiers/fichiers temporaire
### 9.seism décembre 2016 / janvier 2017
#####################################################################################################################################################

### variables et constances
$TMPDIR='..\tmp\'
$LOGDIR='.\ifip-log'
$LOGFILE=".\ifip.log"
$ZIPFILE='.\ifip-log.zip'
$CURL='ifip-curl.exe'
$PATHCURL=".\$CURL"
$URLDEPOT='https://api-preprod.archives-ouvertes.fr/sword/inria'
$WEBCURL="https://files.inria.fr/IFIP/ifip-curl.exe"
$IFIP='ifip'
$PWD="halifip"
$OPTION1="Packaging:http://purl.org/net/sword-types/AOfr"
$OPTION2="Content-Type:text/xml"

### tests sanitaires
### provoque une erreur et la sortie du script si non satisfait
if ( Test-Path $TMPDIR ) {
    Write-Host "`nERROR : il existe un dossier $TMPDIR qui sert de dossier de travail"
    Write-Host "ACTION : effacer ou archiver ce dossier manuellement`n"
    read-host "appuyer une touche"
    exit 1
}
if ( Test-Path $LOGDIR ) {
    Write-Host "`nERROR : il existe un dossier $LOGDIR qui sert de dossier de traces"
    Write-Host "ACTION : effacer ou archiver ce dossier manuellement`n"
    read-host "appuyer une touche"
    exit 2
}
if ( Test-Path $LOGFILE ) {
    Write-Host "`nERROR : il existe un fichier $LOGFILE qui sert de fichier de traces"
    Write-Host "ACTION : effacer ou archiver ce fichier manuellement`n"
    read-host "appuyer une touche"
    exit 3
}
if ( Test-Path $ZIPFILE ) {
    Write-Host "`nERROR : il existe un fichier $ZIPFILE qui sert de fichier d'archives de traces"
    Write-Host "ACTION : effacer ou archiver ce fichier manuellement`n"
    read-host "appuyer une touche"
    exit 4
}
if (test-path $PATHCURL) {
    write-host "CURL est ici $PATHCURL"
} else {
    Invoke-WebRequest $WEBCURL -OutFile $PATHCURL
    write-host "CURL absent je le prends sur files.inria.fr/IFIP"
}

### debut de travail ; on bascule dans un dossier tmp
### on recherche les fichiers Sword.xml ; on les copie dans le dossier tmp
### on récupère une version de curl pour windows et on boucle sur tous les fichiers Sword.xml
### pour les envoyer sur hal via curl ; pour chaque occurence on affiche le nom du fichier avant la commande curl
### et donc son résultat
mkdir $TMPDIR
Get-ChildItem -recurse -filter "*-Sword.xml" -file | ForEach-Object  { copy-item $_.fullname $TMPDIR }
copy-item $CURL $TMPDIR
Push-Location -Path $TMPDIR
Get-ChildItem -filter "*-Sword.xml" -file | ForEach-Object  {
 Write-Host $_
 write-host '---'
 & $PATHCURL -k -q -u ${IFIP}:${PWD} ${URLDEPOT} -H ${OPTION1} -X POST -H ${OPTION2} --data-binary @$_ > "$_.log.xml"
 write-host ""
}

### retour dans le dossier d'origine pour créer le dossier de logs à conserver
### chaque upload via curl à créé un fichier de log format xml
### on déplace ces fichiers dans le dossier de log puis on les analyse via une boucle
### on utilise le parser xml pour ouvrir les fichiers de log
### on s'interesse à qq entrées précises seulement ; ces entrées sont copiées dans un fichier unique
### attention si l'ouverture xml échoue, on place les détails de cet échec dans le fichier unique
### sorti de boucle on nettoie le dossier pour ne conserver que les logs
pop-location
mkdir $LOGDIR
move-item $TMPDIR\*.log.xml $LOGDIR
Remove-Item -recurse $TMPDIR
push-location -path $LOGDIR
Get-ChildItem -filter "*.log.xml" -file | ForEach-Object  {
    $xml=[xml](get-content $_)
    ADD-content -path $LOGFILE -value "$_"
    if (! $xml.error ) {
        $aaa=$xml.entry.title
        $bbb=$xml.entry.id
        $ccc=$xml.entry.password
        ADD-content -path $LOGFILE -value "Titre : $aaa"
        ADD-content -path $LOGFILE -value "ID    : $bbb"
        ADD-content -path $LOGFILE -value "Pass  : $ccc"
        
    } else {
        $iii=$xml.error.title
        ADD-content -path $LOGFILE -value "Titre : $iii"
        $jjj=$xml.error.verboseDescription
        ADD-content -path $LOGFILE -value "Desc  : $jjj"
    }
    ADD-content -path $LOGFILE -value  ''
    ADD-content -path $LOGFILE -value  ''
}
pop-location
move-item $LOGDIR\$LOGFILE .\
### compress-archive n'est pas présent sur le pc d'estelle ; de fait on conserve le dossier de log intouché
#Compress-Archive -path $LOGDIR -DestinationPath $ZIPFILE
#remove-item -recurse $LOGDIR
Remove-Item $PATHCURL