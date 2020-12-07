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
my %bags_of;
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
            $bag =~ s/([0-9]+ [a-z]+ [a-z]+) bags?[.]?/$1/;
            $bags_of{$outer} = [] unless $bags_of{$outer};
            my $num = substr($bag, 0, 1);
            $bag = substr($bag, 2);
            foreach my $n (1..$num)
            {
                push(@{$bags_of{$outer}}, $bag);
            }
        }
    }
    close $file;
}

# Recurse and count all bags, then subtract yourself
$total = possible_bags("shiny gold") - 1;

sub possible_bags
{
    my $search = shift;

    # Empty bags return 1
    return 1 if (! $bags_of{$search});

    # If we already know how many bags are inside, don't recurse
    return ($found_bags{$search}) if ($found_bags{$search});

    my $numbags = 0;
    foreach my $inner (@{$bags_of{$search}})
    {
        my $tmp = possible_bags($inner);
        $numbags += $tmp;
    }
    # Return numer of bags inside plus yourself
    return $numbags + 1;
}


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
