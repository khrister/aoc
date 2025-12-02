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
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my %invalidsum = ();
my @primes = (2, 3, 5, 7, 11);

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        next if ($line =~ m/^$/);

        my @r = split(/,/, $line);
    RANGE:
        foreach my $double (@r)
        {
            my $start;
            my $end;
            ($start, $end) = split(/-/, $double);
            my $len = length($start);
        DIV:
            foreach my $div (@primes)
            {
                my $lstart = $start;
                my $llen = $len;
                while ($llen % $div)
                {
                    $lstart = "1" . (0 x $llen);
                    $llen++;
                }
                next DIV if ($lstart > $end);

                my $a = substr($lstart, 0, $llen/$div);
            TRY:
                while (($a x $div) <= $end)
                {
                    if (($a x $div) >= $lstart)
                    {
                        $invalidsum{$a x $div} = 1;
                    }
                    $a++;
                }
            }
        }
    }
    close($fh);
}

say sum keys %invalidsum;


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
