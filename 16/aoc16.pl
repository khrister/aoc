#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;

# Other modules

# Global variables
my @input;
my @output;
my @phases;
my @origphase = (0, 1, 0, -1);
my $length;

{
    my $fh;
    my $file = shift @ARGV;
    open($fh, '<', $file)
        or die("Could not open $file: ");
    my $line = <$fh>;
    chomp $line;
    @input = split(//, $line);
    $length = length $line;
    @phases = calc_phases($length);
    close $fh;
}

foreach my $i (0..$length)
{
    @input = @output;
    @output = ();
    foreach my $j (0..$length)
    {
        $output[$j] = $input[$j] * $phases[$i]->[$j];
    }
}

print join ("", @output) . "\n";

sub
calc_phases
{
    my $max = shift;
    my @res = ();
    # 0 until max gives one more than max elements, but one will be removed
    foreach my $phnum (0..($max-1))
    {
        my @phase = ();
    DIGIT:
        foreach my $digit (0..$max)
        {
            foreach my $t (0..$phnum)
            {
                push(@phase, $origphase[$digit % 4]);
                last DIGIT if (scalar @phase > $max);
            }
        }
        shift @phase;
        push(@res, \@phase);
    }
    return @res;
}

# Debug printouts
sub D
{
    my $str = shift;
    print Dumper($str);
}


__END__

=head1 NAME

<application name> - one line description


=head1 VERSION

This documentation refers to <application name> version 0.0.1


=head1 USAGE


=head1 REQUIRED ARGUMENTS


=head1 OPTIONS


=head1 DESCRIPTION


=head1 DIAGNOSTICS


=head1 EXIT STATUS

=head1 CONFIGURATION


=head1 DEPENDENCIES
=head1 INCOMPATIBILITIES
=head1 BUGS AND LIMITATIONS
=head1 AUTHOR

Written by Christer Boräng (mort@chalmers.se)


=head1 LICENSE AND COPYRIGHT

Copyright Christer Boräng 2019

=cut
