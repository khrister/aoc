#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);
use IO::Prompter;
use List::Util 'max';

my @cmd = ();
my $in;
my $out;
my $err;
$SIG{PIPE} = "IGNORE";

my $robot;

my %grid = ();

my $align = 0;


my $file = shift @ARGV;

@cmd = ('./intcode.pl', $file);

$in = "";

#Run the robot
$robot = start (\@cmd, \$in, \$out);

$robot->pump() until ( !$robot->pumpable);

parse();

#D(\%grid);

# Paint
paint();

print "Alignment: $align\n";

# Done with the robot
eval { $robot->finish() };


sub parse
{
    my $row = 0;
    my $col = 0;

 ROW:
    foreach my $cmd (split(/\n/, $out))
    {
#        print "$cmd\n";
        if ($cmd =~ /10/)
        {
           $row++;
            $col = 0;
            next ROW;
        }
#        print "$row,$col\n";
        $grid{"$row,$col"} = $cmd;
        $col++
    }
}

sub get_status
{
    # find status
    my $s = shift;
    eval { $robot->pump()
               until ( $out =~ /^input:/ or !$robot->pumpable); };
    die("No input found")
        unless ($out);
    $out =~ s/^input://;
    $in = "$s\n";
    eval { $robot->pump()
               until ( $out =~ /^\d\n/ or !$robot->pumpable); };
    die ("No output from pump")
        unless ($out);
    ($s, $out) = split(/\n/, $out, 2);
    return $s;
}

sub paint
{
    my %gr = %grid;
    my $xmax = 0;
    my $ymax = 0;

    foreach my $p (keys %gr)
    {
        my $x;
        my $y;
        ($x,$y) = split(/,/, $p);

        $xmax = $x if ($x > $xmax);
        $ymax = $y if ($y > $ymax);
    }

    foreach my $y (0..$ymax)
    {
        foreach my $x (0..$xmax)
        {
            my $intersection = 0;
            my $up = "$x," . ($y-1);
            my $down = "$x," .($y+1);
            my $left = ($x-1) . ",$y";
            my $right = ($x+1) . ",$y";

            if ($x and $gr{$left} != 46)
            {
                $intersection++;
            }
            if ($x < $xmax and $gr{$right} != 46)
            {

                $intersection++;
            }
            if ($y and $gr{$up} != 46)
            {

                $intersection++;
            }
            if ($y < $ymax and $gr{$down} != 46)
            {

                $intersection++;
            }
            my $pixel;
#            print STDERR $intersection;
            if ($intersection > 2 and $gr{"$x,$y"} != 46)
            {
                $pixel = "o";
                $align += $x * $y;
            }
            else
            {
                $pixel = chr($gr{"$x,$y"});
            }
            print $pixel;
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

Copyright Christer Boräng 2011

=cut
