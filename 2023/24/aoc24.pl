#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Math::Combinatorics qw/combine/;

# Global variables
my $sum;
my @lines;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my ($co, $ve) = split(/ @ /, $line);
        my @coords = split(/, /, $co);
        my @vectors = split(/, /, $ve);

        push(@lines, [ @coords, @vectors ]);
    }
    close($fh);
}

my $comb = Math::Combinatorics->new(count => 2,
                                    data => [ @lines ]);


while (my @pair = $comb->next_combination)
{
    my @l1 = @{$pair[0]};
    my @l2 = @{$pair[1]};

    my ($x1a, $y1a, $z1a) = @l1[0..2];
    my ($x2a, $y2a, $z2a) = @l2[0..2];

    # Find a second point
    my (undef, undef, undef, $x1b, $y1b, $z1b) = find_points(@l1);
    my (undef, undef, undef, $x2b, $y2b, $z2b) = find_points(@l2);

    # And use that to make an equation of the line
    my ($a1, $b1) = find_line($x1a, $y1a, $x1b, $y1b);
    my ($a2, $b2) = find_line($x2a, $y2a, $x2b, $y2b);

    # And then find the intersection between the two lines
    my ($x, $y) = find_intersect($a1, $b1, $a2, $b2);
    next unless ($x);
    if ($x <= 400000000000000 and $x >= 200000000000000 and $y <= 400000000000000 and $y >= 200000000000000)
    {
        # Check if it's in the future
        my $dir1 = $l1[3];
        my $dir2 = $l2[3];
        next if ($x1a < $x and $dir1 < 0);
        next if ($x1a > $x and $dir1 > 0);
        next if ($x2a < $x and $dir2 < 0);
        next if ($x2a > $x and $dir2 > 0);

        $sum++;
    }
}

say $sum;

sub find_points
{
    my ($x, $y, $z, $vx, $vy, $vz ) = @_;
    return ($x, $y, $z, $x + $vx, $y + $vy, $z + $vy);
}

sub find_line {
    my ($x1, $y1, $x2, $y2) = @_;
    my $slope = ($y2 - $y1) / ($x2 - $x1);
    # find b for y1 = slope * x1 + b
    my $b = $y1 - $slope * $x1;
    return $slope, $b;
}

sub find_intersect {
    my ($a1, $b1, $a2, $b2) = @_;
    # solve y = ax + b for a1, b1 and a2, b2
    # i.e.: a1 x + b1 = a2 x + b2 <=> x (a1 - a2) = b2 - b1
    return undef if ($a1 == $a2);
    my $abscissa = ($b2 - $b1) / ($a1 - $a2);
    #say "x = $abscissa";
    my $ordinate = $a1 * $abscissa + $b1;
    return $abscissa, $ordinate;
}


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

Copyright Christer Boräng 2023

=cut
