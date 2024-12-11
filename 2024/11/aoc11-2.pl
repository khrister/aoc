#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';
use v5.16;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Array::Compare;
use Algorithm::Combinatorics qw (combinations);;

# Global variables

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $line = <$fh>;
    close($fh);

    chomp $line;
    my @stones = split(/ /, $line);
    my $blink25 = 0;
    my $blink75 = 0;
    $blink25 += blink($_, 25) for (@stones);
    say $blink25;
    $blink75 += blink($_, 75) for (@stones);
    say $blink75;
}

sub blink
{
    my $stone = shift;
    my $times = shift;
    state $cache;
    my $len = length ($stone);
    $$cache {$stone} {$times} //=
        $times   == 0 ? 1
      : $stone   == 0 ? blink (1, $times - 1)
      : $len % 2 == 0 ? blink (0 + substr ($stone, 0, $len / 2),
                                 $times - 1) +
                        blink (0 + substr ($stone,    $len / 2),
                                 $times - 1)
      :                 blink ($stone * 2024, $times - 1);
}

# Debug function
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

Copyright Christer Boräng 2023

=cut
