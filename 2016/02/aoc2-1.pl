#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

my %move_it = (
    '1U' => 1,
    '1D' => 4,
    '1L' => 1,
    '1R' => 2,
    '2U' => 2,
    '2D' => 5,
    '2L' => 1,
    '2R' => 3,
    '3U' => 3,
    '3D' => 6,
    '3L' => 2,
    '3R' => 3,
    '4U' => 1,
    '4D' => 7,
    '4L' => 4,
    '4R' => 5,
    '5U' => 2,
    '5D' => 8,
    '5L' => 4,
    '5R' => 6,
    '6U' => 3,
    '6D' => 9,
    '6L' => 5,
    '6R' => 6,
    '7U' => 4,
    '7D' => 7,
    '7L' => 7,
    '7R' => 8,
    '8U' => 5,
    '8D' => 8,
    '8L' => 7,
    '8R' => 9,
    '9U' => 6,
    '9D' => 9,
    '9L' => 8,
    '9R' => 9
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
