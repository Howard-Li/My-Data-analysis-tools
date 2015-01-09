#! /bin/tcsh

#################################################################################
# this script can modify the pointers in your prmtop so that all the solute  
# molecules are in 1 "molecule".
# usage: modify.prmtop.1.solute.sh prmtop_to_be_modified.parm
# the output modified topology file will have a prefix "modified.".
# works right only when the solvent molecule has 3 atoms (e.g. water).
#  -- Haoquan 2013-4-17
################################################################################

if ($#argv != 1) then
echo "usage: modify.prmtop.1.solute.sh prmtop_to_be_modified.parm"
exit 1
endif

set l1 = `awk '/SOLVENT_POINTERS/ {print NR}' $1`
set l2 = `awk '/BOX_DIMENSIONS/ {print NR}' $1`
set sum = `awk 'NR=="'$l1'"+2 {rdc=$3}; NR=="'$l1'"+5 {sum=0;for (i=1;i<rdc;i++)sum+=$i;{print sum}}' $1`

awk 'NR<="'$l1'"+1 {print $0}; NR=="'$l1'"+2 {printf "%8i%8i%8i\n",$1,$2-$3+2,2}; NR=="'$l1'"+3||NR=="'$l1'"+4 {print $0}' $1 > modified.$1

awk 'NR=="'$l1'"+2 {for (i=1;i<$2-$3+2;i++) if (i==1) {printf "%8i","'$sum'"} else if (i%10==0){printf "%8i\n",3} else {printf "%8i",3}; {printf "%8i\n",3}}; NR>="'$l2'"+0 {print $0}' $1 >> modified.$1

echo "created: modified.$1"
