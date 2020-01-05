#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Memoize;

memoize('reachable');

my %grid = ();    # The starting grid
my %gdist = ();   # Distances from a point in the maze
my %keys = ();    # Where the keys are
my %locks = ();   # Where the locks are
my %routes = ();  # key: start,end, values: (distance, locks in the way)
my @bitmask = (); # bitmask of all keys found
my $start = "";   # This the robot starting position

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

# Number of keys dictates the size of the bitfield
my $number_of_keys = scalar (grep { length($_) eq 1 } keys %keys);
# All bits set
my $allbits = (2 ** ($number_of_keys)) - 1;

# Get routes from the starting point
flood2(split(/,/, $start),0, "@", "");

# And from all keys. I could optimize by avoiding reverses,
# but it's quick anyway
foreach my $origin (keys %keys)
{
    next if (length($origin) > 1);
    %gdist = ();

    # Seed the bitmask array
    my $field = ord($origin) - 97;
    $bitmask[$field] = 2 ** $field;

    # And find the routes to all other keys from here
    flood2(split(/,/, $keys{$origin}), 0, $origin, "");
}

print "Distance: " . dist_collect_keys("@", 0, {});
print "\n";

sub dist_collect_keys
{

    my $current = shift;   # What key am I standing on
    my $foundbits = shift; # Bit 0 = a, bit 1 = b, bit 2 = c and so on
    my $cache = shift;     # Should be a hashref, put distances here

    # As long as we have moved away from teh start, add current
    # to the bitmask
    if ($current ne '@')
    {
        $foundbits = set_bit($foundbits, $current);
    }

    # If all bits are set, we're done
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
        $tmp = $routes{"$current,$key"}->[0]
            + dist_collect_keys($key, $foundbits, $cache);
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
