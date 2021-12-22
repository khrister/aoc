#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my %cuboids = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
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
        $x1 = -50 if ($x1 < -50);
        $x2 = 50 if ($x2 > 50);
        my ($y1, $y2) = split(/\.\./, $yrange);
        $y1 = -50 if ($y1 < -50);
        $y2 = 50 if ($y2 > 50);
        my ($z1, $z2) = split(/\.\./, $zrange);
        $z1 = -50 if ($z1 < -50);
        $z2 = 50 if ($z2 > 50);
    X:
        foreach my $x ($x1..$x2)
        {
            next X
                if ($x > 50 or $x < -50);
        Y:
            foreach my $y ($y1..$y2)
            {
                next Y
                    if ($y > 50 or $y < -50);
            Z:
                foreach my $z ($z1..$z2)
                {
                    next Z
                        if ($z > 50 or $z < -50);
                    if ($onoff eq "on")
                    {
                        $cuboids{"$x,$y,$z"} = 1;
                    }
                    else
                    {
                        delete $cuboids{"$x,$y,$z"}
                            if ($cuboids{"$x,$y,$z"});
                    }
                }
            }
        }
    }
}

#D(\%cuboids);
print %cuboids . "\n";

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
