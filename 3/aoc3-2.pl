#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
use Data::Dumper;
use List::MoreUtils qw (first_index);

# Global variables

my %wire1;
my %wire2;
my $wpath1;
my $wpath2;
my @path1;
my @path2;

{
    my @reflist;

    $wpath1 = <>;
    chomp $wpath1;
    @reflist = get_coords($wpath1);
    %wire1 = %{$reflist[0]};
    @path1 = @{$reflist[1]};

    $wpath2 = <>;
    chomp($wpath2);
    @reflist = get_coords($wpath2);
    %wire2 = %{$reflist[0]};
    @path2 = @{$reflist[1]};
}

sub get_coords
{
    my $tmp = shift;
    my %res;
    chomp $tmp;
    my @keys = split(/,/, $tmp);
    my $x = 0; my $y = 0;
    my @path;

    foreach my $move (@keys)
    {
        my $dir = substr($move, 0, 1);
        my $len = substr($move, 1);
        my $curx = $x;
        my $cury = $y;
        if ($dir eq 'D')
        {
            while ($y > ($cury - $len))
            {
                $y--;
                $res{"$x,$y"} = 1;
                push(@path, "$x,$y");
            }
        }
        elsif ($dir eq 'U')
        {
            while ($y < $cury + $len)
            {
                $y++;
                $res{"$x,$y"} = 1;
                push(@path, "$x,$y");
            }
        }
        elsif ($dir eq 'L')
        {
            while ($x > $curx - $len)
            {
                $x--;
                $res{"$x,$y"} = 1;
                push(@path, "$x,$y");
            }
        }
        elsif ($dir eq 'R')
        {
            while ($x < ($curx + $len))
            {
                $x++;
                $res{"$x,$y"} = 1;
                push(@path, "$x,$y");
            }
        }
        else
        {
            print "Error: dir = $dir\n";
        }
    }
    return (\%res, \@path);
}

my $min = 0;
foreach my $p (keys %wire1)
{
    next unless ($wire2{$p});
    my $x; my $y;
    ($x, $y) = split(/,/, $p);

    my $dist = pathlen("$x,$y");
    $min = $dist if ($dist < $min or $min == 0);
}

sub pathlen
{
    my $coord = shift;
    my $a = first_index { $_ eq $coord } @path1;
    my $b = first_index { $_ eq $coord } @path2;
    print "$a + $b = " . ($a+$b) . "\n";
    # Add 2 since index 0 is step 1
    return $a+$b+2;
}
print "Min distance: $min\n";


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
