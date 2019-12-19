#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);
use IO::Prompter;

my @cmd = ();
my $in;
my $out;
my $err;
my $arcade;
$SIG{PIPE} = "IGNORE";
my $width = 0;
my $height = 0;
my %grid = ();
my @sprites = (" ", "+", "=", "-", "o");
my $startmoves;

my $file = shift @ARGV;


@cmd = ('./intcode.pl', $file);

#Run the arcade
$arcade = start (\@cmd, \$in, \$out);

$arcade->pump();
#print "$out\n";


open(my $dirfh, '<', 'testdirs.txt');
$startmoves = do { local $/; <$dirfh>; };
close($dirfh);
$startmoves =~ tr/\n//d;
open($dirfh, '>>', 'testdirs.txt');

DONE:
while (1)
{
 SCR:
    while (1)
    {
        # Get pixel
        # Wait for $out to have three lines of output
        eval { $arcade->pump() until (
            $out =~ /^-?\d+\n\d+\n\d+/ or
                $out =~ /input:/ or !$arcade->pumpable); };
        last DONE
            unless ($out);

        while ($out =~ /^-?\d+\n-?\d+\n-?\d+\n/)
        {
            my $x;
            my $y;
            my $type;
            my $tmp;
            ($x, $y, $type, $out) = split(/\n/, $out, 4);

            $grid{"$x,$y"} = $type;
        }
        if ($out =~ /^input:/)
        {
            my $dir;
            paint();
            if (length $startmoves)
            {
                ($dir, $startmoves) = split(//, $startmoves, 2);
                chomp $startmoves;
            }
            else
            {
                $dir = prompt('-sk', "(z) left, (x) stay, (c) right:");
                print $dirfh "$dir";
            }
            if ($dir eq "z")
            {
                $in = "-1\n";
            }
            elsif ($dir eq "x")
            {
                $in = "0\n";
            }
            elsif ($dir eq "c")
            {
                $in = "1\n";
            }
            $out =~ s/^input://;
            last SCR;
        }
    }
}
close($dirfh);

eval { $arcade->finish() };

paint();

sub paint
{
    foreach my $p (keys %grid)
    {
        my $x;
        my $y;
        ($x,$y) = split(/,/, $p);

        $width = $x if ($x > $width);
        $height = $y if ($y > $height);
    }

    foreach my $y (0..$height)
    {
        foreach my $x (0..$width)
        {
            my $pixel = $grid{"$x,$y"};
            if (!$pixel)
            {
                print " ";
            }
            else
            {
                print $sprites[$pixel];
            }
        }
        print "\n";
    }
    print $grid{"-1,0"} . "\n";
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
