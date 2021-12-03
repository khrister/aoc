#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my @numbers;
my @ones;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @numbers = <$fh>;
    chomp @numbers;
    close($fh);
}

#D(\@numbers);

sub ones
{
    my @lnums = @_;
    my @lones;

    foreach my $num (@lnums)
    {
        my @bits;
        @bits = split(//, $num);
        for (my $i = 0; $i <= $#bits; $i++)
        {
            $lones[$i] += $bits[$i];
        }
    }
    return @lones;
}

@ones = ones(@numbers);

#D(\@ones);

my $gamma = "0b";
my $epsilon = "0b";

foreach my $digit (@ones)
{
    if ($digit > (@numbers / 2))
    {
        $gamma .= 1;
        $epsilon .= 0;
    }
    else
    {
        $gamma .= 0;
        $epsilon .= 1;
    }
}

print "Power Consumption: " . (oct($gamma) * oct($epsilon)) . "\n";
my @gammas = @numbers;

for (my $i = 0; $i <= length($gammas[0]); $i++)
{
    @ones = ones(@gammas);
    if ($ones[$i] >= (@gammas / 2))
    {
        @gammas = grep { substr($_, $i, 1) == 1 } @gammas;
    }
    else
    {
        @gammas = grep { substr($_, $i, 1) == 0 } @gammas;
    }
#    print "i = $i\n";
#    D(\@gammas);
    last if ($#gammas == 0);
}

my @epsilons = @numbers;

for (my $i = 0; $i <= length($epsilons[0]); $i++)
{
    @ones = ones(@epsilons);
    if ($ones[$i] < (@epsilons / 2))
    {
        @epsilons = grep { substr($_, $i, 1) == 1 } @epsilons;
    }
    else
    {
        @epsilons = grep { substr($_, $i, 1) == 0 } @epsilons;
    }
#    print "i = $i\n";
#    D(\@epsilons);
    last if ($#epsilons == 0);
}

print "Life support rating "
    . (oct("0b" . $gammas[0]) * oct("0b" . $epsilons[0])) . "\n";

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
