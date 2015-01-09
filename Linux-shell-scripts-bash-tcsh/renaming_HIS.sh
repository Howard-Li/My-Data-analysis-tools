###########################################################################################
# This script can rename the HIS to HIE/HIP/HID (otherwise there would                    #
# be errors when using tleap). It is suitable for pdb files re-edited from molprobity.    #
# Usage: renaming_HIS.sh old.pdb new.pdb                                                  #
###########################################################################################

#! /bin/csh
#Usage: csh HISrename.csh old.pdb new.pdb
set i = 1
set j = 1
while ($i <= `wc -l $1 | awk '{print $1}'`)

 head -$i $1 | tail -1 >> temp.$j
 
 if (`tail -1 temp.$j | awk '{print $1}'` == "TER") then
 
 set x = 1
 while ($x <= `tail -2 temp.$j | awk '{print $6}'`)
  cat temp.$j | awk '{if($6=='$x')print}' >> $2
   if (`grep "HIS" $2 | wc -l` == 18) then
    sed -i 's/HIS/HIP/g' $2
   else if (`grep "HIS" $2 | grep "HD1" | wc -l` == 1) then
    sed -i 's/HIS/HID/g' $2
   else if (`grep "HIS" $2 | grep "HE2" | wc -l` == 1) then
    sed -i 's/HIS/HIE/g' $2
   endif
  @ x++
 end
 
 echo TER >> $2
 rm temp.$j
 @ j++
 @ i++
 
 else
 @ i++
 
 endif

end

rm temp.$j
echo END >> $2
