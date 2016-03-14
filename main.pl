#!/usr/bin/perl
use Data::Dumper;
use XML::Simple;
$xml=XML::Simple->new();

$fname="iTunes Library.xml";
print "LOAD FILE: $fname \n";

#Assignment to $xml
$xml=XMLin($fname);

#print ($xml->{dict}->{array}->{dict}[0]->{key}[5]); #Name
#print "\n";
#
#print ($xml->{dict}->{array}->{dict}[0]->{string}[1]); #Name - String
#print "\n";

print Dumper($xml->{dict}->{array}->{dict}[0]);
#print Dumper($xml->{dict}->{array}->{dict}[0]->{array});

foreach my $data ($xml->{dict}->{array}->{dict}[0]->{array}->{dict}){
	print $data->{"Track ID"}->{integer}."\n";
}


print "\n";
