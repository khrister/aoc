#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2022

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

my $sum = 0;
my @pairs;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @pairs = <$fh>;
    chomp @pairs;
    close($fh);
}

#D(\@pairs);

foreach my $pair (@pairs)
{
    my $one;
    my $two;

    my @onerange;
    my @tworange;

    ($one, $two) = split(/,/, $pair);

    if ($one =~ /-/)
    {
        my ($s, $e) = split(/-/, $one);
        @onerange = $s..$e;
    }
    else
    {
        @onerange = ($one);
    }
    if ($two =~ /-/)
    {
        my ($s, $e) = split(/-/, $two);
        @tworange = $s..$e;
    }
    else
    {
        @tworange = ($one);
    }

    if (array_minus(@onerange, @tworange)
            and array_minus(@tworange, @onerange))
    {
        # These are not completely overlapping
    }
    else
    {
        $sum++;
    }
}

print "$sum\n";

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
