一、运行环境

1.硬件环境
	具有至少192GB内存的现代多核计算机（在我们的实验部分，发现某些实验运行时所占用的内存大小接近150GB）
	在复现原论文中图4i和5a、b、c的结果时，请尽量使用至少具有72逻辑核心数的CPU，否则VcasBST、VcasBST-64、VcasBST-64、BST和EpochBST算法的内存使用量与原文结果相比将增加几倍。
	本文所用的环境为alibaba提供的ecs.hfg6.20xlarge实例（配置为80个逻辑核心与384GB内存）
2.软件环境
	编译：g++ 9.3.0 与OpenJDK 11.0.9.1
	操作系统：Ubuntu 20.04.6
	其他软件：jemalloc 5.2.1（用于C++实施部分时的可伸缩内存分配），集成mathplotlib的Python3（用于运行试验、测试脚本及相关图表绘制），numactl工具（为了防止 CPU 资源争抢引发性能降低的问题）
	实验时间：大约20小时。
	
二、代码运行
1.准备工作
（1）安装g++-9
	sudo apt-get install -y g++-9
（2）安装OpenJDK 11.0.9.1
	sudo apt-get install -y openjdk-11-jdk
（3）安装python3-mathplotlib
	sudo apt-get install -y python3-matplotlib
（4）安装Linux numactl工具
	sudo apt-get install -y numactl
（5）安装jemalloc 5.2.1：
	下载jemalloc压缩包：
	 wget https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2
	 随后解压jemalloc-5.2.1.tar.bz2：
	 tar -jxvf jemalloc-5.2.1.tar.bz2
	 在解压后的根目录下按顺序运行以下命令:
	 bash configure
	 make
	 make install
2.运行			
（1）进入项目主目录（/vcaslib/artifact）

（2）编译C++与Java实现的代码：运行脚本文件compile_all.sh
	 bash compile_all.sh

（3）经过编译后，运行run_all_tests.sh脚本进行软件测试：
	 bash run_all_tests.sh
	 你可以在expected_output目录下查看编译结果及测试结果。

额外说明：
**具体来说，run_all_tests可以快捷启动Java与C++实验部分的测试。**
**对于Java实施测试部分（run_all_tests.sh中3到5行）**
**调用javas/build/lib目录下的jar包scala-library与deuceAgent参与软件测试过程。**
**详细的测试调用过程可以参见目录java下的run-tests文件，文件中70行至150行，展现了Java实现下调用文中各类算法进行测试，并评估Java实施部分性能的模块。**
**对于C++实施测试部分（run_all_tests.sh中9到18行）**
**分别评估C++环境下实现的Vcasbst、Epochbst及Bst算法的性能表现。**
**在cpp/microbench目录下的run-experiment及run-experiment-memory文件中展示了进行C++算法测试时所调用的不同变量及它们之间的不同参数组合。**

（4）复现实验结果
	  我们汇总了实验中的一些超参数，它们可以在generate_graphs_from_paper.sh文件找到，这是一个可以快速启动并复现论文中所有实验的脚本，根据当前的服务器状况修改在复现实验时使用到的部分参数：
	  在脚本文件中，是一系列python命令行代码，用以快捷开启实验。使用到的自定义参数包括：
          Mem：进行Java实验时设置的JVM内存大小，由使用的计算机硬件状态决定，如我们在复现时所用云服务器运行内存为384GB，在此处将Java的堆大小设置为300G，建议设置地尽量高，因为我们在复现时发现，某些实验中将使用高达150G的主内存。）
	  worker_threads_4k：复现图4k中实验时所设置的工作线程数，我们在复现时设置为76。具体来讲，根据计算机cpu逻辑核心数进行设置。
	  thread_list：进行Java_scalability实验部分时使用到的线程数列表参数，根据所用的计算机CPU逻辑核心数来进行确定，我们在进行实验时所用服务器实例的CPU逻辑核心数为80，在此设置为[1,16,32,76]，代表分别在thread为1、16、32、76的情况下进行实验。值得注意的是，在进行参数设置时，请确保传入的列表字符串不包含空格，如[1,16,32,76]
	  rqsize：范围查询大小，默认设置为[8,64,256,1024,8192,65536]。
	  update_threads：更新线程数，每个线程执行50%的插入或50%的删除，默认设置为36。
	  rq_threads：范围查询线程数量，默认设置为36。
	  此外，亦有一些传入命令行的其他参数可以依照以下给出的实例自行传入修改：
	  num_repeats：在Java实验部分的benchmarks中，每个实验重复（num_repeats x 2）次，其中前半部分用于JVM热身。
	  run_time：运行时间，以秒为计量单位。
	  ins-del-find-rq-rqsize：workload设置，我们在复现所有对照实验时均与原论文保持一致。
	  num_keys：它是用于预填充数据结构的键数，目的是为了使数据结构的大小在整个实验过程中保持稳定，具体可以参见论文中的详细描述。
	  可以参考下方命令行实例：
	  **python3 run_java_experiments_scalability.py [num_keys] [ins-del-find-rq-rqsize] [thread_list] [outputfile] [num_repeats] [runtime] [JVM memory size]** （复现图4f中的实验）
	  **python3 run_java_experiments_scalability.py 100000        30-20-49-1-1024          [1,4,16]     graph1.png       5                       5              300G** 

（5）在运行前，请依据您使用计算机的cpu核心数、主内存大小修改Mem、threads_list及worker_threads_4k。
	 然后运行脚本文件generate_graphs_from_paper.sh以复现论文中所有实验结果并绘制相应图表输出：
	 bash generate_graphs_from_paper.sh
	 图表输出结果应当在项目的graphs目录下。

