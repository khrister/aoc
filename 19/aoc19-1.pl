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

my %grid = ();

my $align = 0;

my $sq = 0;

my $file = shift @ARGV;

@cmd = ('./intcode.pl', $file);

$in = "";

foreach my $x (0..49)
{
    foreach my $y (0..49)
    {
        my $beam = get_status($x, $y);
        $grid{"$x,$y"} = $beam;
        $sq += $beam;
    }
}

# Paint
paint();

print "\n$sq\n";

# Done with the robot

sub get_status
{
    # find status
    my $x = shift;
    my $y = shift;
    my $robot;

    $robot = start (\@cmd, \$in, \$out);

    eval { $robot->pump()
               until ( $out =~ /^input:/ or !$robot->pumpable); };
    die("No input found")
        unless ($out);
    $out =~ s/^input://;
    $in = "$x\n";
    eval { $robot->pump()
               until ( $out =~ /^input:/ or !$robot->pumpable); };
    die ("No output from pump")
        unless ($out);
    $out =~ s/^input://;
    $in = "$y\n";
    eval { $robot->pump()
               until ( $out =~ /^[01]\n/ or !$robot->pumpable); };
    my $s = $out;
    $out = "";
    $s =~ s/\n//;
    $in = "";
#    print "status for $x,$y: $s\n";

    eval { $robot->finish() };
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
            print $gr{"$x,$y"};
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
