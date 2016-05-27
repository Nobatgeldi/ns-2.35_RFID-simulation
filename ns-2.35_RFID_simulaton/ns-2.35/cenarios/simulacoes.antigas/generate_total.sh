awk -v fn=103 -f total.awk 103.suc > 103.tot
awk -v fn=303 -f total.awk 303.suc > 303.tot
awk -v fn=503 -f total.awk 503.suc > 503.tot
awk -v fn=703 -f total.awk 703.suc > 703.tot
awk -v fn=903 -f total.awk 903.suc > 903.tot
awk -v fn=1103 -f total.awk 1103.suc > 1103.tot
perl tot.pl . | sort -g > tot.$1.dat
