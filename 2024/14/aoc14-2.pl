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


{
    croak("Usage: $0 <file>")
        unless (@ARGV == 1);
    my $file = shift @ARGV;

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
    close($fh);
    my %orig;
    my $width = 101;
    my $height = 103;
    my $i = 0;
    my $max = $height * $width;
 LOOP:
    while ($i++ < $max)
    {
        my %final;
        foreach my $bot (@bots)
        {
            my ($pos, $vel) = @$bot;
            my ($x0, $y0) = split(/,/, $pos);
            my ($vx, $vy) = split(/,/, $vel);
            my $x1 = ($x0 + $vx) % $width;
            my $y1 = ($y0 + $vy) % $height;
            $bot = [ "$x1,$y1", $vel ];
            $final{"$x1,$y1"} = 1;
        }

        my @keys = keys %final;
        @keys = map { $_ =~ s/,[0-9]+$//; $_ } @keys;
        my $keystring = join(",", sort @keys);
        # Just check every time there are 30 robots on the same X axis
        # and use Mark I Eyeball to look for the tree
        if ($keystring =~ m/(\d+,)\1{30}/)
        {
            my @grid = mkgrid($width, $height);
            foreach my $pos (keys %final)
            {
                my ($x, $y) = split(/,/, $pos);
                $grid[$y]->[$x] = "#";
            }
            #D(\@grid);
            paint(@grid);
            say $i;
            sleep(1);
        }

        last LOOP if ($i > 100000);
    }
    say $i;
    say "======";
}


sub mkstring
{
    my @arr = @_;
    my $res = "";
    foreach my $line (@arr)
    {
        $res .= join("", @{$line}) . "\n";
    }
    return $res;
}

sub paint
{
    my @arr = @_;
    print mkstring(@arr);
}

sub mkgrid
{
    my $width = shift;
    my $height = shift;
    my $str = "." x $width;
    my @grid;
    foreach my $i (1..$height)
    {
        push(@grid, [ split(//, $str) ]);
    }
    return @grid;
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
