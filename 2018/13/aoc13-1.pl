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
use Term::ANSIColor;

# Global variables
my %grid = ();
my @points = ();
my %collpoints = ();
my @dirs = qw/ ^ > v < /;
my $xmax = 0;
my $ymax = 0;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);

    my $y = 0;
    foreach my $line (@lines)
    {
        my $x = 0;
        foreach my $char (split(//, $line))
        {
            if ($char eq '>' or $char eq '<')
            {
                push(@points, [ $x, $y, $char, 0 ]);
                $collpoints{"$x,$y"} = 1;
                $char = '-';
            }
            elsif ($char eq 'v' or $char eq '^')
            {
                push(@points, [ $x, $y, $char, 0 ]);
                $collpoints{"$x,$y"} = 1;
                $char = '|';
            }
            $grid{"$x,$y"} = $char unless ($char eq ' ');

            $x++;
        }
        $xmax = $x if ($x > $xmax);
        $y++;
    }
    $ymax = $y - 1;
}

#D(\%grid);
#D(\@points);
#D(\%collpoints);
#paint(\%grid, \@points);
#print "\n\n";
#exit;

my $tick = 0;
TICK:
while (1)
{
    @points = sort { $a->[1] <=> $b->[1] or
                     $a->[0] <=> $b->[0] } @points;
    if (scalar keys %collpoints != scalar @points)
    {
        print "Error in number of points in collision check and pointlist\n";
    }
    my $i = 0;
    while ($i <= $#points)
    {
        my $point = $points[$i];
        my $dir = $point->[2];
        my $p0;
        my $x = $point->[0];
        my $y = $point->[1];
        if ($dir eq '>')
        {
            $p0 = ($x + 1) . ",$y";
            $point->[0]++;
        }
        elsif ($dir eq '<')
        {
            $p0 = ($x - 1) . ",$y";
            $point->[0]--;
        }
        elsif ($dir eq 'v')
        {
            $p0 = "$x," . ($y + 1);
            $point->[1]++;
        }
        elsif ($dir eq '^')
        {
            $p0 = "$x," . ($y - 1);
            $point->[1]--;
        }
        else
        {
            print "Illegal direction $dir, aborting\n";
            exit;
        }
#        print "Moving from $x,$y to $p0, dir $dir\n";

        if (!$grid{$p0})
        {
            print "Went outside of grid at $p0, what happened?\n";
            D($point);
            D(\%grid);
            exit;
        }
        if ($collpoints{$p0})
        {
            print "Collision at $p0\n";
#            D($point);
#            D(\@points);
#            paint(\%grid, \@points);
            exit;
        }
        delete($collpoints{"$x,$y"});
        $collpoints{$p0} = 1;
        if ($grid{$p0} !~ /[-|]/)
        {
#            print "Turning at $p0 (" . $grid{$p0} . ")\n";
            turn($point, $p0);
        }
        $i++;
    }
    $tick++;
#    print "Tick $tick done\n";
    #D(\@points);
    #D(\%collpoints);
    #paint(\%grid, \@points);
}

sub turn
{
    my $p = shift;
    my $p0 = shift;
    my $dir = $p->[2];
    my $phase = $p->[3];
    if ($grid{$p0} eq '/')
    {
        $p->[2] = '>' if ($dir eq '^');
        $p->[2] = '^' if ($dir eq '>');
        $p->[2] = '<' if ($dir eq 'v');
        $p->[2] = 'v' if ($dir eq '<');
    }
    elsif ($grid{$p0} eq '\\')
    {
        $p->[2] = '>' if ($dir eq 'v');
        $p->[2] = 'v' if ($dir eq '>');
        $p->[2] = '<' if ($dir eq '^');
        $p->[2] = '^' if ($dir eq '<');
    }
    elsif ($grid{$p0 } eq '+')
    {
        my $i = first_index { $_ eq $dir } @dirs;
        my $change = $phase - 1;
        $p->[2] = $dirs[($change + $i) % 4];
#        print "Previous phase: $phase dir $dir, ";
        $phase = ($phase + 1 ) % 3;
#        print "current phase: $phase dir " . $p->[2] . "\n";
        $p->[3] = $phase;
    }
    else
    {
        print "Huh? Wrong kind of turn at $p0 " . $grid{$p0} . "\n";
    }
}

sub paint
{
    my $gridref = shift;
    my $pointref = shift;
    my %gr = %{$gridref};
    my @p = @{$pointref};

    foreach my $point (@p)
    {
        my $x = $point->[0];
        my $y = $point->[1];
        my $dir = $point->[2];
        $gr{"$x,$y"} = colored($dir, 'bold');
    }
    foreach my $y (0..$ymax)
    {
        foreach my $x (0..$xmax)
        {
            if ($gr{"$x,$y"})
            {
                print $gr{"$x,$y"};
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
