#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my @expenses;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @expenses = <$fh>;
    close($fh);
    chomp(@expenses);
}

foreach my $exp (@expenses)
{
 EXP2:
    foreach my $exp2 (@expenses)
    {
        next EXP2 if ($exp + $exp2 >= 2020);
        foreach my $exp3 (@expenses)
        {
            if ($exp + $exp2 + $exp3 == 2020)
            {
                print "$exp + $exp2 + $exp3 = 2020, $exp * $exp2 * $exp3 = " .
                    ($exp * $exp2 * $exp3) . "\n";
                exit;
            }
        }
    }
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
