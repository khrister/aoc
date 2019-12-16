#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);
use IO::Prompter;
use List::Util 'max';
use Time::HiRes qw( gettimeofday tv_interval usleep );;

my @cmd = ();
my $in;
my $out;
my $err;
$SIG{PIPE} = "IGNORE";

my $robot;

my %grid = ("0,0" => 1);
my %gdist = ();

my $oxy = "";

my $pos = "0,0";

# 1 is north, 2 is south, 3 is west, 4 is east

# Maze sprites for pinting the maze
my @sprites = (" ", ".", "O", "#");


my $file = shift @ARGV;

@cmd = ('./intcode.pl', $file);

$in = "";

#Run the robot
$robot = start (\@cmd, \$in, \$out);

flood(0,0,0);

# Done with the robot
eval { $robot->finish() };

#paint(\%grid, 1);
#paint(\%gdist, 0);

print "Oxygen at $oxy at distance " . $gdist{$oxy} . "\n";


{
    %gdist = ();
    my ($x, $y) = split(/,/, $oxy);
    flood2($x, $y, 0);
#    paint(\%grid, 1);
#    paint(\%gdist, 0);
    my $max = max(values(%gdist));
    print "Max distance: $max\n";
}


sub flood2
{
    my ($x, $y, $dist, $rev) = @_;
    $pos = "$x,$y";
    if (defined ($gdist{"$x,$y"}) and $gdist{"$x,$y"} < $dist)
    {
        return;
    }

    $gdist{"$x,$y"} = $dist++;

    #paint(\%gdist, 0) if (! ($dist % 20));

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y + 1);
    my $south = "$x," . ($y - 1);

    # Try going west
    if ($grid{$west} and $grid{$west} != 3)
    {
        flood2($x-1, $y, $dist, 4);
    }
    # Try going east
    if ($grid{$east} and $grid{$east} != 3)
    {
        flood2($x+1, $y, $dist, 3);
    }
    # Try going north
    if ($grid{$north} and $grid{$north} != 3)
    {
        flood2($x, $y+1, $dist, 2);
    }
    # Try going south
    if ($grid{$south} and $grid{$south} != 3)
    {
        flood2($x, $y-1, $dist, 1);
    }
}

sub flood
{
    my ($x, $y, $dist, $rev) = @_;

    $pos = "$x,$y";
    if (defined ($gdist{"$x,$y"}) and $gdist{"$x,$y"} < $dist)
    {
        if ($rev)
        {
            my $s = get_status($rev);
            if ($s == 0)
            {
                print "Reversing into a wall!\n";
                exit;
            }
        }
        return;
    }
#    paint(\%grid, 1) if (! ($dist % 20));
    $gdist{"$x,$y"} = $dist++;

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y + 1);
    my $south = "$x," . ($y - 1);

    # Try going west
    if ($grid{$west} and $grid{$west} != 3)
    {
        get_status(3);
        flood($x-1, $y, $dist, 4);
    }
    else
    {
        my $s = get_status(3);
        if ($s == 0)
        {
            $grid{$west} = 3;
        }
        elsif ($s == 1)
        {
            $grid{$west} = 1;
            flood($x-1, $y, $dist, 4);
        }
        elsif ($s == 2)
        {
            $grid{$west} = 2;
            $oxy = $west;
            flood($x-1, $y, $dist, 4);
        }
    }
    # Try going east
    if ($grid{$east} and $grid{$east} != 3)
    {
        get_status(4);
        flood($x+1, $y, $dist, 3);
    }
    else
    {
        my $s = get_status(4);
        if ($s == 0)
        {
            $grid{$east} = 3;
        }
        elsif ($s == 1)
        {
            $grid{$east} = 1;
            flood($x+1, $y, $dist, 3);
        }
        elsif ($s == 2)
        {
            $grid{$east} = 2;
            $oxy = $east;
            flood($x+1, $y, $dist, 3);
        }
    }
    # Try going north
    if ($grid{$north} and $grid{$north} != 3)
    {
        get_status(1);
        flood($x, $y+1, $dist, 2);
    }
    else
    {
        my $s = get_status(1);
        if ($s == 0)
        {
            $grid{$north} = 3;
        }
        elsif ($s == 1)
        {
            $grid{$north} = 1;
            flood($x, $y+1, $dist, 2);
        }
        elsif ($s == 2)
        {
            $grid{$north} = 2;
            $oxy = $north;
            flood($x, $y+1, $dist, 2);
        }
    }
    # Try going south
    if ($grid{$south} and $grid{$south} != 3)
    {
        get_status(2);
        flood($x, $y-1, $dist, 1);
    }
    else
    {
        my $s = get_status(2);
        if ($s == 0)
        {
            $grid{$south} = 3;
        }
        elsif ($s == 1)
        {
            $grid{$south} = 1;
            flood($x, $y-1, $dist, 1);
        }
        elsif ($s == 2)
        {
            $grid{$south} = 2; 
            $oxy = $south;
            flood($x, $y-1, $dist, 1);
        }
    }
    if ($rev)
    {
        my $s = get_status($rev);
        if ($s == 0)
        {
            print "Reversing into a wall!\n";
            exit;
        }
    }
}

sub get_status
{
    # find status
    my $s = shift;

    eval { $robot->pump()
               until ( $out =~ /^input:/ or !$robot->pumpable); };
    die("No input found")
        unless ($out);
    $out =~ s/^input://;
    $in = "$s\n";
    eval { $robot->pump()
               until ( $out =~ /^\d\n/ or !$robot->pumpable); };
    die ("No output from pump")
        unless ($out);
    ($s, $out) = split(/\n/, $out, 2);

    return $s;
}

sub paint
{
    my $ref =  shift;
    my $sprites = shift;
    my %gr = %{$ref};
    my $xmin = 0;
    my $xmax = 0;
    my $ymin = 0;
    my $ymax = 0;
    $gr{"0,0"} = 2;

    foreach my $p (keys %gr)
    {
        my $x;
        my $y;
        ($x,$y) = split(/,/, $p);

        $xmax = $x if ($x > $xmax);
        $ymax = $y if ($y > $ymax);
        $xmin = $x if ($x < $xmin);
        $ymin = $y if ($y < $ymin);
    }
    print "================================================\n";
    foreach my $y ($ymin..$ymax)
    {
        foreach my $x ($xmin..$xmax)
        {
            my $pixel = $gr{"$x,$y"};
            if ($x == 0 and $y == 0)
            {
                print "o";
            }
            elsif (!$pixel)
            {
                print " ";
            }
            elsif($pos eq "$x,$y")
            {
                print "X";
            }
            elsif ($sprites)
            {
                print $sprites[$pixel];
                if ($pixel == 2)
                {
                    $oxy = "$x,$y";
                }
            }
            else
            {
                print ($pixel % 10);
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

Copyright Christer Boräng 2011

=cut
