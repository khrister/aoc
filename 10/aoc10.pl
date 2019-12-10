#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use IO::Handle;
use Math::Prime::Util::GMP qw(gcd);
use List::MoreUtils qw (first_index);
use Math::Trig;
use Math::Trig ':pi';

# Global variables
my $width;
my $height;
my %ast_at;
my %can_see;
my $debug = 0;

STDOUT->autoflush(1);


{
    my $fh;
    my $y = 0;
    my $file = shift @ARGV;
    open($fh, '<', $file) or die "Couldn't open file $file";
    while (my $input = <$fh>)
    {
        chomp $input;
        $width = length($input)
            unless ($width);

        my $x = 0;
        foreach my $point (split("", $input))
        {
            if ($point eq "#")
            {
                $ast_at{"$x:$y"} = 1;
            }
            $x++;
        }
        $y++;
    }
    close $file;
    $height = $y;
}

calc_visible();

my $max = 0;
my $pos = "";

foreach my $p (keys %can_see)
{
    my $no = scalar @{$can_see{$p}};
    if ($no > $max)
    {
        $max = $no;
        $pos = $p;
    }
}

while (1)
{
    destroy_visible($pos);
    calc_visible();
}

sub destroy_visible
{
    my $pos = shift;
    my $x;
    my $y;
    my $dest;

    print "Destroying from $pos\n";
    ($x, $y) = split(/:/, $pos);
    my %p = ();
    foreach my $pos0 (@{$can_see{$pos}})
    {
        my $x0;
        my $y0;
        ($x0, $y0) = split(/:/, $pos0);
        # $p{$pos0} = acos(($y - $y0)/sqrt(($x-$x0)**2 + ($y - $y0)**2));
        my $a = rad2deg(atan2($y0 - $y, $x0 - $x));
#        print $pos0 . " : " . $p{$pos0} . "\n";
        $a += 90;
        if ($a > 360)
        {
            $a -= 360;
        }
        elsif ($a < 0)
        {
            $a = 360 + $a;
        }
        $p{$pos0} = $a;

#        print $pos0 . " : $a\n";
    }
    my @sorted = sort { $p{$a} <=> $p{$b} } keys %p;

    foreach my $pos1 (@sorted)
    {
        delete $ast_at{$pos1};
        $dest++;
        if ($dest == 200)
        {
            print "200th asteroid: " . $pos1 . "\n";
        }
    }
    if (keys %ast_at == 1)
    {
        print "Last asteroid left: " . $sorted[$#sorted] . "\n";
        exit;
    }
    else 
    {
        #print "" . (keys %ast_at) . " keys left in \%ast_at\n";
    }

}

sub calc_visible
{
    %can_see = ();

    foreach my $y (0..($height - 1)) {
    POINT:
        foreach my $x (0..($width -1 )) {
            my $p = "$x:$y";
            next POINT
                unless ($ast_at{$p});
        TRY:
            foreach my $p0 (keys %ast_at) {
                next if ($p eq $p0);
                _debug("Trying $p to $p0");
                my $x0;
                my $y0;
                ($x0, $y0) = split(/:/, $p0);
                my $xdiff = $x0 - $x;
                my $ydiff = $y0 - $y;
                my $gcd = gcd ($xdiff, $ydiff);

                if ($xdiff == 0) {
                    foreach my $i (1..$ydiff) {
                        my $p1 = "$x:" . ($y+$i);

                        if ($ast_at{$p1}) {
                            pair($p, $p1);
                            next TRY;
                        }
                    }
                    next TRY;
                } elsif ($ydiff == 0) {
                    foreach my $i (1..$xdiff) {
                        my $p1 = "" . ($x+$i) . ":$y";
                        if ($ast_at{$p1}) {
                            pair($p, $p1);
                            next TRY;
                        }
                    }
                    next TRY;
                }
                #            next TRY
                #                if ($ydiff < 0);

                my $xdelta = $xdiff / $gcd;
                my $ydelta = $ydiff / $gcd;
                _debug("p $p, p0 $p0, xdelta $xdelta, ydelta $ydelta");
                foreach my $i (1..$gcd) {
                    my $x1 = $x + $i * $xdelta;
                    my $y1 = $y + $i * $ydelta;
                    my $p1 = "$x1:$y1";

                    _debug("p $p, p1 $p, p0 $p0");
                    if ($ast_at{$p1}) {
                        pair($p, $p1);
                        _debug("p $p, p1 $p1, p0 $p0");
                        next TRY;
                    }
                }
                next TRY;
            }
        }
    }
}

sub pair
{
    my $p = shift;
    my $p0 = shift;

    return if ($p eq $p0);
    _debug("Pairing $p $p0");

    if (!$can_see{$p})
    {
        $can_see{$p} = [ $p0 ];
    }
    elsif (grep(/^$p0$/, @{$can_see{$p}}))
    {
        return;
    }
    else
    {
        push($can_see{$p}, $p0);
    }
    if (!$can_see{$p0})
    {
        $can_see{$p0} = [ $p ];
    }
    elsif (grep(/^$p$/, @{$can_see{$p0}}))
    {
        return;
    }
    else
    {
        push($can_see{$p0}, $p);
    }
}

# Debug function
sub D
{
    my $str = shift;
    print Dumper($str);
}

sub _debug
{
    my $out = shift;
    say $out
        if ($debug);
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
