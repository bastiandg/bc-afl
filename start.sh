#!/usr/bin/env bash

user="builder"
project="bc"
#git_repo="https://github.com/ellson/graphviz.git"
source_link="http://alpha.gnu.org/gnu/bc/bc-1.06.95.tar.bz2"
source_archive="/tmp/${project}.tar.bz2"
testbinary="$1"
project_dir="/home/$user/$project"
export CC="/usr/local/bin/afl-gcc"
export CXX="/usr/local/bin/afl-g++"

if [ "$(whoami)" != "$user" ] ; then
	echo "wrong user (should be $user)" >&2
	exit 2
fi

if [ -d "$project_dir" ] ; then
	cd "$project_dir"
	rm -rf *
else
	mkdir "$project_dir"
fi

wget -O "$source_archive" "$source_link"
tar xvjf "$source_archive" -C /tmp/
rm "$source_archive"
mv "/tmp/$project"*/* "$project_dir"
cd "$project_dir"

#./autogen.sh
./configure
make
#make install

cd ~

AFL_SKIP_CPUFREQ=1 afl-fuzz -i testcases/ -o output/ "$project_dir/$testbinary/$testbinary"
