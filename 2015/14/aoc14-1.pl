#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Carp;
use List::Util qw( sum any );
use Algorithm::Permute qw/permute/;
use JSON;
use POSIX;

my %reindeers;
my $goal;
my $max = 0;

{
    my $file = shift @ARGV or croak("Usage: $0 <file>");;
    open(my $fh, '<', $file) or croak("Can't open file $file");
    my @lines;
    @lines = <$fh>;
    chomp @lines;
    close($fh);
    foreach my $line (@lines)
    {
        my @tmp = split(/ /, $line);
        $reindeers{$tmp[0]} = [ $tmp[3], $tmp[6], $tmp[13] ];
    }
    $goal = shift @ARGV;
    chomp @ARGV;
}

foreach my $rd (keys %reindeers)
{
    my ($speed, $active, $rest) = @{$reindeers{$rd}};
    my $period = $active + $rest;
    my $revs = floor($goal / $period);
    my $left = $goal % $period;
    my $base = $revs * $active * $speed;

    if ($left > $active)
    {
        $left = $active;
    }
    my $total = $left * $speed + $base;

    if ($total > $max)
    {
        $max = $total;
    }
}

print "$max\n";

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
