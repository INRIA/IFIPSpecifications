#!/bin/bash
TMP="/tmp/msg`date +%s`"
FILES="/tmp/list`date +%N`"
DEPOT='/var/www/files.inria.fr/IFIP/New_additions'
TRAVAIL='/var/www/files.inria.fr/IFIP/data'
LOG='/var/www/files.inria.fr/IFIP/log'
TEMP='/tmp'
cat > $TMP
grep '^From:' $TMP | grep -i 'inria.fr' > /dev/null || {
    echo "RECEPTION MAIL NON INRIA `date`" >> $LOG/error.txt
    cat $TMP >> $LOG/error.txt
    exit 1
}
grep '^IFIPAICT' $TMP > $FILES
sed 's|\.zip||g' $FILES > $FILES.tmp
sed 's|=20||g' $FILES.tmp > $FILES
cd $TRAVAIL
for i in `cat $FILES` ; do
    echo "DEBUT DE TRAITEMENT $i `date`">> $LOG/$i.txt
    grep '^From:' $TMP >> $LOG/$i.txt
    [ -d $i ] && {       
        echo "FIN DE TRAITEMENT $i dossier deja traite">> $LOG/$i.txt
        continue
    }
    [ -f $DEPOT/$i.zip ] || {
        echo "FIN DE TRAITEMENT $DEPOT/$i.zip absent ">> $LOG/$i.txt
        continue
    }
    unzip $DEPOT/$i.zip >> $LOG/$i.txt
    [ -d __MACOSX ] && rm -rf __MACOSX/
    ls $i |grep Part >> $LOG/$i.txt || {
        echo "dossier sans Part ; on traite normalement">> $LOG/$i.txt
        bash $TRAVAIL/modif_pdf.bash $i
    }
    ls $i |grep Part >> $LOG/$i.txt && {
        echo "dossier avec Part XXXXX; on traite avec script specifique">> $LOG/$i.txt
        bash $TRAVAIL/modif_pdf_avec_part.bash $i
    }
    echo "FIN DE TRAITEMENT $i">> $LOG/$i.txt
done

