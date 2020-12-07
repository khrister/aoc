#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;

# Global variables
my %bag_in;
my %found_bags;
my $total = 0;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;

    open($fh, '<', $file) or die "Couldn't open file $file";

    while (my $input = <$fh>)
    {
        chomp $input;
        my ($outer, $input) = split(/ bags contain /, $input);
        my @inner = split(/, /, $input);
    BAG:
        foreach my $bag (@inner)
        {
            next BAG if ($bag =~ m/no other bags/);
            $bag =~ s/[0-9]+ ([a-z]+ [a-z]+) bags?[.]?/$1/;
#            print "$bag inside $outer\n";
            $bag_in{$bag} = [] unless $bag_in{$bag};
            push(@{$bag_in{$bag}}, $outer);
        }
    }
    close $file;
}

possible_bags("shiny gold");

sub possible_bags
{
    my $search = shift;
    return if (! $bag_in{$search});
    return if ($found_bags{$search});
    foreach my $outer (@{$bag_in{$search}})
    {
        possible_bags($outer);
        $found_bags{$outer} = 1;
    }
}

$total = keys %found_bags;

print "Total: $total\n";

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

Copyright Christer Boräng 2019

=cut
