#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use IPC::Run3;
use Algorithm::Permute qw/permute/;

my @cmd = ();
my $in;
my $out;
my $err;
my $max = 0;
my @best;

my $file = shift @ARGV;

$in = "4\n0\n";

@cmd = ('./aoc7.pl', $file);

my @list = (0, 1, 2, 3, 4);

my $p_iterator = Algorithm::Permute->new ( \@list );

while (my @perm = $p_iterator->next)
{
    my $pwr = 0;
    foreach my $cur (@perm)
    {
        $in = "$cur\n$pwr\n";
        run3 (\@cmd, \$in, \$out);
        chomp $out;
        $pwr = $out;
    }
    if ($out > $max)
    {
        $max = $out;
        @best = @perm;
    }
}

print "$max\n";
print join(",", @best) . "\n";

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
