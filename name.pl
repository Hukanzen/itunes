#!/usr/bin/perl

################################################
#
#	Get File Name From full Path.
#
#	This application(?) name is GFNFP !	
#
################################################

$path_file='/home/Public/iTunes/iTunes Media/iTunes Media/Music/senya/色は匂へど散りぬるを/06 孤独月.mp3';


$path_file=~s!^.*\/!!;
print $path_file."\n";
