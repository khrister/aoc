#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw( pairwise );

# Other modules

# Global variables
my @input;
my @output;
my @origphase = (0, 1, 0, -1);
my $length;
my $max;
my $offset;

{
    my $fh;
    my $file = shift @ARGV;
    $max = shift @ARGV;
    chomp $max;
    open($fh, '<', $file)
        or die("Could not open $file: ");
    my $line = <$fh>;
    chomp $line;
    $offset = substr($line, 0, 7);
    @input = split(//, $line x 10000);
    $length = scalar @input;
    close $fh;
}

print "length $length\n";
print "offset $offset\n";

@input = @input[$offset..$length-1];

my @looplist = reverse ($offset..($length -1));

foreach my $p (0..($max-1))
{
    @output = ();
    my $res = 0;
#    print join("", @input[0..7]) . "\n";;
    foreach my $digit (@looplist)
    {
        $res += $input[$digit - $offset];
#        print "res = $res, digit = $digit\n";
#        sleep $p;
        push(@output, $res % 10);
    }
    @input = reverse @output;
#    print "Done $p phases, length = " . scalar @output . "\n";
}

my @done = @input[0..7];

print join("", @done) . "\n";

# Debug printouts
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
