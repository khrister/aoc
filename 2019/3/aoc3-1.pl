#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
use Data::Dumper;

# Global variables

my %wire1;
my %wire2;

{
    my $tmp = <>;
    %wire1 = get_coords($tmp);
    $tmp = <>;
    %wire2 = get_coords($tmp);
}
sub get_coords
{
    my $tmp = shift;
    my %res;
    chomp $tmp;
    my @keys = split(/,/, $tmp);
    my $x = 0; my $y = 0;
    foreach my $move (@keys)
    {
        my $dir = substr($move, 0, 1);
        my $len = substr($move, 1);
        my $curx = $x;
        my $cury = $y;
        if ($dir eq 'D')
        {
            while ($y > ($cury - $len))
            {
                $y--;
                $res{"$x,$y"} = 1;
            }
        }
        elsif ($dir eq 'U')
        {
            while ($y < $cury + $len)
            {
                $y++;
                $res{"$x,$y"} = 1;
            }
        }
        elsif ($dir eq 'L')
        {
            while ($x > $curx - $len)
            {
                $x--;
                $res{"$x,$y"} = 1;
            }
        }
        elsif ($dir eq 'R')
        {
            while ($x < ($curx + $len))
            {
                $x++;
                $res{"$x,$y"} = 1;
            }
        }
        else
        {
            print "Error: dir = $dir\n";
        }
    }
    my @f = sort keys %res;
    return %res;
}

my $min = 0;
foreach my $p (keys %wire1)
{
    next unless ($wire2{$p});
    my $x; my $y;
    ($x, $y) = split(/,/, $p);
    my $dist = abs($x) + abs($y);
    print "Crossing found at $p, dist: $dist\n";
    $min = $dist if ($dist < $min or $min == 0);
}

print "Min distance: $min\n";


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
