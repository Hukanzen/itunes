#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;

#=== variable ===#
$string_vi="s/\Qfile://lcoalhost/G:/\E/\Q/home/Public/\E/g";

$fname="iTunes Library.xml";
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);

foreach ($itunes_lib->path("dict/dict/key")){
	foreach $string ($_->path("dict/string")){
		$p_file_string="m/file:/";
		if($string->value =~ $p_file_string){
			last;	
		}
	}
	$string=~$string_vi;
	print $_->value."->".$string."\n";
	#@song[$_->value]=$;
}
