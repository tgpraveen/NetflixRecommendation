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
			user, rate = rank.split(':')
			
		#	rate = rank[len(rank)-1]
			sum=float(sum)+float(rate)
			count+=1
		avg = float(sum)/float(count)	
	#	print current_word+str(avg)										
		for rank in tmp:
			user,rate = rank.split(':')
			norm_rating = float(rate)-avg
		#	print rank[:(len(rank)-1)] + "haha" + str(norm_rating)
			rating = user+':'+str(norm_rating)
			rating = rating.strip("'")
			l.append(rating)
		
		delim='#'	
#		movieRating =[]
		movies =[]
		ratings = []
		print "%s%s" % (current_word, '|'),
		for movie_rating in l:
			movie, rating = movie_rating.split(':')
			movies.append(movie)
			ratings.append(rating)
#			movRatingWithTab = movie + ':' + rating 
#			movieRating.append(movRatingWithTab)
		print ' '.join(movies)+'|'+' '.join(ratings)
		#print '\n'		
#		print "%s%s%s%s%s" % (current_word, separator,l,delim ,avg)
#		print current_word +separator+str(l)

if __name__ == "__main__":
    main()

