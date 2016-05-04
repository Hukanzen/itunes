#!/usr/bin/perl

################################################
#
#	Get File Name From full Path.
#
#	This application(?) name is GFNFP !	
#
################################################

$path_file='/home/Public/iTunes/iTunes Media/iTunes Media/Music/senya/色は匂へど散りぬるを/06 孤独月.mp3';
$path_file2=$path_file;
$path_file3=$path_file;

# get file name.
$path_file=~s!^.*\/!!;
$path_file=~s!\..+!!;
print $path_file."\n";

#get file kakuchoushi
$path_file2=~s!.*\.!!;
print $path_file2."\n";

$path_file3=~s!^(.|\s)*\/!!;
print $path_file3."\n";

