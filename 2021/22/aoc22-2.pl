#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my @cuboids = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
 LINE:
    while (my $line = <$fh>)
    {
        my $onoff;
        my $tmp;
        my $coords;
        my $xrange;
        my $yrange;
        my $zrange;
        ($onoff, $tmp) = split(/ /, $line);

        ($xrange, $yrange, $zrange) = ($tmp =~ m/[xyz]=(-?\d+\.\.-?\d+),?/g);

        my ($x1, $x2) = split(/\.\./, $xrange);
        my ($y1, $y2) = split(/\.\./, $yrange);
        my ($z1, $z2) = split(/\.\./, $zrange);
        if (!@cuboids)
        {
            @cuboids =  ("$x1,$x2,$y1,$y2,$z1,$z2");
            next LINE;
        }

        my @new_cuboids = ();
        @new_cuboids = find_overlaps($onoff, $x1, $x2, $y1, $y2, $z1, $z2, @cuboids);
#        D(\@new_cuboids);
        @cuboids = @new_cuboids;
    }
}

D(\@cuboids);

sub find_overlaps
{
    my ($onoff, $x1, $x2, $y1, $y2, $z1, $z2, @cub) = @_;
#    D(\@cub);
    my @new_cub = ("$x1,$x2,$y1,$y2,$z1,$z2");
    foreach my $cuboid (@cub)
    {
#        print "$cuboid\n";
        my ($xc1, $xc2, $yc1, $yc2, $zc1, $zc2) = split(/,/, $cuboid);
        if ($x1 < $xc2 and $x2 > $xc1 and $y1 < $yc2 and $y2 > $yc1 and
                $z1 < $zc2 and $z2 > $zc1)
        {
            print "found intersection for $x1,$x2,$y1,$y2,$z1,$z2 and $cuboid\n";
        }
        else
        {
 #           print "found no intersection for $x1,$x2,$y1,$y2,$z1,$z2 and $cuboid\n";

        }
        push(@new_cub, $cuboid);
    }
    return @new_cub;
}


# Debug function
sub D
{
    my $str = shift;
    print Dumper($str);
}

# Other modules

# Global variables


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
