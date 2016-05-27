ns rfid.tcl rfid.tr $1
tail -n 1 rfid.tr | awk '{print $17}'
