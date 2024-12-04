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
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Array::Compare;

# Global variables
my @grid;
my $height;
my $width;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        push(@grid, [ split(//, $line) ]);
    }
    #D(\@grid);
    $width = @{$grid[0]};
    $height = @grid;

    my $sum_x = 0;
    my $sum_a = 0;
    foreach my $y (0 .. $#grid)
    {
        my $ylen;

    X:
        foreach my $x (0 .. ($width -1))
        {
            # Only check when X
            if ($grid[$y]->[$x] eq "X")
            {
                $sum_x += check_x($x, $y, -1, -1);
                $sum_x += check_x($x, $y, 0, -1);
                $sum_x += check_x($x, $y, 1, -1);
                $sum_x += check_x($x, $y, -1, 0);
                $sum_x += check_x($x, $y, 1, 0);
                $sum_x += check_x($x, $y, -1, 1);
                $sum_x += check_x($x, $y, 0, 1);
                $sum_x += check_x($x, $y, 1, 1);
            }
            elsif ($grid[$y]->[$x] eq "A")
            {
                $sum_a += check_a($x, $y);
            }
        }
    }
    say $sum_x;
    say $sum_a;
    close($fh);
}

sub check_x
{
    my $x = shift;
    my $y = shift;
    my $xdir = shift;
    my $ydir = shift;
    return 0 if ($x + 3*$xdir >= $width);
    return 0 if ($x + 3*$xdir < 0);
    return 0 if ($y + 3*$ydir >= $height);
    return 0 if ($y + 3*$ydir < 0);

    return 0 unless ($grid[$y + $ydir*1]->[$x + $xdir*1] eq "M");
    return 0 unless ($grid[$y + $ydir*2]->[$x + $xdir*2] eq "A");
    return 0 unless ($grid[$y + $ydir*3]->[$x + $xdir*3] eq "S");

#    say "$x,$y,$xdir,$ydir";
    return 1;
}

sub check_a
{
    my $x = shift;
    my $y = shift;
    return 0 if ($x + 1 >= $width);
    return 0 if ($x - 1 < 0);
    return 0 if ($y + 1 >= $height);
    return 0 if ($y - 1 < 0);

    my $nw = $grid[$y - 1]->[$x - 1];
    my $ne = $grid[$y - 1]->[$x + 1];
    my $sw = $grid[$y + 1]->[$x - 1];
    my $se = $grid[$y + 1]->[$x + 1];
    return 0 if ("$nw$ne$sw$se" =~ /[^MS]/);
    return 0 if ($nw eq $se or $ne eq $sw);
#    say "$x,$y,$xdir,$ydir";
    return 1;
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
