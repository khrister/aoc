#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use Carp;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum min/;
use List::MoreUtils 'first_index';
use Time::HiRes 'usleep';

# Global variables
my %grid = ();
my $serial;
my $max = 0;
my $square = "";

croak "$0 <grid serial number>" unless (@ARGV == 1);
$serial = shift @ARGV;

# Seeding the grid is alot quicker than memoizing the function
# (which basically IS seeding the grid, but with more overhead
# and a function call each time)
foreach my $x (1..300)
{
    foreach my $y (1..300)
    {
        my $power = calc_power($x,$y);
        no warnings qw<uninitialized>;
        $grid{"$x,$y"} = $power + $grid{($x-1) . ",$y"}
            + $grid{"$x," . ($y - 1)} - $grid{($x -1) . "," . ($y - 1)};
        if ($power > $max)
        {
            $max = $power;
            $square = "$x,$y,1";
            print "Max is now $max, at $square\n";
        }
    }
}

foreach my $x (1..300)
{
    foreach my $y (1..300)
    {
        # Max size possible is the smallest of the values
        my $biggest = min(300 - $x, 300 - $y);
        foreach my $size (2 .. $biggest)
        {
            my $x0 = $x - 1;
            my $y0 = $y - 1;
            no warnings qw<uninitialized>;
            my $total = $grid{"$x0,$y0"}
                + $grid{($x + $size - 1) . "," . ($y + $size - 1)}
                    - $grid{($x + $size - 1) . ",$y0"}
                        - $grid{"$x0," . ($y + $size - 1)};
            if ($total > $max)
            {
                $max = $total;
                $square = "$x,$y,$size";
                print "Max is now $max, at $square\n";
            }
        }
#        print "At y $y\n";
    }
#    print "At x $x\n";
}

print "Max $max at square starting at $square\n";

sub calc_power
{
    my ($x, $y) = @_;
    my $rack = $x + 10;
    return (split(//, ($rack * $y + $serial) * $rack))[-3] - 5;
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
