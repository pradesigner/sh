#!/usr/bin/env perl

use strict;
use warnings;

my $input_file = "vscore.ly";
my $output_file = "s-vocal.ly";

open my $in, '<', $input_file or die "Cannot open $input_file: $!";
open my $out, '>', $output_file or die "Cannot open $output_file: $!";

my $in_score = 0;
my $in_section = 0;
my $voice_name = "";

# Function to capitalize the first letter of each word
sub capitalize {
    my $string = shift;
    return join ' ', map { ucfirst lc $_ } split /\s+/, $string;
}

while (my $line = <$in>) {
    if ($line =~ /\\score/) {
        $in_score = 1;
    }
    
    if ($in_score) {
        if ($line =~ /%% (\w+) %%$/) {
            if ($in_section) {
                print $out "%% END " . capitalize($voice_name) . " %%\n\n";
            }
            $voice_name = capitalize($1);
            print $out "%% BEG $voice_name %%\n";
            $in_section = 1;
        } elsif ($in_section && $line =~ /^\s*$/) {
            print $out "%% END " . capitalize($voice_name) . " %%\n\n";
            $in_section = 0;
        } else {
            print $out $line;
        }
    } else {
        print $out $line;
    }
}

if ($in_section) {
    print $out "%% END " . capitalize($voice_name) . " %%\n\n";
}

close $in;
close $out;

unlink glob "vscore.*" or die "Error deleting files: $!";

print "Processing complete. Output written to $output_file\n";
