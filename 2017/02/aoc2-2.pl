#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( max min );

my @rows;
my $result = 0;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    @rows = <$fh>;
    close($fh);
    chomp @rows;
}

ROW:
foreach my $r (@rows)
{
    my $i = 0;
    my @row = sort { $b <=> $a } split(/\s+/, $r);

 DIVIDEND:
    while ($i < $#row)
    {
        my $j = $i + 1;
    DIVISOR:
        while ($j <= $#row)
        {
            if ($row[$i] % $row[$j])
            {
                $j++;
                next DIVISOR;
            }
            $result += ($row[$i] / $row[$j]);
            next ROW;
        }
        $i++;
    }
}

print "Result: $result\n";

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
