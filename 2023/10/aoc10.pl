#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';
use Carp;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index firstidx);
use Array::Utils qw(:all);

# Global variables
my %dirs = (R => [1,0], U => [0,-1], L => [-1,0], D => [0,1]);
my @tiles = qw(JRUDL -RRLL 7RDUL |UUDD FURLD LLUDR s .);
my %map = map { my @t = split "";
                @t == 5 ? ($t[0] => { $t[1] => $t[2], $t[3] => $t[4]})
                    : () } @tiles;
my @sketch;
my $row=0;
my $current_coords;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my @row = split("", $line);
        push(@sketch, [@row]);
        my $col = firstidx { $_ eq "S" } @row;
        $current_coords = [$col, $row] if ($col >= 0);
        $row++;
    }
    close($fh);
}

croak("No initial tile") unless (defined $current_coords);

my $step;
my $tile;

# find and take first step
FIRST:
foreach my $d (qw(R U L D))
{
    my $dir = $dirs{$d};
    my $next_coords = add($current_coords, $dir);
    $tile = tile($next_coords);
    my $next_step = $map{$tile}{$d};
    if (defined $next_step)
    {
        $current_coords = $next_coords;
        $step = $d;
        last FIRST;
    }
}
my $length = 1;

# Notice step is out of phase with coords
while ($tile ne "S")
{
    $step = $map{$tile}{$step};
    croak("Shouldn't happen") unless (defined $step);
    my $dir = $dirs{$step};
    $current_coords = add($current_coords, $dir);
    $tile = tile($current_coords);
    $length++;
}
say $length/2;


sub tile
{
    my $tmp = shift;
    my @p = @{$tmp};
    return $sketch[$p[1]][$p[0]];
}

sub add
{
    my ($p, $q) = @_;
    return [map {$p->[$_]+ $q->[$_]}(0,1)];
}

sub mkstring
{
    my @arr = @_;
    my $res = "";
    foreach my $line (@arr)
    {
        $res .= join("", @{$line}) . "\n";
    }
    return $res;
}

sub paint
{
    my @arr = @_;
    print mkstring(@arr);
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
