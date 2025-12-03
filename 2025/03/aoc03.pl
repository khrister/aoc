#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my $output = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        next if $line =~ /^$/;
        my @nums = split(//, $line);
        my $max1 = 0;
        my $max2 = 0;

        my $maxidx = find_max(@nums);

        if ($maxidx == $#nums)
        {
            $max2 = $nums[$maxidx];
            pop @nums;
            $maxidx = find_max(@nums);
            $max1 = $nums[$maxidx];
        }
        else
        {
            $max1 = $nums[$maxidx];
            splice(@nums, 0, $maxidx + 1);
            $maxidx = find_max(@nums);
            $max2 = $nums[$maxidx];
        }
        $output += $max1 . $max2;
    }
    close($fh);
}

say $output;

sub find_max
{
    my @nums = @_;
    my $maxidx = 0;     # first index is the max

    foreach my $num (0 .. $#nums)
    {
        if ($nums[$num] > $nums[$maxidx])
        {
            $maxidx = $num;
        }
    }
    return $maxidx;
}


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
