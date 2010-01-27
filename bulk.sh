for f in *_utf8.txt
do
    NAME=`head $f | grep ^\#name|cut -c 7-`
    CODE=`echo $NAME | sed s/[^A-Z]//g`
    rm output/*.html
    perl ub2h.pl $f en
    cd output
    zip -Xr9D ../ub-$CODE.epub mimetype *
    cd ..
done

