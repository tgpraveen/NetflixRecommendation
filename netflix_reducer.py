from itertools import groupby
from operator import itemgetter
import sys

def read_mapper_output(file, separator='\t'):
    for line in file:
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):
    # input comes from STDIN (standard input)
	data = read_mapper_output(sys.stdin, separator=separator) 
	print "hello" 
	for current_word, group in groupby(data, itemgetter(0)):
#		print current_word
		l=[]
#		for c in group:
#			l.append(c)
		for current_word, rank in group:
			l.append(rank)
			
		print "%s%s%s" % (current_word, separator, l)
#		print current_word +separator+str(l)

if __name__ == "__main__":
    main()
