#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Memoize;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

memoize('score');

# Global variables
my $sum = 0;
my @matches = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my $a;
        my $b;
        ($a, $b) = split(/\|/, $line);
        (undef, $a) = split(/:/, $a);
        #print "$a :: $b\n";

        my @card = split(" ", $a);
        my @draw = split(" ", $b);
        my $winning = intersect(@card, @draw);
        #print "Winning numbers: $winning\n";
        push(@matches, $winning);
    }
    close($fh);
}

#D(\@matches);

foreach my $card (0..$#matches)
{
    $sum += score($card);
}

sub score
{
    my $card = shift;
    my $cardmatch = $matches[$card];
    #print "$card $cardmatch\n";
    return 1 unless $cardmatch;
    my $cardsum = 1;

    foreach my $next (1..$cardmatch)
    {
        $cardsum += score($card + $next);
    }
    return $cardsum;
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
