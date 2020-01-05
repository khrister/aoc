#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
# Global variables
my $freq = 0;
my %freqs = (0 => 1);
my @changes = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    @changes = <$fh>;
    chomp(@changes);
    close ($fh);
}

while (1)
{
    foreach my $change (@changes)
    {
        $freq += $change;
        if ($freqs{$freq})
        {
            print "Frequency $freq found twice\n";
            exit;
        }
        $freqs{$freq} = 1;
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
