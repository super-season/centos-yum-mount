#!/bin/bash
sed -rn '/bash$/s/:.*//p' /etc/passwd > user.txt
for name in `cat user.txt`
do
  p=`sed -rn "s/${name}:([^:]*):.*/\1/p" /etc/shadow`
 echo "${name} --> ${p}"
done
