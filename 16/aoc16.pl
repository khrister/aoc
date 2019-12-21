#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw( pairwise );

# Other modules

# Global variables
my @input;
my @output;
my @phases;
my @origphase = (0, 1, 0, -1);
my $length;
my $max;


{
    my $fh;
    my $file = shift @ARGV;
    $max = shift @ARGV;
    chomp $max;
    open($fh, '<', $file)
        or die("Could not open $file: ");
    my $line = <$fh>;
    chomp $line;
    @input = split(//, $line);
    $length = length $line;
    @phases = calc_phases($max);
    close $fh;
}


#D(\@phases);

foreach my $p (0..($max-1))
{
    @output = ();
    #D(\@input);
    foreach my $d (0..$length-1)
    {
        my $res = 0;
        my @phase = @{$phases[$d]};
        my $len = scalar(@phase);
    I:
        foreach my $i (0..$length-1)
        {
            next I unless ($phase[$i % $len]);
            $res += $input[$i] * $phase[$i % $len];
        }
        $res = substr($res, -1);
        push(@output, $res);
    }
    #D(\@output);
    @input = @output;
}

print substr(join ("", @output), 0, 8) . "\n";

sub
calc_phases
{
    my $max = shift;
    my @res = ();

    if ($max < $length)
    {
        $max = $length;
    }
    # 0 until max gives one more than max elements, but one will be removed
    foreach my $phnum (0..($max-1))
    {
        my @phase = ();
        my $len = 4 * $phnum + 4;
    DIGIT:
        foreach my $digit (0..$len)
        {
            foreach my $t (0..$phnum)
            {
                push(@phase, $origphase[$digit % 4]);
                last DIGIT if (scalar @phase > $len);
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
