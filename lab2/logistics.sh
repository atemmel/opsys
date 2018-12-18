#!/bin/bash

FILE=
COLUMN=
SEP=','
TABLE='BEGIN{printf("%3s\t%12s\t%5s\t%3s\t%3s\t%3s\n","ID","Name","Weight","L","B","H")}{printf("%3s\t%12s\t%5d\t%3d\t%3d\t%3d\n",$1,$2,$3,$4,$5,$6)}'

usage() { 
	echo "Usage: logistics  [-f {FILE} -b|-p|-s {i|n|v|l|b|h}]
Used  for  logistics  management  with  FILE as  underlying
data.
-b       generate  backup  copy of data  contents
-p       print  data  contents  and  exit
-s       sort by  additional  argument: id (i),
name (n), weight (v), length (l)
width (b), height (h), print  data
contents  and  exit" 
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
		echo "Column to sort on not recognized"
		exit 1
	fi
	
	#echo $ARGS $FILE | awk -F$SEP $TABLE
	sort $ARGS $FILE | awk -F$SEP $TABLE
}

interactive_help(){
	echo "  HELP"
	echo "f : Select file to read from"
	echo "p : Print file contents"
	echo "s : Sort file contents"
	echo "b : Backup file"
	echo "q : Quit program"
	echo "h : Show help"
}

filenotset(){
	echo "Error, file is not set. Set file with 'f'"
}

if [ -z "$1" ]; then
	interactive_help;
	while true ; do
		read input;

		case $input in
			b) 
				if [ ! -f $FILE ] ; then
					filenotset 
					continue
				fi 
				backup_table;
				echo "Backup generated"
			;;
			p) 
				if [ ! -f $FILE ] ; then
					filenotset 
					continue
				fi 
				print_table
			;;
			s)  
				if [ ! -f $FILE ] ; then
					filenotset 
					continue
				fi 
				echo "Name of column to sort on:"
				echo "i : id, n : name, v : weight, l : length, b : width, h : height"
				read COLUMN;
				sort_table
			;;
			f) 
				echo "Name of file to read:"
				read input;
				FILE="$input"
				if [ ! -f $FILE ] ; then
					echo "File $FILE not found"
				else
					echo "File set"
				fi
			;;
			h) interactive_help;;
			q) exit 0;;
			?) echo "Unrecognized command, type 'h' for help"
		esac
	done
fi


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

# Hjälptext vid varje steg i interaktivt läge
# Fil ska anges vid start av interaktivt läge
# Hårdkodad backupfil
# H ger hjälp för atcjläge
# /? skall gå att köra med fil
