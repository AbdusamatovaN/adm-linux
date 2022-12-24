#!/bin/bash

function compare {
	diff_res=$(diff -s $1 $2)
	if [[ "$diff_res" =~ ^Files* ]]; then
	echo "YES"
	else
	echo "NO"
	fi
}

mkdir ~/test
cd ~/test
ls -a -p /etc > list
find /etc -type d | wc -l >> list
find /etc -type f -name ".*" | wc -l >> list
mkdir links
ln list links/list_hlink
ln list -rs links/list_slink
ls -l links/list_hlink links/list_slink list | awk '{print $9 " : " $2}'
cat list | wc -l >> links/list_hlink

compare links/list_hlink links/list_slink
mv list list1
compare links/list_hlink links/list_slink

ln links/list_hlink ~/list1
find /etc -type f -name "*.conf" > ~/list_conf
find /etc -type d -name "*.d" > ~/list_d

cat ~/list_conf > ~/list_conf_d
cat ~/list_d >> ~/list_conf_d

mkdir .sub
cp ~/list_conf_d .sub/
cp --backup=simple  ~/list_conf_d .sub/ 
ls -aR

man man > ~/man.txt
cd ~
split -b 1K ~/man.txt
mkdir ~/man.dir
mv x* man.dir
cd man.dir
cat x* > man.txt
compare man.txt ~/man.txt
cd ~

echo "Hello" > man.tmp
echo "World" >> man.tmp
cat man.txt >> man.tmp
echo "remix version" >> man.tmp
cat man.tmp > man.txt
rm man.tmp

diff -u man.txt man.dir/man.txt > man.diff
mv man.diff man.dir
cd man.dir
patch man.txt < man.diff
compare man.txt ~/man.txt
