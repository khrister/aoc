#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2022

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my %visible;

my $grid;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    local $/;
    $grid = <$fh>;
    close($fh);
}

my @lines = split(/\n/, $grid);
my @columns = ("") x scalar (@lines);

for (my $iline = 0; $iline <= $#lines; $iline++)
{
    my $line = $lines[$iline];
    my @chars = split(//, $line);

    for (my $x = 0; $x < length($line); $x++)
    {
        $columns[$x] .= $chars[$x];
    }

}

for (my $iline = 0; $iline <= $#lines; $iline++)
{
    my $line = $lines[$iline];
    my $rev = reverse $line;
    my $j = length($line) - 1;
    my $xmax = -1;
    my $x0max = -1;
 X:
    for (my $x = 0; $x < length($line); $x++)
    {
        my $xcur = substr($line, $x, 1);
        if ( $xcur > $xmax)
        {
            $xmax = $xcur;
            $visible{"$x,$iline"}++;
        }
    }
 X0:
    for (my $x = $j; $x >= 0; $x--)
    {
        my $xcur = substr($line, $x, 1);
        if ($xcur > $x0max)
        {
            $x0max = $xcur;
            $visible{"$x,$iline"}++;
        }
    }

    my $ymax = -1;
    my $y0max = -1;
    my $col = $columns[$iline];
    $rev = reverse $col;
    $j = length($col) - 1;
 Y:
    for (my $y = 0; $y < length($col); $y++)
    {
        my $ycur = substr($col, $y, 1);
        if ( $ycur > $ymax)
        {
            $ymax = $ycur;
            $visible{"$iline,$y"}++;
        }
    }
 Y0:
    for (my $y = $j; $y >= 0; $y--)
    {
        my $ycur = substr($col, $y, 1);
        if ($ycur > $y0max)
        {
            $y0max = $ycur;
            $visible{"$iline,$y"}++;
        }
    }

}

my @tmp = keys %visible;
print( (scalar @tmp) . "\n");


# Debug function
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
