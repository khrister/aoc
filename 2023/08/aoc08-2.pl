#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Math::Utils qw (lcm);

# Global variables
my @instructions;
my %elements;
my @startnodes;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    # Get instruction list
    my $l = <$fh>;
    chomp $l;
    @instructions = split("", $l);
    map { s/L/0/; s/R/1/; } @instructions;

    while (my $line = <$fh>)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my $src;
        my $dests;
        ($src, $dests) = split(" = ", $line);
        $dests =~ s/[()]//g;
        my @tmp = split(", ", $dests);
        $elements{$src} = \@tmp;
    }
    close($fh);
}

@startnodes = grep { /..A/ } keys %elements;

my $step = 0;
my $mod = @instructions;
my @steps;

while (@startnodes)
{
    my $inst = $instructions[$step % $mod];

    foreach my $node (@startnodes)
    {
        $node = $elements{$node}->[$inst];
    }

    $step++;

    # Check if we're at a full run and found an end point
    if (($step % $mod) == 0)
    {
        my @newnodes;
        foreach my $i (0..$#startnodes)
        {
            if($startnodes[$i] =~ m/..Z/)
            {
                push(@steps, $step);
            }
            else
            {
                push(@newnodes, $startnodes[$i]);
            }
        }
        @startnodes = @newnodes;
    }
}

print lcm(@steps) . "\n";

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
