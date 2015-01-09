#! /bin/csh

#################################################################################
# Examining the root mean square fluctuation (RMSF) per residue from ptraj.    
# It can print the most statble water IDs, as well as the most unstable     
# solute residue IDs so that you can look them up in VMD.                   
#################################################################################


set file = "Per_res_rmsd.dat" # modify this to your RMSF per residue output data
set first_wat_id = 337           # modify this to the first water ID

awk '{if ($1 < '${first_wat_id}'){print $2 " " $1}}' $file | sort > solute.${file}
awk '{if ($1 > '${first_wat_id}'){print $2 " " $1}}' $file | sort > wat.${file}

echo "the most stable (rmsd < 10) water molecules are: "
awk '{if ($1 < 10){printf "%s ", $2}}' wat.${file}

echo ""

echo "the top 20 unstable residues are: "
echo `tail -20 solute.${file} | awk '{print $2}'`
