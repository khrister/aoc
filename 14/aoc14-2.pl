#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;

# Other modules

# Global variables


# 4 mat_a needs 10 mat_b, 12 mat_c, 4 mat_d ->
# %goods = ( mat_a => [ 4, mat_b, 10, mat_c, 12, mat_d, 4 ] )
my %goods = ();

my $ore_used = 0;

my %spares = ();


{
    my $fh;
    my $file = shift @ARGV;
    open($fh, '<', $file)
        or die("Could not open $file: ");
    while (my $line = <$fh>)
    {
        parseline($line);
    }
    close $fh;
}


{
    my $num = 843671;
    my $above = 1000000000000;
    my $below = 0;
    my $i;
    while (1)
    {
        $i++;
        if (test($num) > 1000000000000)
        {
            $above = $num;
        }
        else
        {
            $below = $num;
        }
        $num = int(($above - $below) / 2) + $below;
        if (($above - $below) eq 1)
        {
            print "You can get $below fuel units\n";
            print "solved in $i tries\n";
            exit;
        }
    }
}

sub test
{
    my $n = shift;
    my $r = produce("FUEL", $n);
    %spares = ();
    return $r;
}

sub produce
{
    my $mat = shift;
    my $amount = shift;
    my $result = 0;
    if (!$goods{$mat})
    {
        print "No material $mat found\n";
        exit;
    }
    my @arr = @{$goods{$mat}};
    my $made = shift @arr;

    # How many do we need compares to how many we make per production
    my $multi = int($amount / $made);
    my $remain = $amount % $made;
    if ($remain)
    {
        $multi++;
        if ($spares{$mat})
        {
            $spares{$mat} += ($made - $remain);
        }
        else
        {
            $spares{$mat} = ($made - $remain);
        }
    }

    # Make the sub parts
    while (@arr)
    {
        my $nmat = shift @arr;
        my $namount = shift @arr;
        my $spare = 0;
        # If it's ORE
        if ($nmat eq "ORE")
        {
            return $namount * $multi;
        }

        if ($spares{$nmat})
        {
            if ($spares{$nmat} >= $namount * $multi)
            {
                $spares{$nmat} -= $namount * $multi;
                next;
            }
            $spare = $spares{$nmat};
            $spares{$nmat} = 0;
        }
        $result += produce($nmat, $namount * $multi - $spare);
    }
    return $result;
}

sub parseline
{
    my $line = shift;
    chomp $line;
    my @lneeds = ();

    my ($a, $b) = split(/ => /, $line);
    my ($amount, $mat) = split(/ /, $b);
    $lneeds[0] = $amount;

    do
    {
        my $namount;
        my $n;
        ($namount, $n, $a) = split(/,? /, $a, 3);
        push(@lneeds, ($n, $namount));
    } while ($a and $a =~ / /);

    $goods{$mat} = \@lneeds;
}

# Debug printouts
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
