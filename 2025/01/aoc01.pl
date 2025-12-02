#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my @moves;

my $sum2;
{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        push(@moves, $line);
    }
    close($fh);
}

my $dial = 50;
my $zero = 0;
my $zero2 = 0;

foreach my $i (@moves)
{
    next unless $i =~ /^[LR][0-9]+/;
    my $dir = substr($i, 0, 1);
    my $num = substr($i, 1);
    #say "$dir $num";
    $dial += ($dir eq "R" ? $num : -$num);
    $zero2 += abs int $dial / 100;
    $zero2 ++ if ($dial < 0 and abs($dial) ne abs($num) or $dial eq 0);
    $dial %= 100;
    $zero++ if (!$dial);
    #say "$dir $num => $dial ($zero, $zero2)";
}

say $zero;
say $zero2;

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
