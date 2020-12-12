#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my $x = 0;
my $y = 0;
my $wpx = 10;
my $wpy = 1;

my @moves;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @moves = <$fh>;
    chomp @moves;
    close($fh);
}

foreach my $move (@moves)
{
    my ($d, $n) = split(//, $move, 2);
    if ($n == 270)
    {
        if ($d eq "L")
        {
            $d = "R"
        }
        else
        {
            $d = "L"
        }
        $n = 90;
    }
    if ($d =~ m/[LR]/)
    {
        if ($n == 180)
        {
            $wpx = -$wpx;
            $wpy = -$wpy;
        }
        else
        {
            my $newx;
            my $newy;
            # This is a left rotation
            $newx = -$wpy;
            $newy = $wpx;

            if ($d eq "L")
            {
                $wpx = $newx;
                $wpy = $newy;
            }
            else
            {
                #Turning R is turning L + 180 degrees
                $wpx = -$newx;
                $wpy = -$newy
            }
        }
    }
    elsif ($d eq "N")
    {
        $wpy += $n;
    }
    elsif ($d eq "S")
    {
        $wpy -= $n;
    }
    elsif ($d eq "E")
    {
        $wpx += $n;
    }
    elsif ($d eq "W")
    {
        $wpx -= $n
    }
    elsif ($d eq "F")
    {
        $x += $n * $wpx;
        $y += $n * $wpy;
    }
    #print "$move => x = $x, y = $y, wpx = $wpx, wpy = $wpy\n";
}

print "manhattan distance: " . (abs($x) + abs($y)) . "\n";

# Debug function
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
