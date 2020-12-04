#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;

# Global variables
my @records;
my @mandatory_fields = qw( byr iyr eyr hgt hcl ecl pid );
my @optional_fields = qw( cid );
my $total_valid = 0;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;
    local $/ = "\n\n";

    open($fh, '<', $file) or die "Couldn't open file $file";

    while (my $input = <$fh>)
    {
        $input =~ tr/\n/ /;
        chop $input;
        push(@records, $input);
    }
    close $file;
}

foreach my $record (@records)
{
    my @fields = split(/ /, $record);
    my %value_of;
 FIELDS:
    foreach my $field (@fields)
    {
        my ($k, $v) = split(/:/, $field);
        next FIELD unless $v;

        $value_of{$k} = $v;
    }
    $total_valid += check_valid(\%value_of);
}

print "Total valid records: $total_valid\n";

sub
check_valid
{
    my $tmp = 
    my %record = %{shift()};
    foreach my $f (@mandatory_fields)
    {
        return 0 unless ($record{$f});
    }
    # Check if the years are within range
    return 0 if ($record{"byr"} < 1920 or $record{"byr"} > 2002);
    return 0 if ($record{"iyr"} < 2010 or $record{"iyr"} > 2020);
    return 0 if ($record{"eyr"} < 2020 or $record{"eyr"} > 2030);

    # Check height
    my $hgt = $record{"hgt"};
    if ($hgt =~ /cm/)
    {
        $hgt = substr($hgt, 0, -2);
        return 0 if ($hgt < 150 or $hgt > 193);
    }
    elsif ($hgt =~ /in/)
    {
        $hgt = substr($hgt, 0, -2);
        return 0 if ($hgt < 59 or $hgt > 76);
    }
    else
    {
        return 0;
    }

    # Check hair color
    return 0 if ($record{"hcl"} !~ m/^#[0-9a-f]{6}$/);

    # Check eye color
    return 0 if ($record{"ecl"} !~ m/^(amb|blu|brn|gry|grn|hzl|oth)$/);

    # Check passprd id
    return 0 if ($record{"pid"} !~ m/^[0-9]{9}$/);

    # NOW it's valid.
    return 1;
}

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

Copyright Christer Boräng 2019

=cut
