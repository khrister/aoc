#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
# Global variables
my $total_fuel;
my @used = ();


while (my $line = <>)
{
    chomp $line;
    push(@used, $line);
}

sub
fuel_use
{
    my $mass = shift;
    return ( floor($mass / 3) -2);
}

foreach my $mass (@used)
{
    my $temp;
    while (($temp = fuel_use($mass)) > 0)
    {

        $total_fuel += $temp;
        $mass = $temp;

    }
}

print "Total fuel: $total_fuel\n";

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
