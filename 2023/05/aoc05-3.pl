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
use POSIX qw/floor ceil round/;

#
# Optimisering: Baklänges, från 0 och uppåt, testa med ett intervall X
# tills man hittar ett seed, sen gå tillbaka och testa mer exakt
#

# Global variables
my $location;
my @seeds;

my @soil_seed;
my @fert_soil;
my @water_fert;
my @light_water;
my @temp_light;
my @humid_temp;
my @loc_humid;
my $lowest = 999999999999999999999999999999;
my $range = $lowest;

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
        push(@soil_seed, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }
    <$fh>;

    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@fert_soil, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }
    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@water_fert, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@light_water, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@temp_light, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }

    <$fh>;
    while (($line = <$fh>) !~ m/^$/)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@humid_temp, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }

    <$fh>;
    while ($line = <$fh>)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my @tmp = split(" ", $line);
        push(@loc_humid, \@tmp);
        $range = $tmp[2] if ($tmp[2] < $range);
    }
    close($fh);
}

$range -= 2;
#$range = floor($range / 2);
my $loc = 0;
my $found = 0;

LOC:
while (1)
{
    my $seed = $loc;
 LOOKUP:
    foreach my $ref (\@loc_humid, \@humid_temp, \@temp_light,
                     \@light_water, \@water_fert, \@fert_soil, \@soil_seed)
    {
        my @list = @{$ref};
        foreach $ref (@list)
        {
            my $dest;
            my $src;
            my $range;
            ($src, $dest, $range) = @{$ref};
            if ($seed >= $src and $seed < $src + $range)
            {
                $seed += ($dest - $src);
                next LOOKUP;
            }
        }
    }
    my $valid = check_seed($seed);

    if ($valid)
    {
        $found = 1 if (!$found);
        $range = floor($range / 2);
        if ($range == 0)
        {
            print "Found the lowest location: $loc\n";
            exit;
        }
        $loc -= $range;
        next LOC;
    }
    else
    {
        $range += 1 if ($range == 0);
        $loc += $range;
    }
    exit if ($range == 0);
}

sub
check_seed
{
    my $check = shift;

    for(my $i = 0; $i < @seeds; $i += 2)
    {
        my $s = $seeds[$i];
        my $r = $seeds[$i + 1];
        if ($check >= $s and $check <= ($s + $r))
        {
            return 1;
        }
    }
    return 0;
}

#D(\@seeds);

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
