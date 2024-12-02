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
use Array::Compare;

# Global variables
my @reports;
my $sum = 0;
my $comp = Array::Compare->new;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        my @tmp = split(/ /, $line);
        push(@reports, \@tmp);
    }
    close($fh);
}

REPORT:
foreach my $ref (@reports)
{
    my @rep_orig = @$ref;
 TRY:
    for (my $try = -1; $try <= $#rep_orig; $try++)
    {
        my @rep;
        if ($try == -1)
        {
            @rep = @rep_orig;
        }
        else
        {
            @rep = @rep_orig;
            splice(@rep, $try, 1);
        }
        # D(\@rep);
        my @sorted = sort { $a <=> $b } @rep;

        if ($comp->compare(\@rep, \@sorted))
        {
            for (my $i = 0; $i < $#rep; $i++)
            {
                my $cur = $rep[$i];
                my $nxt = $rep[$i + 1];
                next TRY if ($cur == $nxt or ($cur + 3) < $nxt);
            }
            $sum++;
            next REPORT;
        }

        my @reversed = reverse(@sorted);
        if ($comp->compare(\@rep, \@reversed))
        {
            my $err = 0;
            for (my $i = 0; $i < $#rep; $i++)
            {
                my $cur = $rep[$i];
                my $nxt = $rep[$i + 1];
                next TRY if ($cur == $nxt or ($cur - 3) > $nxt);
            }
            $sum++;
            next REPORT;
        }
    }
}

print "$sum\n";


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
