#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;

# Other modules
use Algorithm::Combinatorics qw(combinations);
use Math::Prime::Util::GMP qw(lcm);

# Global variables
my @moons;
my @cycles = (0, 0, 0);
my @done = (0, 0, 0);
my @origstrs = (0, 0, 0);

my $file = shift @ARGV;

my $fh;
open($fh, '<', $file)
    or die("Could not open $file: ");

{
    my $i = 0;
    while (my $line =<$fh>)
    {
        my ($x, $y, $z) = $line =~ m/x=(-?\d+), ?y=(-?\d+), ?z=(-?\d+)/;
        $moons[$i] = [ $x, $y, $z, 0, 0, 0 ];
        $i++;
    }
}

# Get a string for the start position to compare to later
foreach my $axis (0..2)
{
    # Construct a string with the coords
    my $str = "";
    foreach my $ref (@moons)
    {
        $str .= $ref->[$axis] . "," . $ref->[$axis + 3];
    }
    $origstrs[$axis] = $str;
}

my @pairs = combinations([ qw(0 1 2 3) ], 2);

my $steps;
while (1)
{
    # We're done if all axes has found a cycle
    last
        if ($done[0] and $done[1] and $done[2]);

    # First change velocities
    foreach my $pair (@pairs)
    {
        my $m1 = $pair->[0];
        my $m2 = $pair->[1];

        # Get the positions of the pair of moons
        my @pos1 = @{$moons[$m1]}[0..2];
        my @pos2 = @{$moons[$m2]}[0..2];

        my $vref = pull (\@pos1, \@pos2);

        # Update velocities for first moon in pair
        foreach my $i (0..2)
        {
            $moons[$m1]->[$i+3] += $vref->[$i];
        }
        # Update velocities for second moon in pair
        foreach my $i (0..2)
        {
            $moons[$m2]->[$i+3] += $vref->[$i+3];
        }
    }

    # Now update the moons positions
    # Iterate over the moons
    foreach my $i (0..3)
    {
        # And over the axis
        foreach my $axis (0..2)
        {
            $moons[$i]->[$axis] += $moons[$i]->[$axis + 3];
        }
    }
    $steps++;

    # Construct stringvalue of x, y and z potision, and compare to start
    foreach my $axis (0..2)
    {
        next if ($done[$axis]);

        # Construct a string with the coords
        my $str = "";
        foreach my $ref (@moons)
        {
            $str .= $ref->[$axis] . "," . $ref->[$axis + 3];
        }
        if ($origstrs[$axis] eq $str)
        {
            $done[$axis] = 1;
            $cycles[$axis] = $steps;
            print "Found cycle for $axis: " . $cycles[$axis] . "\n";
        }
    }
}

my $totcycles = 1;
# Calculate the least common multiple for x, y and z
foreach my $elem (@cycles)
{
    $totcycles = lcm($totcycles, $elem);
}
print "Total cycles: $totcycles\n";

sub pull
{
    my $x = shift;
    my $y = shift;
    my ($x0, $y0, $z0) = @$x;
    my ($x1, $y1, $z1) = @$y;
    my ($xr0, $yr0, $zr0, $xr1, $yr1, $zr1);;

    # x axis
    if ($x0 == $x1)
    {
        $xr0 = 0;
        $xr1 = 0;
    }
    elsif ($x0 > $x1)
    {
        $xr0 = -1;
        $xr1 = 1;
    }
    else
    {
        $xr0 = 1;
        $xr1 = -1;
    }

    # y axis
    if ($y0 == $y1)
    {
        $yr0 = 0;
        $yr1 = 0;
    }
    elsif ($y0 > $y1)
    {
        $yr0 = -1;
        $yr1 = 1;
    }
    else
    {
        $yr0 = 1;
        $yr1 = -1;
    }

    # z axis
    if ($z0 == $z1)
    {
        $zr0 = 0;
        $zr1 = 0;
    }
    elsif ($z0 > $z1)
    {
        $zr0 = -1;
        $zr1 = 1;
    }
    else
    {
        $zr0 = 1;
        $zr1 = -1;
    }
    return [$xr0, $yr0, $zr0, $xr1, $yr1, $zr1];
}

# debugging help
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
