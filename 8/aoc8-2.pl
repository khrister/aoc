#!/bin/env perl
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

my $image = compute_image(@layers);
$image =~ tr/0/ /;
$image =~tr/1/X/;
print "$image";

sub compute_image
{
    my @ls = shift;
    my $lsize = $width*$height;
    my $lnum = length($input)/$lsize;
    my $res = "";
    foreach my $row (0..$height-1)
    {
        $res .= check_row($row) . "\n";
    }
    return $res;
}

sub check_row
{
    my $rownum = shift;
    my $row = "";
    foreach my $col (0..($width-1))
    {
        $row .= check_pixel($rownum, $col);
    }
    return $row;
}

sub check_pixel
{
    my $rownum = shift;
    my $col = shift;
    my $lnum = length($input) / ($width * $height);

    foreach my $l (0..($lnum-1))
    {
        my $pix = $layers[$l]->[$rownum]->[$col];
        next if ($pix == 2);
        return $pix;
    }

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
            my @r = split("", substr($data, $lindex + $rindex, $width));
            push($layers[$lnum], [ @r ] );
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
