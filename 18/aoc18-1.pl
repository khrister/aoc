#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use Graph::Weighted;
use Memoize;

memoize('reachable');

my %grid = ();
my %gdist = ();
my %keys = ();
my %locks = ();

my %routes = ();
my @bitmask = ();

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

my $number_of_keys = scalar (grep { length($_) eq 1 } keys %keys);
my $allbits = (2 ** ($number_of_keys)) - 1;

#%grid = filldeadends(%grid);

#paint(\%grid);

flood2(split(/,/, $start),0, "@", "");
foreach my $origin (keys %keys)
{
    next if (length($origin) > 1);
    %gdist = ();
    my $field = ord($origin) - 97;
    $bitmask[$field] = 2 ** $field;
    #print $origin . " : " . $keys{$origin}. "\n";
    flood2(split(/,/, $keys{$origin}), 0, $origin, "");
}

#paint (\%gdist);

#D(\%gdist);
#print "$start\n";

#D(\%keys);
#D(\%locks);

#D(\%routes);

print "Distance: " . dist_collect_keys("@", 0, {});
print "\n";

sub dist_collect_keys
{

    my $current = shift;   # What key am I standing on
    my $foundbits = shift; # Bit 0 = a, bit 1 = b, bit 2 = c and so on
    my $cache = shift;     # Should be a hashref, put distances here

    if ($current ne '@')
    {
        $foundbits = set_bit($foundbits, $current);
    }

    if ($foundbits == $allbits)
    {
        return 0;
    }

    my $cachekey = $current . $foundbits;
    if ($cache->{$cachekey})
    {
        return $cache->{$cachekey};
    }
    my $result = 1e999;
    foreach my $key (reachable($foundbits))
    {
        my $tmp;
        next if ($key eq $current);
#        print "Serching from $key foundbits = $foundbits, $allbits\n";
        $tmp = $routes{"$current,$key"}->[0] + dist_collect_keys($key, $foundbits, $cache);
#        print "$tmp\n";
        if ($tmp < $result)
        {
            $result = $tmp;
        }
    }
    $cache->{$cachekey} = $result;
    return $result;
}

sub reachable
{
    my $bits = shift;
    my @result = ();
 KEY:
    foreach my $key (%keys)
    {
        next KEY if (length($key) > 1);
        next KEY if ($bitmask[ord($key) - 97] & $bits);
        my $locks = $routes{"@,$key"}->[1];
        foreach my $lock (split(//, $locks))
        {
            my $tmp = $bitmask[ord(lc($lock)) - 97];
            next KEY unless ($tmp & $bits)
        }
        push(@result, $key);
    }
    return @result;
}

sub set_bit
{
    my $field = shift;
    my $key = shift;
    return $field | $bitmask[ord($key) - 97];
}

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

sub flood2
{
    my ($x, $y, $dist, $origin, $seen_locks) = @_;
    if (defined ($gdist{"$x,$y"}) and $gdist{"$x,$y"} < $dist)
    {
        return;
    }

    my $key = $keys{"$x,$y"};
    if ($dist and $key)
    {
        # print "Started at $origin, found $key, seen $seen_locks\n";
        $routes{"$origin,$key"} = [ $dist, $seen_locks ]
    }
    elsif (my $lock = $locks{"$x,$y"})
    {
        $seen_locks .= $lock;
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
        flood2($x-1, $y, $dist, $origin, $seen_locks);
    }
    # Try going east
    if ($grid{$east} ne '#')
    {
        flood2($x+1, $y, $dist, $origin, $seen_locks);
    }
    # Try going north
    if ($grid{$north} ne '#')
    {
        flood2($x, $y-1, $dist, $origin, $seen_locks);
    }
    # Try going south
    if ($grid{$south} ne '#')
    {
        flood2($x, $y+1, $dist, $origin, $seen_locks);
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
