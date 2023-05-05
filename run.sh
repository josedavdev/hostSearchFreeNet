###################################################
#!/bin/bash
#read wc -l hosts.raw number
#printf "$number"

###################
# busca hosts en duckduckgo
##################
if [ -f "./hosts.raw" ] 
then
    rm ./hosts.raw
fi

read -p "Keyword?:" keyword
read -p "Nº de sitios?:" nsites
echo "Buscando Hosts....\n"
python ddg.py -n "$nsites" -o hosts.raw "$keyword"

####################
# depura http://www.
####################
#[[ -f ./hosts.lst ]] && rm hosts.lst
echo "Depurando Hosts....\n"
if [ -f "./hosts.lst" ]
then
    rm ./hosts.lst
fi


input="./hosts.raw"

while IFS=. read -r f1 f2 
do
   # display fields using f1, f2
   printf "$f2\n" >> ./hosts.lst
done <"$input"
rm ./hosts.raw
#-------------------------------------------------#
input="./hosts.lst"

echo "Depurando Hosts....\n"
while IFS=/ read -r f1 f2 
do
   # display fields using f1, f2
   printf "$f1\n" >> ./hosts2.raw
done <"$input"

cat hosts2.raw | sort | uniq > hosts2.lst
rm ./hosts2.raw
##########################
# probando host directos y con sni
##########################
read -p "Cambia a linea sin internet para probar"
pause
echo "Listo, probando hosts(SNI) en hosts1..."
bugscanner-go scan sni -f hosts.lst --threads 16 --timeout 8 --deep 5
echo "Listo, probando hosts(DIRECT) en hosts1..."
bugscanner-go scan direct -f hosts.lst -o found.lst
echo "Listo, probando hosts(SNI) en hosts2..."
bugscanner-go scan sni -f hosts2.lst --threads 16 --timeout 8 --deep 5
echo "Listo, probando hosts(DIRECT) en hosts2..."
bugscanner-go scan direct -f hosts2.lst -o found2.lst


