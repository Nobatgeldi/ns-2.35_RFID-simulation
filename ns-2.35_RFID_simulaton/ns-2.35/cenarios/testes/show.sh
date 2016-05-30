rm -f *.tr
rm -f *.csv
rm -f *.nam
ns rfid.tcl $1 $2 rfid.tr 5
awk -f nodes.awk rfid.tr
