#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Memoize;

#memoize('flood');

my %grid = ();     # The starting grid
my %goblins = ();  # Goblins (starts with 200 hp)
my %elves = ();    # Elves (also with 200 hp)

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
            if ($p eq "#")
            {
                $grid{"$x,$y"} = "#";
            }
            else
            {
                $grid{"$x,$y"} = ".";
            }
            if ($p eq "G")
            {
                $goblins{"$x,$y"} = 200;
            }
            if ($p eq "E")
            {
                $elves{"$x,$y"} = 200;
            }
            $x++;
        }
        $y++;
    }
}

paint(\%grid);

D(\%goblins);
D(\%elves);
my %gd = ();
my ($x, $y) = split(/,/, (keys %goblins)[0]);
flood(\%gd, $x, $y, 0);
paint (\%gd);

sub flood
{
    my ($gdist, $x, $y, $dist) = @_;
    if (defined ($gdist->{"$x,$y"}) and $gdist->{"$x,$y"} <= $dist)
    {
        return;
    }

    $gdist->{"$x,$y"} = $dist++;

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y - 1);
    my $south = "$x," . ($y + 1);

    # Try going west
    if ($grid{$west} ne '#' and !$elves{$west} and !$goblins{$west})
    {
        flood($gdist, $x-1, $y, $dist);
    }
    # Try going east
    if ($grid{$east} ne '#' and !$elves{$east} and !$goblins{$east})
    {
        flood($gdist, $x+1, $y, $dist);
    }
    # Try going north
    if ($grid{$north} ne '#' and !$elves{$north} and !$goblins{$north})
    {
        flood($gdist, $x, $y-1, $dist);
    }
    # Try going south
    if ($grid{$south} ne '#' and !$elves{$south} and !$goblins{$south})
    {
        flood($gdist, $x, $y+1, $dist);
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
            elsif($pixel =~ /\d\d/)
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
