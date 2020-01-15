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
use Memoize;

# Global variables
my $serial;
my $max = 0;
my $square = "";

memoize('calc_power');

croak "$0 <grid serial number>" unless (@ARGV == 1);
$serial = shift @ARGV;

foreach my $x (1..298)
{
    foreach my $y (1..298)
    {
        my $total = 0;
        foreach my $x0 ($x .. $x + 2)
        {
            foreach my $y0 ($y .. $y + 2)
            {
                $total += calc_power($x0,$y0);
            }
        }
        if ($total > $max)
        {
            $max = $total;
            $square = "$x,$y";
        }
    }
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
