#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my $card_public;
my $card_loop;
my $door_public;
my $door_loop;

my $mod = 20201227;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    $card_public = <$fh>;
    chomp $card_public;
    $door_public = <$fh>;
    chomp $door_public;
    close($fh);
}

$card_loop = find_loop_number($card_public);
$door_loop = find_loop_number($door_public);

print "$card_loop $door_loop\n";

print "" . transform($card_public, $door_loop) . " : " .
    transform($door_public, $card_loop) . "\n";
sub transform
{
    my $subj = shift;
    my $loop = shift;
    my $key = 1;
    foreach (1 .. $loop)
    {
        $key *= $subj;
        $key %= $mod;
    }
    return $key;
}

sub find_loop_number
{
    my $pub = shift;
    my $tmp = 1;
    my $loop = 0;
    while ($tmp != $pub)
    {
        $tmp *= 7;
        $tmp %= $mod;
        $loop++;
    }
    return $loop;
}

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
