from itertools import groupby
from operator import itemgetter
import sys

def read_mapper_output(file, separator='\t'):
    for line in file:
        yield line.rstrip().split(separator, 1)

def main(separator='\t'):
    # input comes from STDIN (standard input)
	data = read_mapper_output(sys.stdin, separator=separator)
	for current_word, group in groupby(data, itemgetter(0)):
		l=[]
		sum=0
		count=0
		tmp =[]
		for current_word, rank in group:
			tmp.append(rank)
			rate = rank[len(rank)-1]
			sum+=int(rate)
			count+=1
		avg = float(sum)/float(count)	
		#print tmp											
		for rank in tmp:
			norm_rating = float(rank[len(rank)-1])-avg
		#	print rank[:(len(rank)-1)] + "haha" + str(norm_rating)
			rating = rank[:(len(rank)-1)]+str(norm_rating)
			l.append(rating)
		
		delim='#'	
		print "%s%s%s%s%s" % (current_word, separator,l,delim ,avg)
#		print current_word +separator+str(l)

if __name__ == "__main__":
    main()

