#!/bin/bash
port=8980
client_num=2

while getopts "p:c:" opt
do
    case $opt in
        p)
            port=$OPTARG
        ;;
        c)
            client_num=$OPTARG
        ;;
    esac
done
cd /ppml/trusted-big-data-ml
./clean.sh
gramine-argv-serializer bash -c "/opt/jdk8/bin/java\
        -cp '/ppml/trusted-big-data-ml/work/bigdl-2.1.0-SNAPSHOT/jars/bigdl-ppml-spark_3.1.2-2.1.0-SNAPSHOT.jar:/ppml/trusted-big-data-ml/work/spark-3.1.2/jars/commons-lang3-3.10.jar:/ppml/trusted-big-data-ml/work/bigdl-2.1.0-SNAPSHOT/jars/*:/ppml/trusted-big-data-ml/work/spark-3.1.2/conf/:/ppml/trusted-big-data-ml/work/spark-3.1.2/jars/*'\
        -Xmx10g org.apache.spark.deploy.SparkSubmit\
        --master 'local[4]'\
        /ppml/trusted-big-data-ml/fl/start-fgboost-server.py --port $port --client_num $client_num" > secured_argvs
./init.sh
gramine-sgx bash 2>&1 | tee fgboost-server-sgx.log