三、项目清单
1.对于某些数据结构，脚本/代码或图表结果可视化会使用不同的名称。下面提供了一个简单的对照表
| Paper         | Scripts/Code              | 
| ------------- |:-------------------------:| 
| CT-64         | ChromaticBatchBST64       | 
| VcasCT-64     | VcasChromaticBatchBSTGC64 | 
| PNB-BST       | BPBST64                   | 
| BST-64        | BatchBST64                | 
| VcasBST-64    | VcasBatchBSTGC64          | 
| KST           | KSTRQ                     | 
| VcasBST       | vcasbst                   | 
| BST           | bst.rq_unsafe             | 
| EpochBST      | bst.rq_lockfree           | 
2.C++与Java实施部分的benchmark源码
（1）Java Benchmark框架：
	位置：'''java/src/main/Main.java'''
	说明：用于并行数据结构吞吐量实验的Java测试工具，可以查看文件中47-600行的工具类获得更多细节。
（2）C++ Benchmark框架：
	位置：'''cpp/microbench/main.cpp'''
	说明：利用基于轮次的回收实现高效的范围查询，同时向并发数据结构添加范围查询操作。详细细节可以参考文件中(65-491行的main_globals_t结构体定义过程，及定义的所有thread相关函数)
3.使用到的算法源码
（1）BST与EpochBST（在C++实验中）
	位置：-'''cpp/bst/bst_h.h'''	 （结构定义）
		  -'''cpp/bst/bst_impl.h'''  （基础代码实现）
		  -'''cpp/rq_lockfree.h''' （EpochBST算法查询实现，参考65-170行了解基本实现）
		  -'''cpp/rq_unsafe.h'''   （BST算法查询实现，参考23-164行了解更多细节）
（2）VcasBST（在C++实验中）
	位置：-'''cpp/bst/vcas_bst.h'''    （结构定义）
		  -'''cpp/bst/vcas_bst_impl.h'''   （基础代码实现）
	  	  -'''cpp/bst/vcas_node.h'''   (文件19-61行为vcas_bst_ns的namespace定义)
		  -'''cpp/bst/vcas_scxrecord.h''' （vcas_bst的namespace定义，参考文件16-160行）
		  -'''cpp/rq/rq_vcas.h'''	   （VcasBST算法范围查询实现，参考RQProvider类(26-180行)）
（3）VcasBST-64（在Java实验中）
	位置：-'''java/src/algorithms/vcas/Camera.java''' （论文中描述的camera对象的实现，具体参见文件30-83行的camera类）
		  -'''java/src/algorithms/vcas/VcasBatchBSTMapGC.java'''  （VcasBST-64算法，具体参考文件中的VcasBatchBSTMapGC类(45-365行)）
（4）VcasCT-64（在Java实验中）
	位置：-'''java/src/algorithms/vcas/Camera.java'''  （camera对象）
		  -'''java/src/algorithms/vcas/VcasBatchChromaticMapGC.java'''	（VcasCT-64算法，参考VcasBatchChromaticMapGC类(文件中49-196行)）
（5）BST-64（在Java实验中）
	位置：-'''java/src/algorithms/efrbbst/LockFreeBatchBSTMap.java'''	（论文中提及的BST-64算法，具体可参考LockFreeBatchBSTMa类(37-275行)）
（6）CT-64（在Java实验中）
	位置：-'''java/src/algorithms/chromatic/LockFreeBatchChromaticMap.java'''	（CT-64算法实现，具体参考文件中的LockFreeBatchChromaticMap类）
（7）PNB-BST（在Java实验中）
	位置：-'''java/src/main/algorithms/pnbbst/LockFreePBSTMap.java''' （PNB-BST算法实现，具体可见LockFreePBSTMap类(32-283行)）
（8）LFCA（在Java实验中）
	位置：-'''java/src/main/algorithms/lfca'''	（LFCA算法，来自https://github.com/kjellwinblad/JavaRQBench）
（9）snaptree（在Java实验中）
	位置：-'''java/src/main/algorithms/snaptree'''	（snaptree算法，参考目录下SnapTreeMap文件）
（10）KIWI（在Java实验中）
	位置：-'''java/src/main/algorithms/kiwi'''	（KIWI算法，来自https://github.com/sdimbsn/KiWi）
（11）KST（在Java实验中）
	位置：-'''java/src/main/algorithms/kstrq/LockFreeKSTRQ.java'''	（KST范围查询，参考文件中的LockFreeKSTRQ类(31-268行)）
（12）EBR（在Java实验中）
	位置：-'''java/src/main/support/Epoch.java'''		（基于Epoch的内存回收，参考Epoch、retire、tryAdvanceEpoch等class定于(25-111行)）
4.脚本运行文件
	位置：-'''compile_all.sh'''	（快速编译所有Java、C++代码的shell脚本）
		  -'''run_all_tests.sh'''	（快速启动Java与C++实验测试的shell脚本）
		  -'''generate_graphs_from_paper'''	（快速启动实验的shell脚本）
	以下是启动原论文中图表结果对应实验的Python脚本：
	位置：-'''run_java_experiments_scalability.py'''	
		  -'''run_java_experiments_rqsize.py'''	
		  -'''run_java_experiments_sorted.py'''	
		  -'''run_java_experiments_overhead.py'''	
		  -'''run_java_experiments_multipoint.py'''	
		  -'''run_java_experiments_memory_usage.py'''	
		  -'''run_cpp_experiments_rqsize.py'''	
		  -'''run_cpp_experiments_memory_usage.py'''
5.数据结果可视化
	位置：-'''java/create_graphs.py'''	（Java实验绘图Python代码）
		  -'''cpp/microbench/graphs.py'''	（C++实验绘图Python代码）
