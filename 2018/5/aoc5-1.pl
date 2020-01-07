#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum/;
use List::MoreUtils 'first_index';

# Global variables
my @polymer = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my $line = <$fh>;
    chomp($line);
    close ($fh);
    @polymer = split(//, $line);
}

#print "Start: " . (scalar @polymer) . "\n";

my $i = 0;
while ($i < $#polymer)
{
#    print $polymer[$i] . " : " . ord($polymer[$i]) . "\n";
    if (abs(ord($polymer[$i]) - ord($polymer[$i + 1])) == 32)
    {
        splice(@polymer, $i, 2);
#        print "Index $i, left: " . (scalar @polymer) . "\n";
        $i-- if ($i);
    }
    else
    {
        $i++;
    }
}

#D(\@polymer);

print "Left: " . (scalar @polymer) . "\n";

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
