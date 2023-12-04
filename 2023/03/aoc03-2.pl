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

# Global variables
my @grid = ();
my $xmax = 0;
my $ymax = 0;
my $sum = 0;
my %cogs ;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my @lines = <$fh>;
    chomp @lines;
    close($fh);

    # Build the grid
    foreach my $line (@lines)
    {
        my @row = split(//, $line);
        push(@grid, \@row);
    }

    # what is the maximum index for x and y
    $xmax = @{$grid[0]} - 1;
    $ymax = $#grid;
}


ROW:
foreach my $y (0..$ymax)
{
 COL:
    for(my $x = 0; $x <= $xmax; $x++)
    {
        my $cur = $grid[$y]->[$x];
        next COL unless $cur =~ /[0-9]/;

        my $num = $cur;
    DIGIT:
        foreach my $digit (($x+1)..$xmax)
        {
            my $next = $grid[$y]->[$digit];
            last DIGIT unless ($next =~ /[0-9]/);

            $num .= $next;
            $x++;
        }
        # print "$num\n";
        # Now find if there is a symbol next to it
        my $numlen = length($num);
        my $part = 0;

        # Check above
        $part = check($x - $numlen, $x + 1, $y - 1, $num);
        # Check below
        $part += check($x - $numlen, $x + 1, $y + 1, $num);
        # Check to the right
        $part += check($x + 1, $x + 1, $y, $num);
        # And check to the left
        $part += check($x - $numlen, $x - $numlen, $y, $num);
    }
}

sub check
{
    my $xstart = shift;
    my $xend = shift;
    my $y = shift;
    my $num = shift;

    # Stay inbounds
    return 0 if ($y < 0);
    return 0 if ($y > $ymax);
    $xstart++ if ($xstart < 0);
    $xend = $xmax if ($xend > $xmax);

    foreach my $x ($xstart .. $xend)
    {
        my $sym = $grid[$y]->[$x];
        if ($sym =~ /\*/)
        {
            push(@{$cogs{"$x,$y"}}, $num);
        }
    }
    return 0;
}

foreach my $cog (keys %cogs)
{
    my @nums = @{$cogs{$cog}};
    if (@nums == 2)
    {
        $sum += $nums[0] * $nums[1];
    }
}

print "$sum\n";

#D(\@grid);


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
