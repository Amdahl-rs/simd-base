#!/bin/bash

mkdir simdbase && cd simdbase
mkdir conf
wget 'https://github.com/Amdahl-rs/simd-base/releases/download/untagged-b16b10dd42dc2b547019/simdbase-v0.1.1-x86_64.zip'
unzip 'simdbase-v0.1.1-x86_64.zip'
 
echo '[log] 
log_dir = "/simdbase/_logs"

[query]
 num_cpus=16

[storage.disk]
type = "fs"

[storage.fs]
data_path = "/simdbase/cells"' > conf/conf.toml

#wget --continue 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz'
#gzip -d hits.tsv.gz

 ./simdbase-bin 2>&1 &
mysql -h 0.0.0.0 -P9333 < create.sql
mysql -h 0.0.0.0 -P9333 < create_csv.sql
mysql -h 0.0.0.0 -P9333 < insert.sql
./run.sh 2>&1 | tee run.log
sed -r -e 's/query[0-9]+,/[/; s/$/],/' run.log
