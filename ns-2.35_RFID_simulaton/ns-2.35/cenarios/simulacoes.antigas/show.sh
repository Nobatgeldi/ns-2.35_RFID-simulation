rm -f *.tr
rm -f *.csv
rm -f *.nam
ns rfid.tcl $1
awk -f nodes.awk rfid.tr
