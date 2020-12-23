#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index any);
use Array::Utils qw (array_minus );

$| = 1;

my @ring;
my $size = 1_000_000;
my ($curr, $prev);

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $data = <$fh>;
    chomp $data;
    foreach my $v (split(//, $data))
    {
        $v = int($v);  # Make the variables properly numbers
        $curr //= $v;  # Set $curr first time through

        $ring[$prev] = $v  if (defined $prev); # prev is undef first time
        $prev = $v;
    }

    # add in remaining cups:
    foreach my $i (10 .. $size)
    {
        $ring[$prev] = $i;
        $prev = $i;
    }
    $ring[$size] = $curr; # close the ring
    close($fh);
}

foreach my $t (1 .. 10_000_000)
{
    print "Turn: $t\r"  if ($t % 100000 == 0); # Progress!

    # Advance ptr marking cups (cup 0 doesn't exist, marked as "grabbed" too)
    my $ptr = $curr;
    my %grab = (0 => 1);
    foreach (1 .. 3)
    {
        $ptr = $ring[$ptr];
        $grab{$ptr} = 1;
    }

    # calculate destination, mod by $size + 1 (since 0 is still there)
    my $dest = $curr - 1;
    $dest = ($dest - 1) % ($size + 1)  while (exists $grab{$dest});

    # relink ring
    my $old = $ring[$curr];         # save ptr from curr to start of block
    $ring[$curr] = $ring[$ptr];     # link curr to after block
    $ring[$ptr]  = $ring[$dest];    # link last of block to after dest
    $ring[$dest] = $old;            # link dest to start of block

    $curr = $ring[$curr];
}

print "\n" . ($ring[1] * $ring[$ring[1]]) . "\n";

# Debug function
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
