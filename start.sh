#!/bin/sh
hadoop jar $HADOOP_INSTALL/contrib/streaming/hadoop-streaming-1.0.4.jar -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -D mapred.text.key.comparator.options=-n  -input Netflix/movieRatings.txt -output Netflix_movies_norm -mapper "python netflix_normalised_movies_mapper.py" -reducer "python netflix_normalised_movies_reducer.py" -file  netflix_normalised_movies_mapper.py -file netflix_normalised_movies_reducer.py


hadoop jar $HADOOP_INSTALL/contrib/streaming/hadoop-streaming-1.0.4.jar -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -D mapred.text.key.comparator.options=-n  -input Netflix_movies_norm/part-00000 -output Netflix_user_norm -mapper "python netflix_normalised_mapper.py" -reducer "python netflix_normalised_reducer_trimmed.py" -file netflix_normalised_mapper.py -file netflix_normalised_reducer_trimmed.py
