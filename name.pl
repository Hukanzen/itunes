#!/usr/bin/perl

$path_file='/home/Public/iTunes/iTunes Media/iTunes Media/Music/senya/色は匂へど散りぬるを/06 孤独月.mp3';
$path_file='/home/Public/iTunes/iTunes Media/iTunes Media/Music/Unknown Artist/Unknown Album/さユり それは小さな光のような.mp3';


$path_file=~s!^.*\/!!;
print $path_file."\n";
