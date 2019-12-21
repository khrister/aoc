#!/usr/bin/env perl
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


# Iterate the start value, zeroing in on the one that is closest to 1 trillion
# but not above
{
    my $goal = 1000000000000;
    my $num = 865467;     # Original guess, 1 trillion divided by ore needed
                          # to make 1 fuel
    my $above = 1000000000000; # We definitely won't make 1 trillion fuel
    my $below = 0;             # And we will make more than 0, hopefully...
    my $i;

    while (1)
    {
        $i++;
        my $used = run($num);
        if ($used > $goal)
        {
            my $div = $used / $goal;
            $above = int($num / $div) + 1;
        }
        else
        {
            my $mul = $goal / $used;
            $below = int($num * $mul);
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


sub run
{
    my $n = shift;
    my %spares = ();
    return produce("FUEL", $n, \%spares);
}

sub produce
{
    my $mat = shift;
    my $amount = shift;
    my $spare_ref = shift;
    my $result = 0;

    if (!$goods{$mat})
    {
        print "No material $mat found\n";
        exit;
    }
    my @arr = @{$goods{$mat}};
    my $made = pop @arr;

    # How many do we need compares to how many we make per production
    my $multi = int($amount / $made);
    my $remain = $amount % $made;
    if ($remain)
    {
        $multi++;
        if ($spare_ref->{$mat})
        {
            $spare_ref->{$mat} += ($made - $remain);
        }
        else
        {
            $spare_ref->{$mat} = ($made - $remain);
        }
    }

    # Make the sub parts
    while (@arr)
    {
        my $namount = pop @arr;
        my $nmat = pop @arr;
        my $spare = 0;
        # If it's ORE
        if ($nmat eq "ORE")
        {
            return $namount * $multi;
        }

        # Check if we have spare materials
        if ($spare_ref->{$nmat})
        {
            # If we have enough, just go on to the next material
            # and remove the used material from storage
            if ($spare_ref->{$nmat} >= $namount * $multi)
            {
                $spare_ref->{$nmat} -= $namount * $multi;
                next;
            }
            $spare = $spare_ref->{$nmat};
            $spare_ref->{$nmat} = 0;
        }
        # And produce more
        $result += produce($nmat, $namount * $multi - $spare, $spare_ref);
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

    do
    {
        my $namount;
        my $n;
        ($namount, $n, $a) = split(/,? /, $a, 3);
        push(@lneeds, ($n, $namount));
    } while ($a and $a =~ / /);
    push(@lneeds, $amount);

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
