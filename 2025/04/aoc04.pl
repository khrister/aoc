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

# Global variables
my @grid;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $y = 0;
    while (my $line = <$fh>)
    {
        chomp $line;
        my @l = split(//, $line);
        push(@grid, \@l);
    }
    close($fh);
}

my $width = scalar(@{$grid[0]});
my $height = @grid;

my $movable = 0;

for (my $x = 0; $x < $width; $x++)
{
 ROLL:
    for (my $y = 0; $y < $height; $y++)
    {
        # Are we a roll?
        next ROLL if ($grid[$y]->[$x] ne "@");

        # Time to check how many neighbours we have
        my $neighbours = 0;
        foreach my $x0 (-1, 0, 1)
        {
        Y0:
            foreach my $y0 (-1, 0, 1)
            {
                next if ($y0 == 0 and $x0 == 0);
                my $x1 = $x + $x0;
                my $y1 = $y + $y0;
                next Y0 if ($x1 < 0 or $x1 >= $width);
                next Y0 if ($y1 < 0 or $y1 >= $height);
                if ($grid[$y1]->[$x1] eq "@")
                {
                    $neighbours++;
                }
                next ROLL if ($neighbours >= 4);
            }
        }
        # say "$x, $y";
        $movable++;
    }
}

say $movable;

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
