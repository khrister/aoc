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

my @instructions;
my $decksize;
my $pos;
{
    die "Usage: $0 <file> <decksize> <pos>" unless (@ARGV == 3);
    my $file = shift @ARGV;
    $decksize = shift @ARGV;
    $pos = shift;

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

# We want to find what ends up in spot 2020. Best way I can think of is to
# work backwards and try to find a cycle
@instructions = reverse @instructions;

foreach my $inst (@instructions)
{
    if ($inst eq "deal into new stack")
    {
        # Find the new position
        $pos = $decksize - 1 - $pos;
#        print "reversed, pos = $pos\n";
    }
    elsif ($inst =~ /^cut (-?[0-9]+)$/)
    {
        # uncut instead of cut
        $pos = uncut($1);
#        print "uncut, pos = $pos\n";
    }
    elsif ($inst =~/^deal with increment ([0-9]+)$/)
    {
        # undeal instead of deal
        $pos = undeal($1);
#        print "undealt, pos = $pos\n";
    }
}

print "$pos\n";

sub uncut
{
    my $no = shift;
    if ($no > 0)
    {
        return ($pos + $no) % $decksize;
    }
    else
    {
        return ($pos + $no) % $decksize;
    }
}

sub undeal
{
    my $no = shift;
    my $tmp = 0;
    while (($tmp * $decksize + $pos)  % $no)
    {
        $tmp++;
    }
    return ($tmp * $decksize + $pos) / $no;
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
