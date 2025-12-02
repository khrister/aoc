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
my $invalidsum;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        next if ($line =~ m/^$/);

        my @r = split(/,/, $line);
    RANGE:
        foreach my $double (@r)
        {
            my $start;
            my $end;
            ($start, $end) = split(/-/, $double);
            if (length($start) eq length($end) and (length $start) % 2)
            {
                next RANGE;
            }
            else
            {
                my $len = length($start);
                if ($len % 2)
                {
                    $start = "1" . (0 x $len);
                    $len++;
                }
                my $a = substr($start, 0, $len/2);

                while ("$a$a" <= $end)
                {
                    if ("$a$a" >= $start)
                    {
                        $invalidsum += "$a$a";
                    }
                    $a++;
                }
            }
        }
    }
    close($fh);
}

say $invalidsum;

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
