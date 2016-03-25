#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;
use Encode;
use URI::Escape;

#=== variable ===#
$s_goodbye=" >/dev/null 2>&1";

$f_array="log.log";
$f_error="error.log";
#$fname="iTunes Library.xml";
$fname="/home/Public/iTunes/iTunes Media/iTunes Library.xml";

$move_current="/home/Public/myMusic/";

$p_file_string=m/^file:/;

$p_string_vi_prev="file://localhost/G:";
$p_string_vi_next="/home/Public";

$get_playlist="like55";
#=== variable ===#

#=== verify directory ===#
$s="ls \'".$fname."\'".$s_goodbye;
$recode=system($s);
if($recode){
	print "NOT FOUND $fname";
	exit 1;
}

$s="ls \'".$move_current."\'".$s_goodbye;
$recode=system($s);
if($recode){
	$s="mkdir \'".$move_current."\'";
	system($s);
}

#=== verify directory ===#

#=== load iTunes Lbrary ===#
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);
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
			$path=$string->value;

			$path=encode("utf-8",$path);
			$path=uri_unescape($path);
			$path=~s/$p_string_vi_prev/$p_string_vi_next/g;

		}
		@music_file[$i]=$path;
	}
	$i++;
}

@playlist_dict=$itunes_lib->path("dict/array/dict");
foreach my $a_pl_dict(@playlist_dict){
	my @pl_dict=$a_pl_dict->path("string");
	foreach(@pl_dict){
			
		 $srch_playlist_name=$_->value;
	}


	$srch_playlist_name=encode("utf-8",$srch_playlist_name);

	if($srch_playlist_name =~ /$get_playlist/){
	
#		print OUT $srch_playlist_name."\n";
		@trackID_dict=$a_pl_dict->path("array/dict");
		$i=0;
		foreach my $a_trackID_dict(@trackID_dict){
			my $a_trackID=$a_trackID_dict->path("integer");
			@music_playlist[$i]=$a_trackID->value;
#			print OUT @music_playlist[$i]."\n";
			$i++;
		}
		last;
	}
}

open(E_OUT,">".$f_error);
$i=0;
foreach my $a_trackID(@music_playlist){
	for($j=0;@music_key;$j++){
		if($a_trackID==@music_key[$j]){
#			print OUT $a_trackID."-".@music_file[$j]."\n";
			$s=sprintf("cp \"%s\" \"%s\"",@music_file[$j],$move_current);
			$file_path=@music_file[$j];
			$file_path=~s!^(.|\s)*\/!!;
			print $file_path."\n";
			print OUT $s."\n";
			
			$recode=0;
			$recode=system($s);
			if($recode){
				print E_OUT $recode." - ".$s."\n";
			}

			last;
		}
	}
}
close(E_OUT);

close(OUT);
