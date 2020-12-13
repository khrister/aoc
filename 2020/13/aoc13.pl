#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my $arrival;
my @busses;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    $arrival = <$fh>;
    chomp $arrival;
    my $bustmp = <$fh>;
    chomp $bustmp;
    @busses = split(/,/, $bustmp);
    close($fh);
}

my $wait = $arrival;
my $mul;

BUS:
foreach my $bus (@busses)
{
    next BUS if ($bus eq 'x');
    my $tmpwait = $bus - ($arrival % $bus);
    if ($tmpwait < $wait)
    {
        $wait = $tmpwait;
        $mul = $wait * $bus;
    }
}

print "Wait: $wait; mul = $mul\n";

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
