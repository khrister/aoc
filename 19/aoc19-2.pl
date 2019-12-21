#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IO::Prompter;
use List::Util 'max';
use File::FindLib 'lib/Intcode.pm';
use Intcode;

my %grid = ();
my %line_start_end = ();

my $sq = 0;
my $puzzlecode = "";

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    $puzzlecode = <$fh>;
    chomp $puzzlecode;
}

my $begin = shift;
my $end   = shift;
my $size  = shift;

my $first = 0;
my $last = 0;
my $found = 0;
my $runs;

Y:
foreach my $y ($begin..$end)
{
    my $lfirst = undef;
    my @range = ();

    if (!$first or $y < 100)
    {
        @range = 0..$end;
    }
    else
    {
        @range = ($first..($first +1), $last..($last + 2));
    }
    foreach my $x (@range)
    {
        my $ic = Intcode->new({"program" => $puzzlecode});
        my $beam = $ic->run($x,$y);
        $runs++;
        $ic->DESTROY();

        $grid{"$x,$y"} = $beam->[0] if ($beam->[0]);

        if (!defined($lfirst))
        {
            if ($beam->[0])
            {
                $first = $x;
                $lfirst = $x;
#                print "Line $y starts at $x    ";
                my $check = $line_start_end{$y - ($size - 1)};
                if (!$found and $check)
                {
                    my $x100s = $check->[0];
                    my $x100e = $check->[1];
                    if ($x + ($size - 1) <= $x100e)
                    {
                        print "Found start at ($x," . ($y - ($size - 1)) . ")\n";
                        print "s " . $check->[0] . ", " . $check->[1] . "\n";
                        $found = 1;
                    }
                }
            }
        }
        elsif ($beam->[0] == 0)
        {
            my $llast = $x - 1;
            $last = $x - 1;
            $line_start_end{$y} = [$lfirst, $llast];
#            print "Line $y goes from $lfirst to $last\n";
            next Y;
        }
    }
}

print "Runs: $runs\n";

# Paint
#paint();

#print "\n$sq\n";

# Done with the robot

sub paint
{
    my %gr = %grid;
    my $xmax = 0;
    my $ymax = $end;
    my $xmin;
    my $ymin = $begin;

    foreach my $p (keys %gr)
    {
        my $x;
        my $y;
        ($x,$y) = split(/,/, $p);

        $xmax = $x if ($x > $xmax);
        $xmin = $x if (!defined($xmin) or $x < $xmin);
    }

 PAINTY:
    foreach my $y ($ymin..$ymax)
    {
        my $started = 0;
        my $middle = 0;
        my $ended = 0;

    PAINTX:
        foreach my $x ($xmin..$xmax)
        {
            my $pix = $gr{"$x,$y"};
            if ($pix)
            {
                print $gr{"$x,$y"};
                $started = 1;
                if ($middle)
                {
                    $ended = 1;
                }
            }
            elsif ($y < 100)
            {
                print " ";
                next PAINTX;
            }
            elsif (!$started)
            {
                print " ";
            }
            elsif ($started and !$ended)
            {
                $middle = 1;
                print 1;
            }
            elsif ($ended)
            {
                print "\n";
                next PAINTY;
            }
            else
            {
                print "\n";
                next PAINTY;
            }

        }
        print "\n";
    }
}


sub D
{
    my $str = shift;
    print Dumper($str);
}

# Other modules

# Global variables


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
