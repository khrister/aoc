#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);

my @cmd = ();
my $in;
my $out;
my $err;
my $robot;
my %col_grid = ();
my %painted = ();
my $pos = "0,0";
my $dir = "U";
$SIG{PIPE} = "IGNORE";

my $file = shift @ARGV;


@cmd = ('./intcode.pl', $file);

# Starting panel is black
$in = "0\n";
# Start running the intcode computer
$robot = start (\@cmd, \$in, \$out);
# And feed the first input
#$robot->pump();

DONE:
while (1)
{
    my $col;
    my $turn;

    # Get color to paint
    # Wait for output to be two digits
    eval { $robot->pump() until ($out =~ /\d\n\d/ or !$robot->pumpable); };
    last DONE
        unless ($out);
    chomp $out;

    ($col,$turn) = split(/\n/, $out);
    $out = "";

    $painted{$pos} = 1;
    $col_grid{$pos} = $col;
    $dir = turn($dir, $turn);
    $pos = move($dir, $pos);
    $in = ($col_grid{$pos} || 0) . "\n";
}

print "Painted " . (scalar (keys %painted)) . "\n";

eval { $robot->finish() };


sub fetch
{

}

sub move
{
    my $d = shift;
    my $p = shift;
    my $x;
    my $y;
    ($x, $y) = split(/,/, $p);
    if ($d eq "U")
    {
        $y++;
    }
    elsif ($d eq "R")
    {
        $x++;
    }
    elsif ($d eq "D")
    {
        $y--;
    }
    elsif ($d eq "L")
    {
        $x--;
    }
    else
    {
        print "Broken direction $d\n";
    }
    return "$x,$y";
}

sub turn
{
    my $d = shift;
    my $t = shift;

    $t = -1 if ($t == 0);

    my $sdir = "URDL";
    my $i = index($sdir, $d);
    $i += $t;
    return substr($sdir, $i % 4, 1);
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
