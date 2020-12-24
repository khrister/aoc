#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IO::Handle;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index any);
use Array::Utils qw (array_minus );

my @data;
my %seen = ();

STDOUT->autoflush(1);

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file) or die("Can't read $file");
    @data = <$fh>;
    chomp @data;
    close($fh);
}

foreach my $tile (@data)
{
    my $startx = 0;
    my $starty = 0;
    $tile =~ s/se/A/g;
    $tile =~ s/ne/B/g;
    $tile =~ s/nw/C/g;
    $tile =~ s/sw/D/g;
    my @moves = split(//, $tile);
    @moves = map { $_ =~ s/A/se/;
                   $_ =~ s/B/ne/;
                   $_ =~ s/C/nw/;
                   $_ =~ s/D/sw/;
                   $_;
               } @moves;
    my $ew = (grep { $_ eq "e" } @moves) - (grep { $_ eq "w" } @moves);
    my $nwse = (grep { $_ eq "nw" } @moves) - (grep { $_ eq "se" } @moves);
    my $swne = (grep { $_ eq "sw" } @moves) - (grep { $_ eq "ne" } @moves);
    while ($nwse > 0)
    {
        $ew--; $nwse--; $swne--;
    }
    while ($nwse != 0)
    {
        $ew++; $nwse++; $swne++;
    }
    $seen{"$ew,$swne"}++;
    $seen{"$ew,$swne"} %= 2;
}

foreach my $day (1..100)
{
    my %newseen = ();
    my @blacks = grep { $seen{$_} == 1 } keys %seen;
    # Check all black tiles, create adjacent if necessary
    foreach my $tile (@blacks)
    {
        my $bneighbours = 0;
        my ($ew, $swne) = split(/,/, $tile);
        # Check all dirs
        foreach my $ew0 (-1, 0, 1)
        {
            foreach my $swne0 (-1, 0, 1)
            {
                next if ($ew0 == 0 and $swne0 == 0);
                next if (abs($ew0 - $swne0) == 2);
                my $ew1 = $ew0 + $ew;
                my $swne1 = $swne0 + $swne;
                $seen{"$ew1,$swne1"} = 0 unless defined($seen{"$ew1,$swne1"});
                $bneighbours += $seen{"$ew1,$swne1"};
            }
        }
        if ($bneighbours == 0 or $bneighbours > 2)
        {
            $newseen{$tile} = 0;
        }
        else
        {
            $newseen{$tile} = 1;
        }
    }
    my @whites = grep { $seen{$_} == 0 } keys %seen;

    foreach my $tile (@whites)
    {
        my $bneighbours = 0;
        my ($ew, $swne) = split(/,/, $tile);
        # Check all dirs
        foreach my $ew0 (-1, 0, 1)
        {
        INNER:
            foreach my $swne0 (-1, 0, 1)
            {
                next INNER if ($ew0 == 0 and $swne0 == 0);
                next INNER if (abs($ew0 - $swne0) == 2);
                my $ew1 = $ew0 + $ew;
                my $swne1 = $swne0 + $swne;
                $seen{"$ew1,$swne1"} = 0 unless defined($seen{"$ew1,$swne1"});
                $bneighbours += $seen{"$ew1,$swne1"};
            }
        }
        if ($bneighbours == 2)
        {
            $newseen{$tile} = 1;
        }
        else
        {
            $newseen{$tile} = 0;
        }
    }

    %seen = %newseen;
    print "Day $day, " . (grep { $_ == 1 } values %seen) . "\n";
}
# Debug function
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
