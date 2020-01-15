#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum/;
use List::MoreUtils 'first_index';

# Global variables
my $currentplayer = 0;
my $currentmarble = 0;
my @players = ();
my @circle = (0);
my $marbles;
my $testanswer;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my $line = <$fh>;
    chomp($line);
    close ($fh);
    my @tmp;
    my $play;
    @tmp = split(/ /, $line);
    $play = $tmp[0];
    $marbles = $tmp[6];
    $testanswer = $tmp[11] if (@tmp > 11);;
    @players = (0) x $play;
}

print "" . scalar(@players) . " players, $marbles marbles\n";
print "Looking for the answer to be $testanswer\n" if ($testanswer);

foreach my $m (1..$marbles)
{
    if ($m % 23 == 0)
    {
        my $p = ($m - 1) % scalar (@players);
        my $minus7 = ($currentmarble - 7) % scalar (@circle);
        $players[$p] += $m + $circle[$minus7];
        splice(@circle, $minus7, 1);
        $currentmarble = $minus7;
    }
    else
    {
        my $new_pos = ($currentmarble + 2) % scalar (@circle);
        if ($new_pos == 0)
        {
            push(@circle, $m);
            $currentmarble = $#circle;
        }
        else
        {
            splice(@circle, $new_pos, 0, $m);
            $currentmarble = $new_pos;
        }
        #print "" . join(" ", @circle) . "\n";
    }
}

my $max = max(@players);
print "Max found: $max";
print " Correct!" if ($testanswer and $testanswer == $max);
print "\n";

#debug function
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

Copyright Christer Boräng 2019

=cut
