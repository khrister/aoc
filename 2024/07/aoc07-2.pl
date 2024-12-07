#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index any);
use Array::Utils qw(:all);
use Array::Compare;
use Algorithm::Combinatorics qw(variations_with_repetition);
use Memoize;

# Global variables

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my @lines = <$fh>;
    close($fh);

    chomp @lines;

    my $sum;
    memoize('get_permutations');

 LINE:
    foreach my $line (@lines)
    {
        my ($result, $tmp) = split(/: /, $line);
        my @numbers = split(/ /, $tmp);
        my @combs = get_permutations(['+', '*', '.'], @numbers - 1);
        #D(\@combs);

        foreach my $comb (@combs)
        {
            my @ops = @{$comb};
            my $res = $numbers[0];
            for (my $i = 0; $i <= $#ops; $i++)
            {
                if ($ops[$i] eq ".")
                {
                    $res = $res .  $numbers[$i + 1];
                }
                else
                {
                    my $str = $res . $ops[$i] . $numbers[$i + 1];
                    $res = eval $str;
                }
            }
            if ($res == $result)
            {
                $sum += $res;
                #say "current $sum";
                next LINE;
            }
        }
    }
    say $sum;
}

sub get_permutations
{
    my $ops = shift;
    my $number = shift;
    return variations_with_repetition($ops, $number);
}



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
