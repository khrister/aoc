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

# Global variables
my @maze;
my %visited;
my $pos;
my $xmax;
my $ymax;
my $dir = 0;
my $start;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my @lines = <$fh>;
    close($fh);

    chomp @lines;
    for (my $y = 0; $y <= $#lines; $y++)
    {
        my @line = split(//, $lines[$y]);
        if (grep { $_ eq "^" } @line)
        {
            my $x = index($lines[$y], "^");
            $line[$x] = ".";
            $pos = "$x,$y";
            $visited{$pos} = 1;
            $start = $pos;
        }
        push(@maze, \@line);
    }
    $ymax = $#lines;
    $xmax = length($lines[0]);
}

#paint(@maze);

sub solve
{
 MOVE:
    while (1)
    {
        my ($x,$y) = split(/,/, $pos);
        my ($next, $x0, $y0) = check($x, $y, $dir);
        #say $next;
        if ($next eq "#") # turn
        {
            $dir++;
            $dir %=4;
        }
        elsif ($next eq ".") # Continue moving
        {
            $pos = "$x0,$y0";
            $visited{$pos} = 1;
        }
        elsif ($next eq " ") # Empty space, we're done
        {
            last MOVE;
        }
    }
}

solve();
say scalar keys %visited;

foreach my $pos (keys %visited)
{
    # The guard will notice it at the start position
    next if ($pos eq $start);
    

}

sub check
{
    my $x = shift;
    my $y = shift;
    my $dir = shift;

    $y-- if ($dir == 0);
    $x++ if ($dir == 1);
    $y++ if ($dir == 2);
    $x-- if ($dir == 3);
    my $res = $maze[$y]->[$x];
    return (($res ? $res : " "), $x, $y);
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
