#! /bin/tcsh

##############################################################################################################
# this script loads the umbrella output files recording the reaction coordinate 
# values, and generate the histogram data. 
#
# Usage: script_name umbrella_output_prefix histogram_data_file_name start_value end_value interval cutoff. 
# 
# For example, I name this script "1d-histogram.sh", and the name of my umbrella outputfiles 
# begin with "USout",the restraint scale of my rxn coordinate is 1 to 20, and I want the interval 
# of each data point in the histogram to be 0.05, and the cutoff to be 2 (the cutoff should usually
# be several times bigger than the US window size), I can type: 1d-histogram.sh USout histogram.dat 1 20 0.05 2
###############################################################################################################


if ($#argv != 6) then
echo "usage: 1d-histogram.sh input_prefix output_name start_value end_value interval cutoff"
echo "exit !"
exit 0
endif
 

foreach file (`ls ${1}*`)
rm temp.freq.dat
rm temp.x.dat
sed '1,2d' $file | awk '{print $2}' > temp.1.dat
set i = `tail -1 temp.1.dat | awk '{if($1-'"$6"'<'"$3"'){print '"$3"'}else{print $1-'"$6"'}}'`
set cut = `echo "scale=2;(${i}+2*${6})/1.00" | bc`
while (`echo "scale=0;(${i}-(${cut}))/1" | bc` <= 0 && `echo "scale=0;(${i}-(${4}))/1" | bc` <= 0)
set j = `echo "scale=2;${i}+${5}" | bc`
cat temp.1.dat | awk '{if ($1>='"$i"' && $1<'"$j"') {print $0}}' | wc -l >> temp.freq.dat
echo `echo "scale=2;(${5}+2*${i})/2.00" | bc` >> temp.x.dat
set i = $j
end
paste -d " " temp.x.dat temp.freq.dat > temp.${file}.temp
echo "$file done, processing next..."
end

echo "#! /usr/bin/tcsh" > temp.sh
echo -n "paste -d '\\t' " >> temp.sh
echo -n `wl temp.*.temp | sort -nr | sed '1d' |awk '{print $2}'` >> temp.sh
echo " > $2" >> temp.sh
tcsh temp.sh

echo "done."

rm temp.*.temp
rm temp.freq.dat
rm temp.x.dat
rm temp.sh
