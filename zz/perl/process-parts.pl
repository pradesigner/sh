#!/usr/bin/perl
use strict;
use warnings;

# Check if arguments are provided
if (@ARGV < 1) {
    die "Usage: $0 all | piano | voice1 [voice2 ...]\n";
}

# Get the arguments
my @argv = @ARGV;

# Define the input file
my $input_file = 's-vocal.ly';

# Read the input file
open(my $fh, '<', $input_file) or die "Could not open file '$input_file' $!";
my $content = do { local $/; <$fh> };
close($fh);

# Split the content into music and score
my ($music, $score) = split(/\\score/, $content, 2);

# Parse the score to extract voices and piano part
my %voices;
my $piano;

while ($content =~ /%% BEG (\w+) %%\n(.*?)\n%% END \1 %%/gs) {
    my $name = lc($1);  # Convert to lowercase for consistency
    my $part = $2;
    if ($name eq 'piano') {
        $piano = $part;
    } else {
        $voices{$name} = $part;
    }
}

# Process voices based on arguments
if ($argv[0] eq 'all') {
    process_all_voices();
    process_piano_only();
} elsif ($argv[0] eq 'piano') {
    process_piano_only();
} else {
    process_specific_voices(@argv);
}

lilypond_it();

sub process_all_voices {
    foreach my $voice (keys %voices) {
        generate_output($voices{$voice}, $voice);
    }
}

sub process_piano_only {
    generate_output($piano, "piano");
}

sub process_specific_voices {
    my @requested_voices = @_;
    foreach my $requested (map { lc($_) } @requested_voices) {
        if (exists $voices{$requested}) {
            generate_output($voices{$requested}, $requested);
        } else {
            warn "Warning: No voice found matching '$requested'\n";
        }
    }
}

sub generate_output {
    my ($voice_part, $name) = @_;
    
    $voice_part = "" if $name eq 'piano';

    my $score = <<EOF;
\\score {
  <<
    $voice_part
    \\new PianoStaff \\with { instrumentName = "Piano" }
    <<
      \\new Staff \\with { midiInstrument = "acoustic grand" } \\upperPiano
      \\new Staff \\with { midiInstrument = "acoustic grand" } \\lowerPiano
    >>
  >>
}
EOF

    my $output_file = "p-$name.ly";
    open(my $out, '>', $output_file) or die "Could not open file '$output_file' $!";
    print $out "$music\n$score";
    close($out);
    print "Generated file: $output_file\n";
}

sub lilypond_it {
    # Check if lilypond is available
    my $lilypond_check = `which lilypond`;
    if ($? != 0) {
        die "Error: LilyPond is not installed or not in the system PATH\n";
    }

    system("lilypond p-*.ly");
    unlink(glob("p-*.ly"));
}
