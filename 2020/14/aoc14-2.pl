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
use Algorithm::Combinatorics qw(combinations);

my $orbitmask;
my %memory = ();
my @instructions = ();
my @floatingbits = ();

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
        # First, set up an or-bitmask for the non-X values
        $orbitmask = $bitmask;
        $orbitmask =~ s/X/0/g;
        $orbitmask = bin2dec($orbitmask);

        # The X values needs a bit more work.
        @floatingbits = ();
        my $i = 0;
        my @bits = split(//, $bitmask);

        # Loop over the bits and add the bit value to @floatingbits
        while ($i < 36)
        {
            if ($bits[$i] eq "X")
            {
                my $p = 2**(35 - $i);
                push(@floatingbits, $p);
            }
            $i++;
        }
        next;
    }
    my ($pos, $val) = split(/ = /, $inst);

    $pos =~ s/mem\[(\d+)\]/$1/;

    # Or the memory position with the or-mask
    $pos |= $orbitmask;

    # Set the value in the cell where all floating bits are 0
    $memory{$pos} = $val;

    # For each possible length of floating bit combinations
    foreach my $k (1 .. @floatingbits)
    {

        # Find all combinations
        my $iter = combinations(\@floatingbits, $k);

        # And iterate over them
        while (defined(my $ref = $iter->next))
        {
            my $s = sum(@{$ref});
            my $npos = $pos ^ $s; # Original bits may be 0 or 1, so xor it
            $memory{$npos} = $val;
        }
    }
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
