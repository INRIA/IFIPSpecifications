$TMPDIR='..\tmp\'
$LOGDIR='.\ifip-log'
$LOGFILE=".\ifip.log"
$URLDEPOT='https://api-preprod.archives-ouvertes.fr/sword/inria'
$IFIP='ifip'
$PWD="halifip"
$OPTION1="Packaging:http://purl.org/net/sword-types/AOfr"
$OPTION2="Content-Type:text/xml"

if ( Test-Path $TMPDIR ) {
    Write-Host "ERROR : il existe un dossier $TMPDIR qui sert de dossier de travail"
    Write-Host 'ACTION : vérfier et faire le ménage à la main'
    Write-Host ''
    exit 1
}
if ( Test-Path $LOGDIR ) {
    Write-Host "ERROR : il existe un dossier $LOGDIR qui sert de dossier de traces"
    Write-Host 'ACTION : vérfier et faire le ménage à la main'
    Write-Host ''
    exit 2
}
if ( Test-Path $LOGFILE ) {
    Write-Host "ERROR : il existe un fichier $LOGFILE qui sert de fichier de traces"
    Write-Host 'ACTION : vérfier et faire le ménage à la main'
    Write-Host ''
    exit 3
}

mkdir $TMPDIR
Get-ChildItem -recurse -filter "*-Sword.xml" -file | ForEach-Object  { copy-item $_.fullname $TMPDIR }
copy-item .\ifip-curl.exe $TMPDIR
Push-Location -Path $TMPDIR
Get-ChildItem -filter "*-Sword.xml" -file | ForEach-Object  {
 Write-Host $_
 write-host '---'
 .\ifip-curl.exe -k -q -u ${IFIP}:${PWD} ${URLDEPOT} -H ${OPTION1} -X POST -H ${OPTION2} --data-binary @$_ > "$_.log.xml"
 write-host ""
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