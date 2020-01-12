#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum/;
use List::MoreUtils 'first_index';
use Math::ConvexHull qw/convex_hull/;
use Memoize;

# Global variables
my @points = ();  # The points to check
my %areas = ();   # The areas, key is the point, value is the size of the area
my %inf = ();     # The points that has infinite areas (ie are on the edge)
my $xmax = 0;
my $ymax = 0;
my $xmin = 1e99;
my $ymin = 1e99;

memoize('distance');


{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);
    @points = map { [ split(/, ?/, $_) ] } @lines;
}

#D(\@points);
my @hull = @points;

my $hull_ref = convex_hull(\@hull);
foreach my $cref (@{$hull_ref})
{
    my $x = $cref->[0];
    my $y = $cref->[1];
    $inf{"$x,$y"} = 1;
    $xmax = $x if ($x > $xmax);
    $ymax = $y if ($y > $ymax);
    $xmin = $x if ($x < $xmin);
    $ymin = $y if ($y < $ymin);
}
@hull = @$hull_ref;

foreach my $p (@points)
{
    my ($x, $y) = @{$p};
    #next if ($inf{"$x,$y"});
    $areas{"$x,$y"} = 0;
}


#D(\@hull);
#D(\@points);
#D(\%inf);
#D(\%areas);
#print "xmax $xmax, ymax $ymax, xmin $xmin, ymin $ymin\n";

# Check edges when done to see if we need to extend in any direction

foreach my $y ($ymin .. $ymax)
{
 X:
    foreach my $x ($xmin .. $xmax)
    {
        my $closest;
        my $mindist = ($xmax + $ymax) * 2;
        my $tied = 0;
        foreach my $p (keys %areas)
        {
            my ($xp,$yp) = split(/,/, $p);
            my $tmp = distance($x, $y, $xp, $yp);
            #print "$tmp\n";
            if ($tmp < $mindist)
            {
                $tied = 0;
                $mindist = $tmp;
                $closest = $p
            }
            elsif ($tmp == $mindist)
            {
                $tied = 1;
                $closest = undef;
            }
        }
        next X unless ($closest);
        next X if ($tied);
        #print "$x,$y $closest $mindist\n";
        $areas{$closest}++
            unless($inf{$closest});
    }
}

#D(\%areas);

print "Biggest area: " . max(values(%areas)) . "\n";

#D($hull_ref);

sub distance
{
    my ($x0,$y0,$x1,$y1) = @_;
    return abs($x0-$x1) + abs($y0-$y1);
}

#debug function
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
