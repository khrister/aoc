#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw (array_minus );

my @cups;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $data = <$fh>;
    chomp $data;
    @cups = split(//, $data);
    close($fh);
}

my $curidx = 0;

foreach my $move (1..100)
{
    my @lcups = (@cups, @cups);

    my $current = $lcups[$curidx];
    my @movers = @lcups[($curidx + 1) .. ($curidx + 3)];

    my @tmpcircle = array_minus(@lcups, @movers);
    my $destination = $current - 1;
    $destination = 9 unless ($destination);
    while (grep { $destination eq $_ } @movers)
    {
        $destination--;
        $destination = 9 if (!$destination);
    }
    my $destidx = first_index { $_ == $destination } @tmpcircle;
    @cups = (@tmpcircle[0..$destidx], @movers, @tmpcircle[($destidx + 1) .. 8]);
    @cups = @cups[0..8];


    $curidx = first_index { $_ == $current } @cups;
    $curidx++;
    $curidx %= 9;
}

my $one = first_index { $_ == 1 } @cups;
my @res = (@cups[($one + 1) .. 8], @cups[0 .. ($one - 1)]);

print join("", @res) . "\n";

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
