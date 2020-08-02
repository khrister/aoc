#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( sum );
use Algorithm::Permute qw/permute/;

my %distances;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    my @instructions = <$fh>;
    chomp @instructions;
    close($fh);
    foreach my $inst (@instructions)
    {
        my ($cities, $distance) = split(/ = /, $inst);
        my ($a, $b) = split(/ to /, $cities);
        if (!$distances{$a})
        {
            $distances{$a} = {};
        }
        if (!$distances{$b})
        {
            $distances{$b} = {};
        }

        $distances{$a}->{$b} = $distance;
        $distances{$b}->{$a} = $distance;
    }
}

my @cities = keys %distances;
my $p_iterator = Algorithm::Permute->new(\@cities);

my $mindist = 1000000;

while (my @perms = $p_iterator->next)
{
    my $dist = 0;

    foreach my $idx (0..$#perms - 1)
    {
        $dist += $distances{$perms[$idx]}->{$perms[$idx+1]};
    }
    $mindist = $dist if ($dist < $mindist);
}

print "$mindist\n";


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
