#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;

# Global variables
my $start;
my $end;
my $ok_pass = 0;
my $range = <>;
chomp $range;
($start, $end) = split(/-/, $range);

my $cur = $start;
while ($cur <= $end)
{
    my $curok = check_passwd($cur);
    $ok_pass++ if ($curok);
    #print "$cur: $curok\n";
    $cur++;
}

print "Ok passwords found: $ok_pass\n";

sub check_passwd
{
    my $pass = shift;
    chomp $pass;
    my @digits = split(//, $pass);
    my $double = 0;
    my $rising = 0;

    $rising = check_increase(@digits);
    $double = check_pair($pass)
        if ($rising);

    #print "$double, $rising\n";
    return $double && $rising;
}

sub check_double
{
    my @digits = @_;
    my $pair = 0;
    # Compare $first to $first + 1
    foreach my $first (0..4)
    {
        $pair = 1
            if ($digits[$first] == $digits[$first + 1]);
    }
    return $pair;
}

sub check_increase
{
    my @digits = @_;
    my $dec = 0;
    foreach my $cur (0..4)
    {
        $dec = 1
            if ($digits[$cur] > $digits[$cur + 1]);
        return 0 if ($dec);
    }
    return 1;
    #print "dec $dec\n";
}

sub check_pair
{
    my $pass = shift;
    my @res;
    @res = $pass =~ /(\d)\1/g;

    return 0
        if (! scalar @res);

    foreach my $match (@res)
    {
        return 1
            if ($pass !~ /($match)\1\1/);
    }
    return 0;
}


# Debug
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
