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
my @groups;
my $total = 0;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;
    local $/ = "\n\n";
    open($fh, '<', $file) or die "Couldn't open file $file";

    while (my $input = <$fh>)
    {
        push(@groups, $input);
    }
    close $file;
}

foreach my $gr (@groups)
{
    my %question;
    my $gsize;
    foreach my $p (split(/\n/, $gr))
    {
        foreach my $ans (split(//, $p))
        {
            $question{$ans}++;
        }
        $gsize++;
    }
    my $tmp = grep { $_ eq $gsize } values %question;
    $total += $tmp;
}

print "Total: $total\n";

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
