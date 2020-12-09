#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;
use Algorithm::Combinatorics qw(combinations);
use List::Util qw(max min);

# Global variables
my @numbers = ();
my $preamble;
my $weakidx;
my $weakno;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;
    $preamble = shift @ARGV;
    open($fh, '<', $file) or die "Couldn't open file $file";
    @numbers = <$fh>;
    chomp @numbers;
    close $file;
}

print "preamble = $preamble\n";

my $i = $preamble;

while ($i < @numbers)
{
    my $cur = $numbers[$i];
    my @prelist = @numbers[($i - $preamble)..($i - 1)];
    my $iter = combinations(\@prelist, 2);
    my $found = 0;
 PAIR:
    while (my $pairref = $iter->next)
    {
        if ($pairref->[0] + $pairref->[1] == $numbers[$i])
        {
            $found = 1;
            last PAIR;
        }
    }

    if (!$found)
    {
        print "Weakness found: " . $numbers[$i] . "\n";
        $weakidx = $i;
        $weakno = $numbers[$i];
        last;
    }
    $i++;
}

$i = 0;
WEAKNESS:
while ($i < $weakidx)
{
    my $j = $i + 1;
    my $sum = $numbers[$i];
 SUM:
    while ($j < @numbers)
    {
        $sum += $numbers[$j];
        last SUM if ($sum > $weakno);
        if ($sum == $weakno)
        {
            my $weakness = max(@numbers[$i..$j]) + min(@numbers[$i..$j]);
            print "Crypto weakness: $weakness\n";
            last WEAKNESS;
        }
        $j++;
    }
    $i++;
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

Copyright Christer Boräng 2019

=cut
