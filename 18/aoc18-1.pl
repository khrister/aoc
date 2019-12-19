#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';

my %grid = ("0,0" => 1);
my %gdist = ();

my $start = "";

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file);
    my $x = 0;
    my $y = 0;

    while(my $line = <$fh>)
    {
        chomp $line;
        my @pixels = split(//, $line);
        $x = 0;
        foreach my $p (@pixels)
        {
            $grid{"$x,$y"} = $p;
            if ($p eq '@')
            {
                $start = "$x,$y";
            }
            $x++;
        }
        $y++;
    }
}

paint(\%grid);

flood2(split(/,/, $start),0);

paint (\%gdist);

#D(\%gdist);

print "$start\n";

sub flood2
{
    my ($x, $y, $dist, $rev) = @_;

    if (defined ($gdist{"$x,$y"}) and $gdist{"$x,$y"} < $dist)
    {
        return;
    }

    $gdist{"$x,$y"} = $dist++ % 10;

    #paint(\%gdist, 0) if (! ($dist % 20));

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y - 1);
    my $south = "$x," . ($y + 1);

    # Try going west
    if ($grid{$west} and $grid{$west} ne '#')
    {
        flood2($x-1, $y, $dist, 4);
    }
    # Try going east
    if ($grid{$east} and $grid{$east} ne '#')
    {
        flood2($x+1, $y, $dist, 3);
    }
    # Try going north
    if ($grid{$north} and $grid{$north} ne '#')
    {
        flood2($x, $y-1, $dist, 2);
    }
    # Try going south
    if ($grid{$south} and $grid{$south} ne '#')
    {
        flood2($x, $y+1, $dist, 1);
    }
}

sub paint
{
    my $ref =  shift;
    my %gr = %{$ref};
    my $xmin = 0;
    my $xmax = 0;
    my $ymin = 0;
    my $ymax = 0;

    foreach my $p (keys %gr)
    {
        my $x;
        my $y;
        ($x,$y) = split(/,/, $p);

        $xmax = $x if ($x > $xmax);
        $ymax = $y if ($y > $ymax);
    }
    print "================================================\n";
    foreach my $y (0..$ymax)
    {
        foreach my $x (0..$xmax)
        {
            my $pixel = $gr{"$x,$y"};
            if (!defined($pixel))
            {
                print " ";
            }
            else
            {
                print $pixel;
            }
        }
        print "\n";
    }
}


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
