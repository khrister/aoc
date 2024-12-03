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
use Array::Compare;

# Global variables
my $sum;
my $sum2;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    local $/;
    open($fh, '<', $file);
    my $line = <$fh>;

    # Part 1
    say sumstring($line);

    # Remove stuff between dont and do
    while ($line =~ s/don't\(\).*?(do\(\)|$)//gs)
    {
    }

    # Part 2
    say sumstring($line) ;
    close($fh);
}

sub sumstring
{
    my $str = shift;
    my $total = 0;

    my @mul = $str =~ m/mul\((\d+,\d+)\)/g;
    foreach my $i (@mul)
    {
        my ($a, $b) = split(/,/, $i);
        $total += $a * $b;
    }
    return $total;
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
