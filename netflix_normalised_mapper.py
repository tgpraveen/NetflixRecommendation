import sys

def read_input(file):
    for line in file:
        # split the line into words
        mov_id,user = line.strip().split('\t',1)
        user,avg = user.strip().split('#')
        user = eval(user)
        user.append(mov_id)
        yield user
        #print mov_id+'\t'+user

def main(separator='\t'):
	# input comes from STDIN (standard input)
	data = read_input(sys.stdin)
	for words in data:
		for word in words[:len(words)-1]:
			user_id,rating = word.split(':')
			print user_id+separator+words[len(words)-1]+':'+rating
		#print words[0] + separator + words[3]+':'+words[1]
				
		
			

if __name__ == "__main__":
    main()

