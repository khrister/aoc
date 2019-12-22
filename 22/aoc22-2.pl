#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);
use bignum;
use bigint;
use ntheory qw/invmod powmod/;

my @instructions;
my $decksize;
my $origpos;

{
    die "Usage: $0 <file> <decksize> <pos>" unless (@ARGV == 3);
    my $file = shift @ARGV;
    $decksize = shift @ARGV;
    $origpos = shift;
    my $fh;
    open($fh, '<', $file);
    @instructions = <$fh>;
    close($fh);
    chomp(@instructions);
    if ($instructions[-1] =~ /^Result/)
    {
        pop @instructions;
    }
}



my @results = ($origpos);

my $offset = 0;
my $increment = 1;

foreach my $inst (@instructions) {
    if ($inst eq "deal into new stack") {
        # Find the new position
        $increment *= -1;
        $increment %= $decksize;
        $offset += $increment;
        $offset %= $decksize;
    } elsif ($inst =~ /^cut (-?[0-9]+)$/) {
        # uncut instead of cut
        uncut($1);
    } elsif ($inst =~/^deal with increment ([0-9]+)$/) {
        # undeal instead of deal
        undeal($1);
    } else 
    {
        print "Help! Wrong instructions? $inst\n"
    }
}
print "offset $offset, increment $increment\n";

my $n = 101741582076661;
my $fininc = powmod($increment, $n, $decksize);
my $finoff = ($offset * (1 - powmod($increment, $n, $decksize)) * powmod(1 - $increment, $decksize - 2, $decksize)) % $decksize;
my $res = ($finoff + $fininc * $origpos) % $decksize;
print "$res\n";

sub uncut
{
    my $no = shift;
    $offset += $increment * $no;
    $offset %= $decksize;
}

sub undeal
{
    my $no = shift;
    $increment *= powmod($no, $decksize-2, $decksize);
    $increment %= $decksize;
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
