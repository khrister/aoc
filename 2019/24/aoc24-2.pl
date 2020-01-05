#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my %current = ();
my %coords = ();
my %priors = ();
my $extraplanes = 0;
my $minutes = 0;

{
    die "Usage: $0 <file> <minutes>" unless (@ARGV == 2);
    my $file = shift @ARGV;
    $minutes = shift;
    $extraplanes = $minutes / 2 + 2; # The bugs takes at least 2 minutes to
                                     # propagate to a new layer, so we need
                                     # about half the number on each side
    my @first = ();
    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        next unless ($line =~ /[.#]/);
        push(@first, [ split(//, $line) ] );
    }
    close($fh);
    $current{0} = \@first;
    $current{0}->[2]->[2] = '?';
    foreach my $plane (-$extraplanes..-1, 1..$extraplanes)
    {
        my @array = ();
        my @line = qw(. . . . .);
        foreach my $n (0..4)
        {
            my @a = @line;
            push(@array, \@a);
        }
        $array[2]->[2] = '?';
        $current{$plane} = \@array;
    }
    foreach my $plane (-$extraplanes..$extraplanes)
    {
        my $x = 0;
        my $y = 0;
        my @cur = @{$current{$plane}};
        foreach my $line (@cur)
        {
            $x = 0;
            foreach my $pixel (@{$line})
            {
                $coords{"$x,$y,$plane"} = $pixel;
                $x++;
            }
            $y++;
        }
        delete($coords{"2,2,$plane"});
    }
}

foreach my $count (1..$minutes)
{
    print "Tick $count\n";
    %current = tick(%current);
}

my $bugs = 0;
foreach my $plane (keys %current)
{
    foreach my $line (@{$current{$plane}})
    {
        foreach my $cell (@{$line})
        {
            $bugs ++ if ($cell eq "#");
        }
    }
}

print "Number of bugs: $bugs\n";

sub tick
{
    my %universe = @_;
    my %new = ();
    #D(\%universe);
    foreach my $z (keys %universe)
    {
        my @cur = @{$universe{$z}};
        $new{$z} = [];
        my $x = 0;
        my $y = 0;

        foreach my $line (@cur)
        {
            $new{$z}->[$y] = [];
            $x = 0;
            foreach my $pixel (@{$line})
            {
                my $neighbours = 0;
                foreach my $dir (dirs($x, $y, $z))
                {
                    if ($coords{$dir} and $coords{$dir} eq '#')
                    {
                        $neighbours++;
                    }
                }
                if ($pixel eq "." and ($neighbours == 1 or $neighbours == 2))
                {
                    #print "Bug born!\n";
                    $new{$z}->[$y]->[$x] = "#";
                }
                elsif ($pixel eq "#" and $neighbours != 1)
                {
                    #print "Bug died!\n";
                    $new{$z}->[$y]->[$x] = ".";
                }
                else
                {
                    $new{$z}->[$y]->[$x] = $pixel;
                }
                $x++;
            }
            $y++;
        }
    }
    foreach my $c (keys %coords)
    {
        my $x;
        my $y;
        my $z;
        ($x, $y, $z) = split(/,/, $c);
        $coords{$c} = $new{$z}->[$y]->[$x];
    }
    return %new;
}

sub mkstring
{
    my %in = @_;
    my $res = "";
    D(\%in);
    foreach my $plane (keys %in)
    {
        foreach my $line (@{$in{$plane}})
        {
            $res .= join("", @{$line}) . "\n";
        }
    }
    return $res;
}

sub paint
{
    my @arr = @_;
    print mkstring(@arr);
}

sub dirs
{
    my $x = shift;
    my $y = shift;
    my $z = shift;
    my @res = ();
    my $xp = $x + 1;
    my $xm = $x - 1;
    my $yp = $y + 1;
    my $ym = $y - 1;
    my $zp = $z + 1;
    my $zm = $z - 1;

    push(@res, "$xm,$y,$z", "$xp,$y,$z", "$x,$ym,$z", "$x,$yp,$z");
    if ($x == 0)
    {
        push(@res, "1,2,$zm");
    }
    if ($x == 4)
    {
        push(@res, "3,2,$zm");
    }
    if ($y == 0)
    {
        push(@res, "2,1,$zm");
    }
    if ($y == 4)
    {
        push(@res, "2,3,$zm");
    }
    if ($x == 1 and $y == 2)
    {
        foreach my $p (0..4)
        {
            push(@res, "0,$p,$zp");
        }
    }
    if ($x == 3 and $y == 2)
    {
        foreach my $p (0..4)
        {
            push(@res, "4,$p,$zp");
        }
    }
    if ($x == 2 and $y == 1)
    {
        foreach my $p (0..4)
        {
            push(@res, "$p,0,$zp");
        }
    }
    if ($x == 2 and $y == 3)
    {
        foreach my $p (0..4)
        {
            push(@res, "$p,4,$zp");
        }
    }
    return @res;
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
