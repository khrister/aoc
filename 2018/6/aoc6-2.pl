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
my $xmax = 0;
my $ymax = 0;
my $xmin = 1e99;
my $ymin = 1e99;
my @region = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);
    @points = map { $_ =~ s/ //; $_; } @lines;
}

#D(\@points);

foreach my $p (@points)
{
    my ($x, $y) = split(/,/, $p);
    $xmax = $x if ($x > $xmax);
    $ymax = $y if ($y > $ymax);
    $xmin = $x if ($x < $xmin);
    $ymin = $y if ($y < $ymin);
    $areas{"$x,$y"} = 0;
}

#D(\%areas);

foreach my $y ($ymin .. $ymax)
{
 X:
    foreach my $x ($xmin .. $xmax)
    {
        my $dist = 0;
        foreach my $p (keys %areas)
        {
            my ($xp,$yp) = split(/,/, $p);
            $dist += distance($x, $y, $xp, $yp);
        }
        next X unless ($dist < 10000);
        push(@region, "$x,$y");
    }
}

#D(\%areas);

print "Biggest area: " . scalar(@region) . "\n";

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
