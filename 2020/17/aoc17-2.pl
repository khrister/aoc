#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max min);
use List::MoreUtils qw (first_index);
use Memoize;

memoize('dirs');

my %coords = ();
my $cycles = 0;

{
    die "Usage: $0 <file> <cycles>" unless (@ARGV == 2);
    my $file = shift @ARGV;
    $cycles = shift (@ARGV);
    my @current = ();

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        next unless ($line =~ /[.#]/);
        push(@{$current[0]}, [ split(//, $line) ] );
    }
    close($fh);

    my $x = 0;
    my $y = 0;
    my $z = 0;
    my $w = 0;
    foreach my $line (@{$current[0]})
    {
        $x = 0;
        foreach my $pixel (@{$line})
        {
            $coords{"$x,$y,$z,$w"} = $pixel;
            $x++;
        }
        $y++;
    }

    my $xmin = -$cycles;
    my $ymin = -$cycles;
    my $zmin = -$cycles;
    my $wmin = -$cycles;
    my $xmax = $x + $cycles;
    my $ymax = $y + $cycles;
    my $zmax = $cycles;
    my $wmax = $cycles;
    foreach my $z ($zmin .. $zmax)
    {
        foreach my $y ($ymin .. $ymax)
        {
            foreach my $x ($xmin .. $xmax)
            {
                foreach my $w ($wmin .. $wmax)
                {
                    next if ($coords{"$x,$y,$z,$w"});
                    $coords{"$x,$y,$z,$w"} = ".";
                }
            }
        }
    }
}

foreach my $t (1..$cycles)
{
    %coords = tick(\%coords);
    print "Tick\n";
}

my $cubes = grep { $_ eq "#" } values(%coords);

print "Cubes: $cubes\n";

sub tick
{
    my %cur = %{shift()};
    my %new = ();

 CUBE:
    foreach my $cube (keys %cur)
    {
        my ($x,$y,$z,$w) = split(/,/, $cube);
        my $neighbours = 0;

        foreach my $n (dirs($x, $y, $z, $w))
        {
            next if (! $cur{$n});
            $neighbours++ if ($cur{$n} eq "#");
        }
        my $active = 0;
        if ($cur{$cube} eq "#")
        {
            if ($neighbours == 2 or $neighbours == 3)
            {
                $active = 1;
            }
        }
        else
        {
            if ($neighbours == 3)
            {
                $active = 1;
            }
        }
        if ($active)
        {
            $new{$cube} = "#";
        }
        else
        {
            $new{$cube} = ".";
        }
    }
    return %new
}

sub dirs
{
    my $x = shift;
    my $y = shift;
    my $z = shift;
    my $w = shift;

    my @dirs = ();

    foreach my $z0 (-1, 0, 1)
    {
        foreach my $y0 (-1, 0, 1)
        {
            foreach my $x0 (-1, 0, 1)
            {
                foreach my $w0 (-1, 0, 1)
                {
                    next if ($x0 == 0 and $y0 == 0 and $z0 == 0 and $w0 == 0);
                    my $x1 = $x + $x0;
                    my $y1 = $y + $y0;
                    my $z1 = $z + $z0;
                    my $w1 = $w + $w0;
                    push(@dirs, "$x1,$y1,$z1,$w1");
                }
            }
        }
    }
    return @dirs;
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
