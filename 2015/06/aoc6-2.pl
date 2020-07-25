#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( sum );

my @tasks;
my %coords;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    @tasks = <$fh>;
    chomp @tasks;
    close($fh);
}


foreach my $task (@tasks)
{
    my $pad = 0;
    my @parts = split(/ /, $task);
    my $op = $parts[0];
    if ($op ne 'toggle')
    {
        $pad = 1;
        $op = $parts[1];
    }
    my ($x0, $y0) = split(/,/, $parts[1 + $pad]);
    my ($x1, $y1) = split(/,/, $parts[3 + $pad]);

    foreach my $x ($x0..$x1)
    {
        foreach my $y ($y0..$y1)
        {
            if ($op eq 'toggle')
            {
                $coords{"$x,$y"} += 2;
            }
            elsif ($op eq 'on')
            {
                $coords{"$x,$y"} += 1;
            }
            elsif ($op eq 'off')
            {
                if (!$coords{"$x,$y"} or $coords{"$x,$y"} < 1)
                {
                    $coords{"$x,$y"} = 0;
                }
                else
                {
                    $coords{"$x,$y"} -= 1;
                }
            }
        }
    }
}

my $res = sum(values(%coords));
print "$res\n";


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
