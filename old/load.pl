#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;
use Encode;
use URI::Escape;

$fname="iTunes Library.xml";
$fary_data="array.dat";

#=== load iTunes Lbrary ===#
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);
#=== load iTunes Lbrary ===#

$i=0;
foreach($itunes_lib->path("dict/dict/key")){
	@music_key[$i]=$_->value;
	$i++;
}

$i=0;
foreach($itunes_lib->path("dict/dict/dict")){
	@strings=$_->path("string");
	$path="no file";
	foreach my $string(@strings){
		if($string->value =~ $p_file_string){
			$path=$string->value;

			$path=encode("utf-8",$path);
			$path=uri_unescape($path);
			$path=~s/$p_string_vi_prev/$p_string_vi_next/g;

		}
		@music_file[$i]=$path;
	}
	$i++;
}

open(OUT,">".$fary_data);
for(my $i=0;@music_file[$i];$i++){
	print OUT @music_key[$i]." ".@music_file[$i]."\n";
}
close($fary_data);
