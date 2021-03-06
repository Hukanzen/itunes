#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;
use Encode;
use URI::Escape;

#=== USER variable ===#

$get_playlist="like55";
#$get_playlist="Gochiusa";

#=== To Directory ===#
$work_DIR="/home/Public/myitunes/";
$f_array=$work_DIR."log.log";
$f_error=$work_DIR."error.log";
$fname="iTunes Library.xml";
#$fname="/home/Public/iTunes/iTunes Media/iTunes Library.xml";

#=== From Directory ===#
$itunes_current="/home/Public/iTunes/";
$music_DIR=$work_DIR."myMusic/";
$video_DIR=$work_DIR."myVideo/";
$other_DIR=$work_DIR."myDocument/";

#=== USER variable ===#

#=== SYSTEM variable ===#
my @music_key;
my @music_file;
my @music_playlist;

my $check_on=1;
my $system_on=0;

my $s_goodbye=" >/dev/null 2>&1";

#=== SYSTEM variable ===#

#=== verify directory ===#
$s="ls \'".$fname."\'".$s_goodbye;
if($check_on){
	$recode=system($s);
}
if($recode){
	print "NOT FOUND $fname";
	exit 1;
}

#@s_DIR=($move_current,$music_DIR,$video_DIR,$other_DIR);
&C_DIR();

#=== verify directory ===#

#=== load iTunes Lbrary ===#
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);
#=== load iTunes Lbrary ===#

my @music_key=&sub_Key();
#print join("\n",@music_key);

my @music_file=&sub_File();
#print join("\n",@music_file);

my @music_playlist=&sub_Playlist();
#print join("\n",@music_playlist);


open(OUT,">".$f_array);
open(E_OUT,">".$f_error);
print E_OUT "Index,ERROR_Number,ERROR_File";
my $i=0;
my $En=0;
foreach my $a_trackID(@music_playlist){
	for(my $j=0;@music_key[$j];$j++){
		if($a_trackID==@music_key[$j]){

#			print @music_file[$j];
			my $file=@music_file[$j];
			my $recode=&exe_cp_cmd($file);
			print OUT $recode;
			
			if($system_on){
				#print E_OUT $recode." - ".$s."\n";
				system($recode);
				print E_OUT $En.",".$recode.","."\n";
				$En++;
			}

			last;
		}
	}
}
close(E_OUT);

close(OUT);


#=== SUB Routine ===#
sub sub_Key{
	my $i=0;
	foreach($itunes_lib->path("dict/dict/key")){
	#	print $_->value."\n";
		@music_key[$i]=$_->value;
		$i++;
	}

	return @music_key;
}

sub sub_File{
	my $i=0;
	foreach($itunes_lib->path("dict/dict/dict")){
		my @strings=$_->path("string");
		my $path="no file";
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
	return @music_file;
}

sub sub_Playlist{
	my $p_file_string=m/^file:/;

	my $p_string_vi_prev="file://localhost/G:/iTunes/";
	my $p_string_vi_next=$itunes_current;

	my @playlist_dict=$itunes_lib->path("dict/array/dict");
	foreach my $a_pl_dict(@playlist_dict){
		my @pl_dict=$a_pl_dict->path("string");
		my $srch_playlist_name;
		foreach(@pl_dict){
				
			  $srch_playlist_name=$_->value;
		}
	
	
		$srch_playlist_name=encode("utf-8",$srch_playlist_name);
	
		if($srch_playlist_name =~ /$get_playlist/){
		
	#		print OUT $srch_playlist_name."\n";
			my @trackID_dict=$a_pl_dict->path("array/dict");
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

	return @music_playlist;
}

sub C_DIR{
	my @s_DIR=($work_DIR,$music_DIR,$video_DIR,$other_DIR);

	foreach (@s_DIR){
		my $crecode=1;
		my $s_ls="ls \'".$_."\'".$s_goodbye;
	
		if($system_on){
			$recode=system($s_ls);
		}else{
			print $s_ls."\n";
		}
	
		if($crecode){
			my $s_dir="mkdir \'".$_."\'";
			if($system_on){
				system($s_dir);
			}else{
				print $s_dir."\n";
			}
		}
	}
}

sub exe_cp_cmd{
	my @music_extension=("mp3","m4a","wav","aac");
	my @video_extension=("mp4","m4v");

	my $file_name=shift(@_);
	my $exe=$file_name;
	$exe=~s!.*\.!!; #== kakuchoushi
	#print $file_name."\n";
	#print $exe."\n";

	foreach (@music_extension){
		if($exe eq $_){
			$s=sprintf("cp \"%s\" \"%s\"",$file_name,$music_DIR);
			return $s;
		}
	}

	foreach (@video_extension){
		if($exe eq $_){
			$s=sprintf("cp \"%s\" \"%s\"",$file_name,$video_DIR);
			return $s;
		}
			
	}
	return "error";

}
