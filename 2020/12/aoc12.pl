#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

# N = 0, E = 1, S = 2, W = 3
my $dir = 1;
my $x = 0;
my $y = 0;

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
    if ($d eq "L")
    {
        $dir = ($dir - ($n / 90)) % 4;
    }
    elsif ($d eq "R")
    {
        $dir = ($dir + ($n / 90)) % 4;
    }
    elsif ($d eq "N")
    {
        $y += $n;
    }
    elsif ($d eq "S")
    {
        $y -= $n;
    }
    elsif ($d eq "E")
    {
        $x += $n;
    }
    elsif ($d eq "W")
    {
        $x -= $n
    }
    elsif ($d eq "F")
    {
        $y += $n if ($dir == 0);
        $x += $n if ($dir == 1);
        $y -= $n if ($dir == 2);
        $x -= $n if ($dir == 3);
    }
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
