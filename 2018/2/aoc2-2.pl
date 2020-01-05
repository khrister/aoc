#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
use Text::Fuzzy;

# Global variables
my @boxes = ();
my $twos = 0;
my $threes = 0;


{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    @boxes = <$fh>;
    chomp(@boxes);
    close ($fh);
}

foreach my $i (0 .. $#boxes - 1)
{
    my $tf = Text::Fuzzy->new($boxes[$i]);
#    print $boxes[$i] . "\n";
    foreach my $j ($i + 1 .. $#boxes)
    {
        my $dist = $tf->distance($boxes[$j]);
        if ($dist == 1)
        {
            my @a = split(//, $boxes[$i]);
            my @b = split(//, $boxes[$j]);

            foreach my $k (0..$#a)
            {
                print $a[$k] if ($a[$k] eq $b[$k]);
            }
            print "\n";
            exit;
        }
    }
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
