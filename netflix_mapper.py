import sys

def read_input(file):
    for line in file:
        # split the line into words
        yield line.strip().split(',')

def main(separator='\t'):
	# input comes from STDIN (standard input)
	data = read_input(sys.stdin)
#	print data.next()
	for words in data:
#		print words
		if len(words) > 1:
			print words[0] + separator + words[3]+':'+words[1]
				
		
			

if __name__ == "__main__":
    main()
