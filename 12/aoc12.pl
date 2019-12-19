#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;

# Other modules
use Algorithm::Combinatorics qw(combinations);

# Global variables
my @moons;

my $file = shift @ARGV;
my $steps = shift @ARGV or die "Specify number of steps";

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


my $step = 0;
while ($step < $steps)
{
    # First change velocities

    my $m = [ qw(0 1 2 3) ];
    my $iter = combinations($m, 2);
    # Iterate over all pairs of moons
    while (my $pair = $iter->next())
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

    $step++;
}

my $totalenergy;

foreach my $moon (@moons)
{
    my $pot = abs($moon->[0]) + abs($moon->[1]) + abs($moon->[2]);
    my $kin = abs($moon->[3]) + abs($moon->[4]) + abs($moon->[5]);
    $totalenergy += $pot * $kin;
}

print "Total energy: $totalenergy\n";

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
