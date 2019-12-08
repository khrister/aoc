#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use POSIX qw/floor ceil/;
use Data::Dumper;

# Global variables


while (my $line = <>)
{
    my @program = ();
    chomp $line;
    @program = split(/,/, $line);
    foreach my $noun (0..99)
    {
        foreach my $verb (0..99)
        {
            my @testcase = @program;
            @testcase[1..2] = ($noun, $verb);
            my $res = run_program(@testcase);
            if ($res == 19690720)
            {
                print "" . (100 * $noun + $verb) . "\n";
            }
        }
    }
}

sub run_program
{
    my $pos = 0;
    my @prog = @_;

    while ($prog[$pos] != 99)
    {
        if ($prog[$pos] == 1)
        {
            my $tmp = $prog[$prog[$pos + 1]] + $prog[$prog[$pos + 2]];
            $prog[$prog[$pos + 3]] = $tmp;
        }
        elsif ($prog[$pos] == 2)
        {
            my $tmp = $prog[$prog[$pos + 1]] * $prog[$prog[$pos + 2]];
            $prog[$prog[$pos + 3]] = $tmp;
        }
        $pos += 4;
    }
    return $prog[0];
}

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

Copyright Christer Boräng 2019

=cut
