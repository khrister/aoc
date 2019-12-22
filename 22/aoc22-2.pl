#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my @origdeck;
my @olddeck;
my @newdeck;
my @instructions;
my $decksize;
my $expected_result;

{
    die "Usage: $0 <file> <decksize>" unless (@ARGV == 2);
    my $file = shift @ARGV;
    $decksize = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @instructions = <$fh>;
    close($fh);
    chomp(@instructions);
    @origdeck = 0..($decksize-1);
    if ($instructions[-1] =~ /^Result/)
    {
        $expected_result = pop @instructions;
    }
}

@olddeck = @origdeck;

foreach my $inst (@instructions)
{
    if ($inst eq "deal into new stack")
    {
        @newdeck = reverse(@olddeck);
    }
    elsif ($inst =~ /^cut (-?[0-9]+)$/)
    {
        @newdeck = cut($1);
    }
    elsif ($inst =~/^deal with increment ([0-9]+)$/)
    {
        @newdeck = deal($1);
    }
    @olddeck = @newdeck;
}

if ($expected_result)
{
    my $result = "Result: " . join(" ", @newdeck);
    if ($expected_result eq $result)
    {
        print "Success!\n"
    }
    else
    {
        print "$expected_result\n";
        print "$result\n";
    }
}
else
{
    print "Element 2019 is at: " . (first_index { $_ == 2019 } @newdeck) . "\n";
}

sub cut
{
    my $no = shift;
    if ($no > 0)
    {
        return ( @olddeck[$no..($decksize - 1)], @olddeck[0..($no - 1)] );
    }
    else
    {
        return ( @olddeck[($decksize + $no) .. ($decksize - 1)],
                 @olddeck[0 .. ($#olddeck + $no)]),
    }
}

sub deal
{
    my $no = shift;
    my $i = 0;
    my @tempdeck;
    while ($i < $decksize)
    {
        $tempdeck[($i*$no) % $decksize] = $olddeck[$i];
        $i++;
    }
    return @tempdeck;
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
