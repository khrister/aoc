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
my %exchange = ("." => "#", "#" => ".");

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

        my @sketch;
        foreach my $r (@rows)
        {
            push @sketch, [split "", $r];
        }
        my $h = analyze(@sketch);
        my $v = analyze(transpose(@sketch));
        $total += 100 * $h + $v;
    }
    close($fh);
}

sub analyze # search mirror planes
{
    my @arr = @_;
    my $height = @arr;
    my $width = @{$arr[0]};
    for my $r (0..$height-2) # for each possible mirror
    {
        my $errs; # number of errors
        my $m = min($r, $height - 2 - $r);
        foreach my $i (0..$m) # for each object-image pair
        {
            for my $c (0..$width-1)
            {
                my $diff = $arr[$r - $i][$c] ne $arr[$r+1+$i][$c];
                $errs += $diff;
            }
        }
        return $r + 1 if ($errs == 1); #assume only one mirror with exactly one smudge
    }
    return 0;
}

sub transpose
{
    my @arr = @_;
    my @res;
    return @res unless @arr;
    my $height = @arr;
    my $width = @{$arr[0]} if $height;
    for my $i (0..$height-1)
    {
        for my $j (0..$width-1)
        {
            $res[$j][$i] = $arr[$i][$j];
        }
    }
    return @res;
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
