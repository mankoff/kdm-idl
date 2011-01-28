
PRO_FILE='find_deps.pro'

rm -f $PRO_FILE
for v in `ls *.pro | grep -v vhelp`; do
	echo ".com $v" >> find_deps.pro
done

echo resolve_all >> $PRO_FILE
echo help, /source, out=out >> $PRO_FILE
echo openw, lun, '"find_deps.txt"', /get_lun, width=1000 >> $PRO_FILE
echo "for i=0, n_elements(out)-1 do printf, lun, out[i]" >> $PRO_FILE
echo free_lun, lun >> $PRO_FILE
#echo exit >> $PRO_FILE

# run IDL and the .PRO file we just created
idl -e @find_deps
cat find_deps.txt | \
	grep -v kdm-idl | grep -v idl[0-9]* | \
	cut -d"/" -f6- | \
	sort | uniq

rm find_deps.pro find_deps.txt
