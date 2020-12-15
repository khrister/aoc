#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use feature 'bitwise';
#use bigint;
#use Math::BigInt;

use Data::Dumper;
use List::Util 'sum';
use List::MoreUtils qw (first_index);

my @numbers;
my $lastnum = 0;
my $firstguess;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $start = <$fh>;
    chomp $start;
    my @tmp = split(/,/, $start);
    my $n = 0;
    while ($n < @tmp)
    {
        push(@{$numbers[$tmp[$n]]}, $n + 1);
        $lastnum = $tmp[$n];
        $n++;
    }
    $firstguess = @tmp + 1;
    close($fh);
}

foreach my $i ($firstguess .. 2020)
{
    my $curnum;
    if ($numbers[$lastnum]->[-2])
    {
        $curnum = $numbers[$lastnum]->[-1] - $numbers[$lastnum]->[-2];
    }
    else
    {
        $curnum = 0;
    }
    push(@{$numbers[$curnum]}, $i);
    $lastnum = $curnum;
}

print "2020th number is $lastnum\n";

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
