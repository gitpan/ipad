#!/bin/perl -w

# --- READ CSV ---
open MARGIN, "margin.csv" or die "open margin.csv: $!";
while(<MARGIN>) {
	chop;
	($prod, $margin, $notes) = split /,/;
    $prod_margin{$prod} = $margin;
    $prod_notes{ $prod} = $notes;
	#warn "$prod = $margin\n";
}

# --- DEFINE THE OUTPUT FORMAT ---
format STDOUT_TOP =
Code   Price    Notes
----   ------   --------
.
format STDOUT =
@>>>   ^>>>>>   ^<<<<<<<<<<<<<<<<<<<<<<<<<<
$prod, $cost, $note
~~              ^<<<<<<<<<<<<<<<<<<<<<<<<<<              
$note
.

# --- GENERATE THE NEW REPORT ---
open COST, "cost.txt" or die "open cost.txt: $!";
while($line = <COST>) {
	next unless $line =~ m/^\d/;
	($prod, $cost) = unpack 'A4 @20 A7', $line;
	$cost *= $prod_margin{$prod} || 1.10;
	$note = $prod_notes{$prod} || '';
	write;
}

