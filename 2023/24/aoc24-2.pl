#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index slide minmax);
#use Array::Utils qw(:all);
use Math::Combinatorics qw/combine/;

# Global variables
my @hailstones;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my ($x, $y, $z, $vx, $vy, $vz) = $line =~ m/(-?\d+)/g;
        push(@hailstones, [ $x, $y, $z, $vx, $vy, $vz ]);
    }
    close($fh);
}

# Intersection of two lines, adapted from code found on the Internet
sub intersect($$$$$$$$)
{
    my ($x1, $y1, $vx1, $vy1, $x2, $y2, $vx2, $vy2) = @_;
    my $denom = $vy2 * $vx1 - $vx2 * $vy1;
    if ($denom == 0)
    {
        return undef;
    }
    my $ua = ($vx2 * ($y1 - $y2) - $vy2 * ($x1 - $x2)) / $denom;
    my $ub = ($vx1 * ($y1 - $y2) - $vy1 * ($x1 - $x2)) / $denom;
    return $x1 + $ua * $vx1, $y1 + $ua * $vy1, $ua;
}

# Find the min and max velocity for each axis
my @minmaxes = map { my $col = $_;
                     [minmax map { $_->[$col] } @hailstones] } (3..5);

my $maxVelocity = max map { map { abs($_) } @$_ } @minmaxes;
print "Max velocity: $maxVelocity\n\n";

my @colnames = qw(x y z vx vy vz);
my @vcands;

foreach my $col (3..5)
{
    print "Examining $colnames[$col]...\n";
    my %positionForVelcity;
    push @{$positionForVelcity{$_->[$col]}}, $_->[$col-3] foreach @hailstones;
    my %candidates;
    my $count = 0;
    foreach my $vhail (keys %positionForVelcity)
    {
        my $posns = $positionForVelcity{$vhail};
        next if @$posns < 2;
        $count++;
        foreach my $vrock (-$maxVelocity..$maxVelocity)
        {
            slide
            {
                my $dist = $b - $a;
                my $denom = $vhail - $vrock;
                ++$candidates{$vrock}{$vhail} if $denom != 0 && $dist % $denom == 0;
            } sort { $a <=> $b } @$posns;
        }
    }
    my @candidates;
    foreach my $vrock (keys %candidates)
    {
        my $vhails = $candidates{$vrock};
        next if keys %$vhails < $count;
        push @candidates, $vrock;
    }
    print "- Candidates for rock velocity: ", join(", ", sort { $a <=> $b } @candidates), "\n";  
    push @vcands, \@candidates;
}

# Find two distinct hailstones with different velocities

# Hailstone A
my ($x1, $y1, $z1, $vx1, $vy1, $vz1) = @{shift @hailstones} or die;
my ($x2,$y2,$z2,$vx2,$vy2,$vz2);
while (1) {
    ($x2,$y2,$z2,$vx2,$vy2,$vz2) = @{shift @hailstones} or die; # Hailstone B
    last unless $vx1 == $vx2 || $vy1 == $vy2 || $vz1 == $vz2;
}

# Finds the point where the the rock needs to start to hit both hailstones,
# given a known velocity for the rock, returns undef if no solution
sub solve ($$$)
{
    my ($rvx, $rvy, $rvz) = @_;
    # Relative velocity of A to the rock
    my ($relX1,$relY1,$relZ1) = ($vx1-$rvx, $vy1-$rvy, $vz1-$rvz);
    my $tdelta = 0;
    my ($relX2,$relY2,$relZ2) = ($vx2-$rvx, $vy2-$rvy, $vz2-$rvz);
    my ($sx,$sy,$t1,$ignored1) = intersect($x1,$y1,$relX1,$relY1, $x2,$y2,$relX2,$relY2);
    my ($sxAlt,$sz,$t2,$ignored2) = intersect($x1,$z1,$relX1,$relZ1, $x2,$z2,$relX2,$relZ2);
    return undef unless defined $sx && defined $sxAlt && $sx == $sxAlt;
    die unless $t1 == $t2;
    return $sx, $sy, $sz;
}

print "\nTrying to find a solution...\n";
my ($sx,$sy,$sz,$t);
OUTER: foreach my $rvx (@{$vcands[0]})
{
    foreach my $rvy (@{$vcands[1]})
    {
        foreach my $rvz (@{$vcands[2]})
        {
            print "- Velocity $rvx, $rvy, $rvz... ";
            ($sx,$sy,$sz) = solve($rvx,$rvy,$rvz);
            last OUTER if (defined $sx);
            print "Nope!\n";
        }
    }
}

die "\nNo solution found\n" unless defined $sx;
print "Works!\n\n" if defined $sx;
print "Starting point: $sx, $sy, $sz\n";
print "Sum is ", $sx+$sy+$sz, "\n";

# Debug function
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

Copyright Christer Boräng 2023

=cut
