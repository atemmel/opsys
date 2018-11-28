#!/bin/bash

FILE=
COLUMN=
SEP=','
TABLE='BEGIN{printf("%3s\t%12s\t%5s\t%3s\t%3s\t%3s\n","ID","Name","Weight","L","B","H")}{printf("%3s\t%12s\t%5d\t%3d\t%3d\t%3d\n",$1,$2,$3,$4,$5,$6)}'

usage() { 
	echo "Här är hjälptext." 
}

check_file() {
	if [ -z $FILE ] ; then
		echo "Error: -f flag was not set. Please specify a file to operate on."
		exit 1
	fi
}

backup_table() {
	check_file;
	cp $FILE $FILE.backup
}

print_table() {
	check_file;
	awk -F$SEP $TABLE $FILE 
}

sort_table() {
	check_file;

	ARGS=
	case $COLUMN in
		i) ARGS="-g   -t$SEP";;
		n) ARGS="-k2  -t$SEP";;
		v) ARGS="-gk3 -t$SEP";;
		l) ARGS="-gk4 -t$SEP";;
		b) ARGS="-gk5 -t$SEP";;
		h) ARGS="-gk6 -t$SEP";;
	esac

	if [ -z "$ARGS" ] ; then
		echo "Ajsing bajsing"
		exit 1
	fi
	
	#echo $ARGS $FILE | awk -F$SEP $TABLE
	sort $ARGS $FILE | awk -F$SEP $TABLE
}

while getopts "hbps:f:" o; do

	case $o in
		b) backup_table; 
			exit;;
		p) print_table; exit;;
		s) COLUMN=$OPTARG; 
			sort_table; 
			exit;;
		f) FILE=$OPTARG;;

		h) ;;&
		?) usage; 
			exit;;
	esac
	
done

