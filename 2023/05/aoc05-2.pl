#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum min);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

#
# Optimisering: Baklänges, från 0 och uppåt, testa med ett intervall X
# tills man hittar ett seed, sen gå tillbaka och testa mer exakt
#

# Global variables
my $location;
my @seeds;

my @seed_soil;
my @soil_fert;
my @fert_water;
my @water_light;
my @light_temp;
my @temp_humid;
my @humid_loc;
my $lowest = 999999999999999999999999999999;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    my $line = <$fh>;
    chomp $line;
    (undef, @seeds) = split(" ", $line);
    <$fh>;
    <$fh>;

    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@seed_soil, \@tmp);
    }
    <$fh>;

    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@soil_fert, \@tmp);
    }
    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@fert_water, \@tmp);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@water_light, \@tmp);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@light_temp, \@tmp);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@temp_humid, \@tmp);
    }

    <$fh>;
    while ($line = <$fh>)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@humid_loc, \@tmp);
    }
    close($fh);
}

SEED:
for (my $i = 0; $i < @seeds; $i +=2 )
{
    my $tmp;
    my $seedstart = $seeds[$i];
    my $range = $seeds[$i+1];

    foreach my $seed ($seedstart .. ($seedstart + $range - 1))
    {
    LOOKUP:
        foreach my $ref (\@seed_soil, \@soil_fert, \@fert_water, \@water_light,
                         \@light_temp, \@temp_humid, \@humid_loc)
        {
            my @list = @{$ref};
            foreach $ref (@list)
            {
                my $dest;
                my $src;
                my $range;
                ($dest, $src, $range) = @{$ref};
                if ($seed >= $src and $seed < $src + $range)
                {
                    $seed += ($dest - $src);
                    next LOOKUP;
                }
            }
        }
        $lowest = $seed if ($seed < $lowest);
        print "...\n" if ($seed % 1000000 == 0);
    }
    print "Seed index done: $i\n";
}

#D(\@seeds);

print "$lowest" . "\n";

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
