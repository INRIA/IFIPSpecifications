$TMPDIR='..\tmp\'
$LOGDIR='.\ifip-log'
$LOGFILE=".\ifip.log"
$ZIPFILE='.\ifip-log.zip'
$CURL='ifip-curl.exe'
$PATHCURL=".\$CURL"
$URLDEPOT='https://api.archives-ouvertes.fr/sword/inria'
$WEBCURL="https://files.inria.fr/IFIP/ifip-curl.exe"
$IFIP='ifip'
$PWD="halifip"
$OPTION1="Packaging:http://purl.org/net/sword-types/AOfr"
$OPTION2="Content-Type:text/xml"

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
# compress-archive n'est pas présent sur le pc d'estelle
#Compress-Archive -path $LOGDIR -DestinationPath $ZIPFILE
#remove-item -recurse $LOGDIR
Remove-Item $PATHCURL