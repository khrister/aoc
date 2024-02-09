#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
#no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum all min);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my @grid;

my $N = 1000000000;
my $total = 0;

while (my $row_strings = diagram())
{
    my $rows = to_matrix($row_strings);
    my $cols = ref_vert(ref_diag($rows));

    my %seen;
    my ($start, $end); # start and end of cycle
    my @pics;
    for(0..$N-1)
    {
        my $pic = join "\n", map {join "", @$_} @$cols;
        ($start, $end) = ($seen{$pic}, $_), last if defined $seen{$pic};
        push @pics, $pic; # Notice push before cycling
        $seen{$pic} = $_;
        $cols = cycle($cols);
    }
    if (defined($start))
    { # found cycle
        my $cycle_length = $end - $start;
        my $Nmod = ($N-$start) % $cycle_length; # not $N-1 cause I pushed before cycling
        my $pic = $pics[$Nmod + $start];
        $cols = [map {chomp; [split ""]} split /^/, $pic];
    }
    my $load = load($cols);
    say $load;
}

sub cycle
{
    my $out = shift;
    $out = rotate_right(tilt_left($out)) for (1..4);
    return $out;
}

sub load
{
    my $arr = shift;
    my $length = @$arr;
    my $load = 0;
    for(@$arr)
    {
        my @col = @$_;
        $load += $col[$_]eq "O"?$length-$_:0 for(0..@col-1);
    }
    return $load;
}

sub tilt_left
{
    my $arr = shift;
    my @newarr;
    for(@$arr)
    {
        my $col = join "", @$_;
        1 while $col =~ s/(\.+)(O+)/$2$1/g;
        push @newarr, [split "", $col];
    }
    return \@newarr;
}

sub ref_diag
{ # reflection on main diagonal
    my $arr = shift;
    my @in = @$arr;
    my @cols;
    for my $i(0..@in-1)
    {
        my @row = @{$in[$i]};
        $cols[$_][$i] = $row[$_] for(0..@row-1);
    }
    return \@cols;
}

sub ref_vert
{ # reflect vertically
    my $arr = shift;
    my @in = @$arr;
    my @out =  reverse @in;
    return \@out;
}

sub rotate_right
{
    my $arr = shift;
    return ref_diag(ref_vert($arr));
}

sub diagram
{
    # read a complete diagram
    local $/ = ""; # paragraph at a time
    local $_ = <>;
    return unless $_;
    my @row_strings = split /^/;
    pop @row_strings if $row_strings[-1] =~ /^$/; # remove empty line
    chomp($_) for @row_strings;
    return \@row_strings if @row_strings;
    return;
}

sub to_matrix
{
    my $arr = shift;
    my @rows = map {[split ""]} @{$arr};
    return \@rows;
}

sub transpose
{
    my $arg = shift;
    my @arr = @$arg;
    my $height = @arr;
    my $width = @{$arr[0]};
    my @out;
    for my $c(0..$width-1)
    {
        push @out, [map {$arr[$_][$c]} 0..$height-1]
    }
    return \@out;
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
