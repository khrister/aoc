#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( sum );
use Algorithm::Permute qw/permute/;

my $str;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    $str = <$fh>;
    chomp $str;
    close($fh);
}

PASS:
while (1)
{
    $str++;
    next if ($str =~ /[iol]/);
    next unless ($str =~ /(.)\1.*(.)\2/);

    my @chars = split(//, $str);
    my $match;

 CHAR:
    foreach my $i (0..5)
    {
        my $c0 = $chars[$i];
        my $c1 = $chars[$i + 1];
        my $c2 = $chars[$i + 2];
        $c0++; $c0++;
        $c1++;

        next CHAR if ($c0 ne $c1 or $c0 ne $c2);
        $match = 1;
    }
#    print "$str\n";
    print "password: $str\n" if ($match);
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
