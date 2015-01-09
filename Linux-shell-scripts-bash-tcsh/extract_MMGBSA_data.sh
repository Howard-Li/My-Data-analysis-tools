#######################################################################
#  This script can extract MMGBSA vs frame from output file named     #
#  "mmgbsa.com.out", "mmgbsa.lig.out", and "mmgbsa.rec.out" (energy   #
#  output for complex, ligand and receptor, respectively.             #
#######################################################################

#! /bin/bash
 
LIST='com lig rec'

for i in $LIST ; do

grep VDWAALS mmgbsa.$i.out | awk '{print $3}' > $i.vdw
grep VDWAALS mmgbsa.$i.out | awk '{print $9}' > $i.polar
grep VDWAALS mmgbsa.$i.out | awk '{print $6}' > $i.coul
grep ESURF   mmgbsa.$i.out | awk '{print $3 * 0.00542 + 0.92}' > $i.surf

paste -d " " $i.vdw $i.polar $i.surf $i.coul | awk '{print $1 + $2 + $3 + $4}' > data.$i

rm $i.*

done

paste -d " " data.com data.lig data.rec | awk '{print $1 - $2 - $3}' > data.all

for ((j=1; j<=`wc -l data.all | awk '{print $1}'`; j+=1)) do
echo $j , >> time
done

paste -d " " time data.all > MMGBSA_vs_time

rm time data.*
