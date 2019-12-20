#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';

my %grid = ();
my %gdist = ();
my %portals = ();

my $height = 0;
my $width = 0;

my $start = "";
my $goal = "";
my $distance;
my $maxdepth = 25;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
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
            $x++;
        }
        $y++;
        $width = $x+1 if ($width < $x);;
    }
    $height = $y-1;
}

foreach my $c (keys %grid)
{
    my $p = $grid{$c};
    next unless ($p =~ /^[A-Z]$/); # ignore non-portals

    my ($x, $y) = split(/,/, $c);
    next if ($x < 0 or $y < 0 or $x == $width or $y == $height);
    my $up = "$x," . ($y-1);
    my $down = "$x," . ($y+1);
    my $left = ($x-1) . ",$y";
    my $right = ($x+1) . ",$y";
    my $dest;

    if ($grid{$up} and $grid{$up} =~ /^[A-Z]$/ and $grid{$down} and $grid{$down} eq '.')
    {
        $grid{$c} = $grid{$up} . $p;
        $grid{$up} = " ";
        $grid{$right} = "";
        $dest = $down;
    }
    elsif ($grid{$down} and $grid{$down} =~ /^[A-Z]$/ and $grid{$up} and $grid{$up} eq '.')
    {
        $grid{$c} = $p . $grid{$down};
        $grid{$down} = " ";
        $grid{$right} = "";
        $dest = $up;
    }
    elsif ($grid{$left} and $grid{$left} =~ /^[A-Z]$/ and $grid{$right} and $grid{$right} eq '.')
    {
        $grid{$c} = $grid{$left} . $p;
        $grid{$left} = "";
        $dest = $right;
    }
    elsif($grid{$right} and $grid{$right} =~ /^[A-Z]$/ and $grid{$left} and $grid{$left} eq '.')
    {
        $grid{$c} = $p . $grid{$right};
        $grid{$right} = "";
        $dest = $left;
    }
    if ($grid{$c} eq "AA")
    {
        $start = $c;
    }
    elsif ($grid{$c} eq "ZZ")
    {
        $goal = $c
    }
    elsif ($grid{$c} =~ /[A-Z][A-Z]/)
    {
        my $out;
        if ($x < 4 or ($width - $x)  < 4 or $y < 4 or ($height - $y) < 4)
        {
            $out = 1;
        }
        else
        {
            $out = 0;
        }
        if ($portals{$grid{$c}})
        {
            push($portals{$grid{$c}}, $c, $dest, $out);
        }
        else
        {
            $portals{$grid{$c}} = [ $c, $dest, $out ];
        }
    }
}

#paint(\%grid);
#D(\%portals);
#print "starting flood($start,0)\n";
while (!$distance)
{
    flood2(split(/,/, $start), 0, 0);
}

print "$distance\n";


sub flood2
{
    my ($x, $y, $dist, $level) = @_;

    my $c = "$x,$y";
    my $i = $c .",$level";

    if (defined ($gdist{$i}) and $gdist{$i} < $dist)
    {
        return;
    }

    if ($level > $maxdepth or $dist > 10000)
    {
        return;
    }
    if ($grid{$c} eq 'AA')
    {
    }
    elsif ($grid{$c} eq 'ZZ')
    {
        if (!$level)
        {
            $distance = $dist - 2;
        }
        else
        {
            return;
        }
    }
    elsif ($grid{$c} =~ /[A-Z][A-Z]/)
    {
        my $portal = $grid{$c};
        my @coords = @{$portals{$portal}};
        #print "Entered portal " . $grid{$c} . " at $c";
        if ($c eq $coords[0])
        {
            if ($coords[2])
            {
                return if (!$level);
                $level--;
            }
            else
            {
                $level++;
            }
            $c = $coords[4];
        }
        elsif ($c eq $coords[3])
        {
            if ($coords[5])
            {
                return if (!$level);
                $level--;
            }
            else
            {
                $level++;
            }
            $c = $coords[1];
        }
        ($x, $y) = split(",", $c);
        #print ", got out at $c, dist $dist\n";
    }

    if (defined ($gdist{$i}) and $gdist{$i} < $dist)
    {
        return;
    }

    $gdist{$i} = $dist++;

    #paint(\%gdist, 0) if (! ($dist % 20));

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y - 1);
    my $south = "$x," . ($y + 1);

    # Try going west
    if ($grid{$west} and $grid{$west} !~ /[# ]/)
    {
        flood2($x-1, $y, $dist, $level);
    }
    # Try going east
    if ($grid{$east} and $grid{$east} !~ /[# ]/)
    {
        flood2($x+1, $y, $dist, $level);
    }
    # Try going north
    if ($grid{$north} and $grid{$north} !~ /[# ]/)
    {
        flood2($x, $y-1, $dist, $level);
    }
    # Try going south
    if ($grid{$south} and $grid{$south} !~ /[# ]/)
    {
        flood2($x, $y+1, $dist, $level);
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
        ($x,$y, undef) = split(/,/, $p);

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
            elsif ($pixel =~ /\d\d/)
            {
                print $pixel % 10;
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
