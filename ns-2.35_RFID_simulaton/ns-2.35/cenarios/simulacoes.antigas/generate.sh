awk -v fn=103 -f calculate.awk 103.suc > 103.del
awk -v fn=303 -f calculate.awk 303.suc > 303.del
awk -v fn=503 -f calculate.awk 503.suc > 503.del
awk -v fn=703 -f calculate.awk 703.suc > 703.del
awk -v fn=903 -f calculate.awk 903.suc > 903.del
awk -v fn=1103 -f calculate.awk 1103.suc > 1103.del
perl del.pl . | sort -g > del.$1.dat
