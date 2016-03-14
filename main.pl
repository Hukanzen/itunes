#!/usr/bin/perl

use XML::Simple;
$xml=XML::Simple->new();

$fname="iTunes Library.xml";
print "LOAD FILE: $fname \n";

#Assignment to $xml
$xml=XMLin($fname);

print ($xml->{dict}->{array}->{dict}[0]->{key}[6]]); #Name
print ($xml->{dict}->{array}->{dict}[0]->{String}[2]]); #Name - String
