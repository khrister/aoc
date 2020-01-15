#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum min/;
use List::MoreUtils 'first_index';
use Time::HiRes 'usleep';

# Global variables
my @lights = ();
my $time;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);

    foreach my $line (@lines)
    {
        $line =~ m/position=<([- 0-9]+[0-9]),([- 0-9]+[0-9])> velocity=<([- 0-9]+[0-9]),([- 0-9]+[0-9])/;
        my ($x, $y, $x0, $y0) = ($1, $2, $3, $4);
        $x =~ s/ +//;
        $y =~ s/ +//;
        $x0 =~ s/ +//;
        $y0 =~ s/ +//;
        push(@lights, [ $x, $y, $x0, $y0 ]);
    }
}

#D(\@lights);
#exit;
while (1)
{
    paint (@lights);
    foreach my $light (@lights)
    {
        $light->[0] += $light->[2];
        $light->[1] += $light->[3];
    }
    $time++;
    #usleep 200000;
}

sub paint
{
    my @points = @_;
    my %grid = ();
    my $xmax = my $ymax = 0;
    my $xmin = my $ymin = 1e10;
    foreach my $light (@points)
    {
        my $x = $light->[0];
        my $y = $light->[1];
        $grid{"$x,$y"} = "#";
        $xmax = $x if ($x > $xmax);
        $xmin = $x if ($x < $xmin);
        $ymax = $y if ($y > $ymax);
        $ymin = $y if ($y < $ymin);
    }
#    D(\%grid);
#    print "$xmin $xmax $ymin $ymax\n";
    return if (($xmax - $xmin) > 80);
    return if (($ymax - $ymin) > 80);
    print "time spent: $time\n\n";
    foreach my $y ($ymin..$ymax)
    {
        foreach my $x ($xmin..$xmax)
        {
            if ($grid{"$x,$y"})
            {
                print "#";
            }
            else
            {
                print " ";
            }
        }
        print "\n";
    }
}


#debug function
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
