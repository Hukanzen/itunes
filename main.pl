#!/usr/bin/perl

use Data::Dumper;
use XML::MyXML;
use Perl6::Slurp;

$fname="iTunes Library.xml";
print "LOAD FILE: $fname \n";

$xml=slurp $fname;

