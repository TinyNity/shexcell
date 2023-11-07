any:
	bash main.sh -in sampleTable.txt -scin ':' -scout '\t'
gen: 
	gcc ./generateTable.c -Wall -o ./generateTable && ./generateTable && rm ./generateTable