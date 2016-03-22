#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;
use Encode;
use URI::Escape;

#=== variable ===#
$p_file_string=m/^file:/;
#$p_string_vi_prev=m!file:\/\/localhost\/G:!;
#$p_string_vi_next=m!\/home\/Public!;
#$p_string_vi=s/$p_string_vi_prev/$p_string_vi_next/;
$p_string_vi=s!file://localhost/G:!/home/Public!g; # $string_visual
#=== variable ===#

#=== load iTunes Lbrary ===#
$fname="iTunes Library.xml";
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);

$f_array="array.txt";
#=== load iTunes Lbrary ===#

open(OUT,">".$f_array);

$i=0;
foreach($itunes_lib->path("dict/dict/key")){
#	print $_->value."\n";
	@music_key[$i]=$_->value;
	$i++;
}

$i=0;
foreach($itunes_lib->path("dict/dict/dict")){
	@strings=$_->path("string");
	$path="no file";
	foreach my $string(@strings){
		if($string->value =~ $p_file_string){
#			print $string->value."\n";
			$path=$string->value;
			$path=encode("utf-8",$path);
			$path=uri_unescape($path);
#			$path=~$p_string_vi;
			$path =~ s!^file://localhost!!;
			@music_file[$i]=$path;
		}
	}
	$i++;
}

$i=0;
foreach (@music_key){
	print OUT @music_key[$i]." - ".@music_file[$i]."\n";
	$i++;
}

close(OUT);
