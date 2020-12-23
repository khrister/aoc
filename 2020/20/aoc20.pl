#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (product);
#use List::MoreUtils qw (first_index);
#use Array::Utils qw(intersect);;

my %tiles = ();
my @corners = ();

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

    push(@sides, join("", @{$tile[0]}));
    push(@sides, join("", reverse(@{$tile[$#tile]})));
    foreach my $l (@tile)
    {
        push(@first, $l->[0]);
        push(@last, $l->[$#tile]);
    }
    push(@sides, join("", @last));
    push(@sides, join("", reverse(@first)));
    $tilesides{$key} = [@sides];
}

foreach my $key (keys %tilesides)
{
    my $matches = 0;
    foreach my $side (@{$tilesides{$key}})
    {
        my $r = reverse $side;
        foreach my $skey (keys %tilesides)
        {
            next if ($key eq $skey);
            my @s = @{$tilesides{$skey}};
            my $lmatch = grep { $r eq $_ or $side eq $_; } @s;
            $matches++ if ($lmatch);
            next if ($lmatch);
        }
    }
    push(@corners, $key) if ($matches == 2);
}

print "Product: " . product(@corners) . "\n";

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
