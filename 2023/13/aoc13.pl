#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (all max min sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Math::Combinatorics qw/combine/;

# Global variables
my $total = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    local $/ = ""; # One paragraph at a time
    while (my $para = <$fh>)
    {
        my @rows = split(/^/, $para);
        pop @rows if($rows[-1] =~ /^$/); # remove empty line
        chomp @rows;
        my $width = length $rows[0];
        my $height = @rows;
        my @cols;
        foreach my $r (0..@rows-1)
        {
            my @row = split("", $rows[$r]);

            foreach my $i (0..$width-1)
            {
                $cols[$i] .= $row[$i]
            }
        }
        my @horizontal = search_mirror(@rows);
        my @vertical = search_mirror(@cols);
        foreach my $h (@horizontal)
        {
            $total += ($h + 1) * 100;
        }
        foreach my $v (@vertical)
        {
            $total += $v+1;
        }
    }
    close($fh);
}

sub search_mirror # search mirror plane
{
    my @arr = @_;
    my $N = @arr;
    my @c;
    for my $c (0..$N-2)
    {
        my $m = min($c, $N -2 -$c);
        push @c, $c if (all {$arr[$c - $_] eq $arr[$c + 1 + $_]} (0..$m));
    }
    return @c;
}

say $total;

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
