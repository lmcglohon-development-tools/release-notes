#!/bin/bash
# The base directory for the ArchivesSpace code is provided as an input to the shell script
# e.g. ~/Desktop/dirs/archivesspace
base_dir=$1
start=$2
dt=`date +%F`
loc_for_log="/Users/lyrasis/Desktop/StatisticsAndTechLeadTools/tools/release-notes/pretty_git_log_"
ext=".txt"

rm -f "$loc_for_log$dt$ext"

git -C "$base_dir" log --pretty='%cn|%cd|%s|%b' --since="$start" > "$loc_for_log$dt$ext"
