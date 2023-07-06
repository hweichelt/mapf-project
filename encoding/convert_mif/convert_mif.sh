if [ $# -eq 0 ]
	then
		echo "ERROR: no mif file specified"
		exit 0
fi

ENCSPDIR="$(dirname "$(realpath "$0")")"

clingo --out-atomf=%s. --out-ifs="\n" -q1 --outf=2 --warn=no-atom-undefined $ENCSPDIR/mif_to_asprilo.lp $1 | \
python3 $ENCSPDIR/clingo_json_parser.py
