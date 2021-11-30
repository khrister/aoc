#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (product);
use List::MoreUtils qw (first_index);
#use Array::Utils qw(intersect);;

my %tiles = ();
my %tile_connections = ();
my $start_corner;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    my @lines = <$fh>;
    my @current = ();
    my $tile;
    foreach my $line (@lines)
    {
        chomp $line;
        if ($line =~ /Tile ([0-9]+):/)
        {
            $tile = $1;
            @current = ();
        }
        elsif ($line =~ /[#.]+/)
        {
            push(@current, [ split(//, $line) ] );
        }
        else
        {
            $tiles{$tile} = [ @current ];
        }
    }
    $tiles{$tile} = [ @current ];
    close($fh);
}

# Make hash of tiles and their sides.
my %tilesides = ();

foreach my $key (keys %tiles)
{
    my @tile = @{$tiles{$key}};
    my @sides;
    my @first;
    my @last;

    foreach my $l (@tile)
    {
        push(@first, $l->[0]);
        push(@last, $l->[$#tile]);
    }
    push(@sides, join("", @{$tile[0]}));                # side 0 "up"
    push(@sides, join("", @last));                      # side 1 "right"
    push(@sides, join("", reverse(@{$tile[$#tile]})));  # side 2 "down"
    push(@sides, join("", reverse(@first)));            # side 3 "left"
    $tilesides{$key} = [@sides];
}

foreach my $key (keys %tilesides)
{
    my $idx = 0;
    foreach my $side (@{$tilesides{$key}})
    {
        my $r = reverse $side;
        foreach my $skey (keys %tilesides)
        {
            next if ($key eq $skey);
            my @s = @{$tilesides{$skey}};
            my $match = grep { $side eq $_ } @s;
            my $rmatch = grep { $r eq $_ } @s;
            next unless ($rmatch or $match);

            my $mirror = 0;
            if ($rmatch)
            {
                $mirror = 1;
            }
            push(@{$tile_connections{$key}}, [ $skey, $idx, $mirror ]);
        }
        $idx++;
    }
    if (@{$tile_connections{$key}} == 2)
    {
        $start_corner = $key;
    }
}

D(\%tilesides);
D(\%tile_connections);

print "$start_corner\n";



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
