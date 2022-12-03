#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

my $sum = 0;
my @rucksacks;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @rucksacks = <$fh>;
    chomp @rucksacks;
    close($fh);
}

#D(\@rucksacks);

for (my $i = 0; $i < $#rucksacks; $i += 3)
{
    my @one = unique(split(//, $rucksacks[$i]));
    my @two = unique(split(//, $rucksacks[$i + 1]));
    my @three = unique(split(//, $rucksacks[$i + 2]));

    my @isect = intersect(@one, @two);
    @isect = intersect(@isect, @three);

    my $char = $isect[0];

    if ($char =~ /[a-z]/)
    {
        $sum += ord($char) - 97 + 1;
    }
    else
    {
        $sum += ord($char) - 65 + 1 + 26;
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
