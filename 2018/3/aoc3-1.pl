#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;

# Global variables
my @claims = ();
my %grid = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    @claims = <$fh>;
    chomp(@claims);
    close ($fh);
}

foreach my $claim (@claims)
{
    my (undef, undef, $coords, $size) = split(/ /, $claim);
    $coords =~ tr/://d;
    my ($x0, $y0) = split(/,/, $coords);
    my ($xsize, $ysize) = split(/x/, $size);
    foreach my $x ($x0 .. $x0 + $xsize - 1)
    {
        foreach my $y ($y0 .. $y0 + $ysize - 1)
        {
            $grid{"$x,$y"}++;
        }
    }
}

print scalar grep { $_ > 1 } values %grid;
print "\n";

#debug function
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

Copyright Christer Boräng 2019

=cut
