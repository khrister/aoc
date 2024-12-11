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
use Array::Compare;
use Algorithm::Combinatorics qw (combinations);;

# Global variables
my @grid;
my $height;
my $width;
my %antennas;
my %antinodes;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        push(@grid, [ split(//, $line) ]);
    }
    close($fh);
    $width = @{$grid[0]};
    $height = @grid;
    for (my $y = 0; $y < $height; $y++)
    {
    POINT:
        for (my $x = 0; $x < $width; $x++)
        {
            my $p = $grid[$y]->[$x];
            next POINT if ($p eq '.');
            if ($antennas{$p})
            {
                push($antennas{$p}, "$x,$y");
            }
            else
            {
                $antennas{$p} = [ "$x,$y" ];
            }
        }
    }
    foreach my $freq (keys %antennas)
    {
        my @combinations = combinations($antennas{$freq}, 2);
        #D(\@combinations);
        foreach my $combo (@combinations)
        {
            my ($a, $b) = @{$combo};
            $antinodes{$a}++;
            $antinodes{$b}++;
        #say "$a, $b";
            my ($x0, $y0) = split(/,/, $a);
            my ($x1, $y1) = split(/,/, $b);

            my $xc = $x0 - $x1;
            my $yc = $y0 - $y1;

            my $xa0 = $x0 + $xc;
            my $xa1 = $x1 - $xc;
            my $ya0 = $y0 + $yc;
            my $ya1 = $y1 - $yc;
            while (check($xa0, $ya0))
            {
                $antinodes{"$xa0,$ya0"}++;
                $xa0 = $xa0 + $xc;
                $ya0 = $ya0 + $yc;
            }
            while (check($xa1, $ya1))
            {
                $antinodes{"$xa1,$ya1"}++;
                $xa1 = $xa1 - $xc;
                $ya1 = $ya1 - $yc;
            }
        }
    }
}

say scalar(keys %antinodes);

sub check
{
    my $x = shift;
    my $y = shift;

    return 0 if ($x < 0 or $x >= $width or $y < 0 or $y >= $height);
    return 1;
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
