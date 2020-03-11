#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

my %move_it = (
    '1U' => 1,
    '1D' => 3,
    '1L' => 1,
    '1R' => 1,
    '2U' => 2,
    '2D' => 6,
    '2L' => 2,
    '2R' => 3,
    '3U' => 1,
    '3D' => 7,
    '3L' => 2,
    '3R' => 4,
    '4U' => 4,
    '4D' => 8,
    '4L' => 3,
    '4R' => 4,
    '5U' => 5,
    '5D' => 5,
    '5L' => 5,
    '5R' => 6,
    '6U' => 2,
    '6D' => 'A',
    '6L' => 5,
    '6R' => 7,
    '7U' => 3,
    '7D' => 'B',
    '7L' => 6,
    '7R' => 8,
    '8U' => 4,
    '8D' => 'C',
    '8L' => 7,
    '8R' => 9,
    '9U' => 9,
    '9D' => 9,
    '9L' => 8,
    '9R' => 9,
    'AU' => 6,
    'AD' => 'A',
    'AL' => 'A',
    'AR' => 'B',
    'BU' => 7,
    'BD' => 'D',
    'BL' => 'A',
    'BR' => 'C',
    'CU' => 8,
    'CD' => 'C',
    'CL' => 'B',
    'CR' => 'C',
    'DU' => 'B',
    'DD' => 'D',
    'DL' => 'D',
    'DR' => 'D',
   );

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    my @lines = <$fh>;
    close($fh);

    chomp @lines;
    # Start at the 5 button
    my $cur = 5;

    foreach my $line (@lines)
    {
        foreach my $move (split(//, $line))
        {
            $cur = $move_it{"$cur$move"};
        }
        print "$cur";
    }
    print "\n";
}

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
