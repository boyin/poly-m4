#!/usr/bin/perl

use Classic::Perl;
use Getopt::Std;

getopts('n:g:');

my %labels;


if ($opt_n) {
    @L = split(" ",$opt_n);
    foreach $i (@L) {
	print " .global $i\n .type $i, %function\n";
    }
}
if ($opt_g) {
    @L = split(" ",$opt_g);
    foreach $i (@L) {
	print " .globl $i\n";
    }
}

$last = ""; $lastop = ""; $lastbody="";
print " .p2align	2,,3\n .syntax		unified\n .text\n/*\n";
while (<>) {
    if (/^Disassembly of section \.text:/) {print; print "*/\n"; last;
    } else {print;
    }
}
while (<>) {
    chomp;
    #if (s/^([a-f0-9]{8}) <([A-Za-z0-9_]*)>:/$2:/g) {
    #	$labels[$1]=$2;
    #}
    s/^[a-f0-9]+ <([A-Za-z0-9_]*)>:/$1:/g;
    s/[a-f0-9]+ <([A-Za-z0-9_]*)>/$1/g;
    s/^\s*[a-f0-9]+:\s+[a-f0-9]{4}\s+[a-f0-9]{4}\s+([a-z]+(8|16)?)\s+/ $1.w /g;
    s/^\s*[a-f0-9]+:\s+[a-f0-9]{4}\s?[a-f0-9]{4}\s+/ /g;
    s/^\s*[a-f0-9]+:\s+[a-f0-9]{4}\s+([a-z]+(8|16)?)\s+/ $1.n /g;
    s/^\s*[a-f0-9]+:\s+[a-f0-9]{4}\s+/ /g;
    s/; .*$//g;
    if ($last ne "") {
	if ($lastop eq "bx") {
	    print "$last\n nop.n\n";
	    $last = ""; $lastop = ""; $lastbody="";
	} elsif (/([a-z]+(8|16)?)\.n/) {
	    print "$last\n$_\n"; 
	    $last = ""; $lastop = ""; $lastbody=""; next;
	} elsif ($lastop =~ /^it[et]{0,3}$/) {
	    print " nop.n\n$last\n";
	} else {
	    ($last =~ s/\.n/.w/);
	    print "$last\n";
	}
    }
    if (/^\s+([a-z]+(8|16)?)\.n(.*)$/) {
	$last = $_; $lastop = $1; $lastbody=$3;
    } else {
	print "$_\n"; $last=""; $lastop=""; $lastbody="";
    }
}
if ($last) {
    if ($lastop eq "bx") {
	print "$last\n nop.n\n";
    } else {
	($last =~ s/\.n/.w/);
	print "$last\n";
    }
}
