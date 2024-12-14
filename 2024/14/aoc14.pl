#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';
use v5.16;
use Carp;

# Other modules
use List::Util qw (max sum product);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Array::Compare;
use Algorithm::Combinatorics qw (combinations);;

# Global variables

my @bots;
my %final;
my $width;
my $height;
my @quads;

{
    croak("Usage: $0 <file> <width> <height> <iterations>")
        unless (@ARGV == 4);
    my $file = shift @ARGV;

    $width = shift;
    $height = shift;
    my $iter = shift;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my ($pos, $vel) = split(/ /, $line);
        (undef, $pos) = split(/=/, $pos);
        (undef, $vel) = split(/=/, $vel);
        push(@bots, [ $pos, $vel ]);
    }
    foreach my $bot (@bots)
    {
        my ($pos, $vel) = @$bot;
        my ($x0, $y0) = split(/,/, $pos);
        my ($vx, $vy) = split(/,/, $vel);
        my $x1 = ($x0 + $vx * $iter) % $width;
        my $y1 = ($y0 + $vy * $iter) % $height;
        if ($final{"$x1,$y1"})
        {
            $final{"$x1,$y1"}++;
        }
        else
        {
            $final{"$x1,$y1"} = 1;
        }
    }
    close($fh);
}

foreach my $pos (keys %final)
{
    my ($x, $y) = split(/,/, $pos);
    next if ($x == ($width - 1) / 2 or $y == ($height - 1) / 2);
    my $quad = 0;

    if ($x > ($width - 1) / 2)
    {
        $quad = 1;
    }
    if ($y > ($height - 1) / 2)
    {
        $quad += 2;
    }
    $quads[$quad] += $final{$pos};;
}
 say product(@quads);


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
