#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use POSIX qw/floor ceil round/;
# Global variables
my $time;
my $record;
my $wins = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    my $line = <$fh>;
    chomp $line;
    $line =~ s/ //g;
    (undef, $time) = split(":", $line);

    $line = <$fh>;
    chomp $line;
    $line =~ s/ //g;
    (undef, $record) = split(":", $line);

    close($fh);
}

my $low = floor($time/2);
my $x = floor($time/4);

while (1)
{
    my $res = $low * ($time - $low);
    if ($x < 1)
    {
        if ($res < $record)
        {
            $x = 1;
        }
        else
        {
            last;
        }
    }
    if ($res > $record)
    {
        $low -= $x;
        $x = floor($x/2);
    }
    else
    {
        $low += $x;
        $x = floor($x/2);
    }
}
my $high = floor($time/2);
$x = floor($time/4);

while (1)
{
    my $res = $high * ($time - $high);
    if ($x < 1)
    {
        if ($res < $record)
        {
            $x = 1;
        }
        else
        {
            last;
        }
    }
    if ($res > $record)
    {
        $high += $x;
        $x = floor($x/2);
    }
    else
    {
        $high -= $x;
        $x = floor($x/2);
    }
}

print "" . ($high - $low + 1) . "\n";


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

Copyright Christer Boräng 2023

=cut
