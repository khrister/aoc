#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IO::Prompter;
use List::Util 'max';
use File::FindLib 'lib/Intcode.pm';
use Intcode;

my $niccode = "";
my @nics = ();
my @inqueue = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    $niccode = <$fh>;
    chomp $niccode;
    close ($fh);
}

# Start the nic code and initialize the in queues with -1
foreach my $nicno (0..49)
{
    $nics[$nicno] = Intcode->new({"program" => $niccode});
    $inqueue[$nicno] = [ -1 ];
}

# Loop forever until we find an answer
while (1)
{
    # Loop through the NICs one by one
    foreach my $nicno (0..49)
    {
        # Make sure we have some input
        if (! @{$inqueue[$nicno]} )
        {
            push(@{$inqueue[$nicno]}, -1);
        }

        # Run the NIC; collect the output
        my $out = $nics[$nicno]->run($nicno, @{$inqueue[$nicno]});

        # Handle the output
        while (@{$out})
        {
            my $addr = shift @{$out};
            my $x = shift @{$out};
            my $y = shift @{$out};

            # This is what we're looking for
            if ($addr == 255)
            {
                print "addr 255 found, y = $y\n";
                exit;
            }
            elsif ($addr > 50 or $addr < 0)
            {
                print "Buggy address: $addr\n";
            }
            else
            {
                push(@{$inqueue[$addr]}, $x, $y);
            }
        }
    }
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
