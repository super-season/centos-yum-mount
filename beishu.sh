#!/bin/bash
#统计100以内含有7或者7的个数
seq 100 | awk '$NF~/7/||$NF%7==0{print $NF}'
