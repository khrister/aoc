#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use Graph::Weighted;

my %grid = ("0,0" => 1);
my %gdist = ();
my %keys = ('a' .. 'z');
my %locks = ('A' .. 'Z');

my %routes = ();

my $start = "";

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
            if ($p eq '@')
            {
                $start = "$x,$y";
            }
            if ($p =~ /[a-z]/)
            {
                $keys{$p} = "$x,$y";
                $keys{"$x,$y"} = $p;
            }
            if ($p =~ /[A-Z]/)
            {
                $locks{$p} = "$x,$y";
                $locks{"$x,$y"} = $p;
            }
            $x++;
        }
        $y++;
    }
}

#%grid = filldeadends(%grid);

paint(\%grid);

flood2(split(/,/, $start),0, "@");
foreach my $origin ('a'..'z')
{
    %gdist = ();
    print $origin . " : " . $keys{$origin}. "\n";
    flood2(split(/,/, $keys{$origin}), 0, $origin);
}

paint (\%gdist);

#D(\%gdist);
print "$start\n";

#D(\%keys);
#D(\%locks);

#D(\%routes);

sub filldeadends
{
    my %gr = @_;

    my @deadends = ();

    foreach my $p (sort keys %gr)
    {
        next unless ($gr{$p} eq '.');
        if (checkneighbours($p, %gr))
        {
            push(@deadends, $p);
        }
    }

    foreach my $p (@deadends)
    {
        my $dir = $p;
    TUNNEL:
        while(1)
        {
            my $newdir = checkneighbours($dir, %gr);
            if ($newdir)
            {
                $gr{$dir} = '#';
            }
            else
            {
                last TUNNEL;
            }
            $dir = $newdir;
        }
    }
    return %gr;
}

sub checkneighbours
{
    my $p = shift;
    my %gr = @_;
    return if ($gr{$p} =~ /[a-z]/);
    my ($x, $y) = split(/,/, $p);
    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y - 1);
    my $south = "$x," . ($y + 1);
    my $walls = 0;
    my $opendir = "";
    foreach my $dir ($west, $east, $north, $south)
    {
        if ($gr{$dir} eq '#')
        {
            $walls++;
        }
        elsif ($gr{$dir} =~ /[.A-Za-z]/)
        {
            $opendir = $dir;
        }
    }
    if ($walls == 3)
    {
        return $opendir;
    }
    return "";
}

sub nexus
{

}

sub flood2
{
    my ($x, $y, $dist, $origin) = @_;

    if (defined ($gdist{"$x,$y"}) and $gdist{"$x,$y"} < $dist)
    {
        return;
    }


    if ($dist and my $key = $keys{"$x,$y"})
    {
        $origin .= ",$key";
        $routes{"$origin"} = $dist;
    }
    elsif ($dist and my $lock = $locks{"$x,$y"})
    {
        $origin .= ",$lock";
        $routes{"$origin"} = $dist;
    }
    #paint(\%gdist, 0) if (! ($dist % 20));

    $gdist{"$x,$y"} = $dist++;

    my $west = ($x - 1) . ",$y";
    my $east = ($x + 1) . ",$y";
    my $north = "$x," . ($y - 1);
    my $south = "$x," . ($y + 1);

    # Try going west
    if ($grid{$west} ne '#')
    {
        flood2($x-1, $y, $dist, $origin);
    }
    # Try going east
    if ($grid{$east} ne '#')
    {
        flood2($x+1, $y, $dist, $origin);
    }
    # Try going north
    if ($grid{$north} ne '#')
    {
        flood2($x, $y-1, $dist, $origin);
    }
    # Try going south
    if ($grid{$south} ne '#')
    {
        flood2($x, $y+1, $dist, $origin);
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
