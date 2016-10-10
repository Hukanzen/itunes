#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML qw(xml_to_object);
use Perl6::Slurp;
use Encode;
use URI::Escape;

#=== USER variable ===#
$get_playlist="AngelBeats";
#music 1
#video 2
$type=2;
$zip=0;
#on 1
#off 0

#=== To Directory ===#
$work_DIR="/home/Public/myitunes/";
$work_DIR_cname="myitunes/";
$f_array=$work_DIR."log.log";
$f_error=$work_DIR."error.log";
#$fname="iTunes Library.xml";
$fname="/home/Public/iTunes/iTunes Media/iTunes Library.xml";

#=== From Directory ===#
$itunes_current="/home/Public/iTunes/";
$myMusic="myMusic";
$myVideo="myVideo";
$other  ="m4a_file";

$music_DIR=$work_DIR.$myMusic;
$video_DIR=$work_DIR.$myVideo;
$other_DIR=$work_DIR.$other;

#=== USER variable ===#
#$dst_dir="/home/Public/Trash";
$dst_dir="/var/tmp/";

#=== SYSTEM variable ===#
my @music_key;
my @music_file;
my @music_playlist;

my $check_on=1;
my $system_on=1;

my $s_goodbye=" >/dev/null 2>&1";

#=== SYSTEM variable ===#

#=== main function ===#
#= verify iTunes Xml file =#
$s="ls \'".$fname."\'".$s_goodbye;
if($check_on){
	$recode=system($s);
}
if($recode){
	print "NOT FOUND $fname";
	exit 1;
}

#= verify directory =#
&C_DIR();

#= load iTunes Lbrary =#
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

$itunes_lib=xml_to_object($xml);
#= load iTunes Lbrary =#


#= get music ID =#
my @music_key=&sub_Key();

#= get path of music file =#
my @music_file=&sub_File();

#= get music ID of Playlist =#
my @music_playlist=&sub_Playlist();

open(OUT,">".$f_array);
open(E_OUT,">".$f_error);
print E_OUT "Index,ERROR_Number,ERROR_File";
my $i=0;
my $En=0;
foreach my $a_trackID(@music_playlist){
	for(my $j=0;@music_key[$j];$j++){
		if($a_trackID==@music_key[$j]){
			my $file=@music_file[$j];
			my $recode=&exe_cp_cmd($file);
			print OUT $recode."\n";
			
			if($system_on){
				if($recode==1){
					print E_OUT $En.",".$recode.","."\n";
					$En++;
				}else{
					system($recode);
				}
			}

			last;
		}
	}
}
close(E_OUT);

close(OUT);

&cnvrt();
#=== main function ===#

#=== SUB Routine ===#
sub sub_Key{
	my $i=0;
	foreach($itunes_lib->path("dict/dict/key")){
		@music_key[$i]=$_->value;
		$i++;
	}

	return @music_key;
}

sub sub_File{
	my $i=0;
	my $p_string_vi_prev="file://localhost/G:/iTunes/";
	my $p_string_vi_next=$itunes_current;
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
			my @trackID_dict=$a_pl_dict->path("array/dict");
			my $i=0;
			foreach my $a_trackID_dict(@trackID_dict){
				my $a_trackID=$a_trackID_dict->path("integer");
				@music_playlist[$i]=$a_trackID->value;
				$i++;
			}
			last;
		}
	}

	return @music_playlist;
}

sub C_DIR{
	my @s_DIR=($work_DIR,$music_DIR,$video_DIR,$other_DIR);
	system("rm -r ".$dst_dir.$work_DIR_cname);

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
				system("mv $_ $dst_dir");
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
	$exe=~s!.*\.!!; #== get Kakucho-shi

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
	return 1;

}

sub cnvrt{
	$gen=`pwd`;
	chdir($music_DIR);

	@file=glob "*.m4a";
	
	foreach(@file){
		my $name=$_;
		$name=~s!^.*\/!!;
		$name=~s!\..+!!;
		print $name;
		my $s1=sprintf("ffmpeg -y -i \"%s\" -ab 256k \"%s\">/dev/null 2>&1",$name.".m4a",$name.".mp3");
		system($s1);
	}
	
	foreach(@file){
		my $s=sprintf("mv \"%s\" ../m4a_file/",$_);
		system($s);
	}
	
	chdir('..');
	if($type==1){
		$dir_name=$myMusic;
	}elsif($type==2){
		$dir_name=$myVideo;
	}
	$zip_name=$get_playlist.".zip";

	system("mv $zip_name $dst_dir");
	system("mv $dir_name $get_playlist");

	if($zip){
		system("zip -r $zip_name $get_playlist");
		system("mv $get_playlist $dst_dir");
	}
	#system("mv $get_playlist $dst_dir");

	chdir $gen;
}
