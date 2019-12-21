#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use IO::Handle;

# Global variables
my $input;
my @layers = ();
my $width;
my $height;

STDOUT->autoflush(1);

if (@ARGV != 3)
{
    print "Usage: $0 file width height";
    exit;
}

{
    my $fh;
    my $file = shift @ARGV;
    $width = shift @ARGV;
    $height = shift @ARGV;
    open($fh, '<', $file) or die "Couldn't open file $file";
    $input = <$fh>;
    chomp $input;
    close $file;
}

split_layers($input);

my $min = 1000000000;
my $l;
foreach my $layer (@layers)
{
    my $zeros = find_zeros($layer);
    if ($zeros < $min)
    {
        $min = $zeros;
        $l = $layer;
    }
}

my $ones = (join("", @{$l}) =~ tr/1//);
my $twos = (join("", @{$l}) =~ tr/2//);

print "$ones * $twos = " . ($ones * $twos) . "\n";

sub find_zeros
{
    my $layer = shift;
    my @rows = @{$layer};
    return join("", @rows) =~ tr/0//;
}

sub split_layers
{
    my $data = shift;
    my $dsize = length($data);
    my $lsize = $width*$height;
    my $lindex = 0;

    while ($lindex < $dsize)
    {
        my $l = substr($data, $lindex, $lsize);
        my $lnum = $lindex / $lsize;
        my $rindex = 0;
        $layers[$lnum] = [];
        while ($rindex < $lsize)
        {
            my $r = substr($data, $lindex + $rindex, $width);
            push($layers[$lnum], $r);
            $rindex += $width;
        }
        $lindex += $lsize;
    }
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
