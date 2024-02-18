#threads list in Java experiments
threads_list=[1,16,32,76]
#threads set in experiments of Figure 4k
worker_threads_4k=76
#JVM_memory
Mem="300G"
#rq_size, rq_threads and update_threads
rq_size=[8,64,256,1024,8192,65536]
rq_threads=36
up_threads=36

# Figure 4a
python3 run_java_experiments_scalability.py 100000 3-2-95-0-0 ${threads_list} graphs/figure4a.png 5 5 ${Mem}

# Figure 4b
python3 run_java_experiments_scalability.py 100000 30-20-50-0-0 ${threads_list} graphs/figure4b.png 5 5 ${Mem}

# Figure 4c
python3 run_java_experiments_scalability.py 100000 30-20-50-1-1024 ${threads_list} graphs/figure4c.png 5 5 ${Mem}

# Figure 4d
python3 run_java_experiments_scalability.py 100000000 3-2-95-0-0 ${threads_list} graphs/figure4d.png 5 5 ${Mem}

# Figure 4e
python3 run_java_experiments_scalability.py 100000000 30-20-50-0-0 ${threads_list} graphs/figure4e.png 5 5 ${Mem}

# Figure 4f
python3 run_java_experiments_scalability.py 100000000 30-20-50-1-1024 ${threads_list} graphs/figure4f.png 5 5 ${Mem}

# Figures 4g and 4h
python3 run_java_experiments_rqsize.py 100000 ${rq_threads} ${up_threads} ${rq_size} graphs/figure4g4h.png 5 5 ${Mem}

# Figures 5a and 5b
python3 run_cpp_experiments_rqsize.py 100000 ${rq_threads} ${up_threads} ${rq_size} graphs/figure5a5b.png 5 5

# Figure 4j
python3 run_java_experiments_sorted.py ${threads_list} graphs/figure4j.png 10 5 ${Mem}

# Figure 4k
python3 run_java_experiments_overhead.py ${worker_threads_4k} 100000 100000000 graphs/figure4k.png 5 5 ${Mem}

# Figure 4m
python3 run_java_experiments_multipoint.py ${rq_threads} ${up_threads} 100000000 graphs/figure4m.png 5 5 ${Mem}

# Figure 5c
python3 run_cpp_experiments_memory_usage.py 100000 ${rq_threads} ${up_threads} ${rq_size} graphs/figure5c.png 5 5

# Figure 4i
python3 run_java_experiments_memory_usage.py 100000 ${rq_threads} ${up_threads} ${rq_size} graphs/figure4i.png 5 5 ${Mem}
