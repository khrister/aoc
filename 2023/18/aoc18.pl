#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use feature 'say';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables

my @poly;

my %dirs = ( 'R'=> [1,0], 'D'=> [0,1], 'L'=> [-1,0], 'U'=> [0,-1],
        '0'=> [1,0], '1'=> [0,1], '2'=> [-1,0], '3'=> [0,-1] );

my $fib = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    my @pos = (0, 0);
    while (my $line = <$fh>)
    {
        chomp $line;
        my ($dir, $dist, $col) = split(" ", $line);
        # You need to measure the total distance of the circumference,
        # since you're measuring from the center of the squares, you need
        # to add half the circumference + 1.
        $fib += $dist;
        my ($x, $y) = @{$dirs{$dir}};
        $x = $pos[0] + $x * $dist;
        $y = $pos[1] + $y * $dist;
        @pos = ($x, $y);
        push(@poly, [ $x, $y ]);
    }
    close($fh);
}

sub area_by_shoelace {
    my $area;
    our @p;
    $#_ > 0 ? @p = @_ : (local *p = shift);
    $area += $p[$_][0] * $p[($_+1)%@p][1] for 0 .. @p-1;
    $area -= $p[$_][1] * $p[($_+1)%@p][0] for 0 .. @p-1;
    return abs($area/2);
}

#D(\@poly);

say (area_by_shoelace(reverse @poly) + $fib/2 + 1);

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
