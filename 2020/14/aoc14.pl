#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use feature 'bitwise';
use bigint;
use Math::BigInt;

use Data::Dumper;
use List::Util 'sum';
use List::MoreUtils qw (first_index);

my $andbitmask;
my $orbitmask;
my %memory = ();
my @instructions = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @instructions = <$fh>;
    chomp @instructions;
    close($fh);
}


foreach my $inst (@instructions)
{
    if ($inst =~ m/mask/)
    {
        my (undef, $bitmask) = split(/ = /, $inst);
        $andbitmask = $bitmask;
        $andbitmask =~ s/X/1/g;
        $andbitmask = bin2dec($andbitmask);
        $orbitmask = $bitmask;
        $orbitmask =~ s/X/0/g;
        $orbitmask = bin2dec($orbitmask);
        next;
    }
    my ($pos, $val) = split(/ = /, $inst);

    $pos =~ s/mem\[(\d+)\]/$1/;
    $val &= $andbitmask;
    $val |= $orbitmask;
    $memory{$pos} = $val;
}

print "Sum of values: " . sum(values %memory) . "\n";

sub bin2dec
{
    my $str = shift;
    return Math::BigInt->new("0b" . $str);
}

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
