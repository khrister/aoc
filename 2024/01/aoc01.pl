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

# Global variables
my @left;
my @right;
my %right_of;

my $sum1;
my $sum2;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        my ($a, $b);
        ($a, $b) = split(/ +/, $line);
        push(@left, $a);
        push(@right, $b);
        $right_of{$b}++;
    }
    close($fh);
}

@left = sort(@left);
@right = sort(@right);

for (my $i = 0; $i <= $#left; $i++)
{
    $sum1 += abs($left[$i] - $right[$i]);
}

print "$sum1\n";

for (my $i = 0; $i <= $#left; $i++)
{
    $sum2 += $left[$i] * $right_of{$left[$i]}
        if ($right_of{$left[$i]});
}

print "$sum2\n";


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
