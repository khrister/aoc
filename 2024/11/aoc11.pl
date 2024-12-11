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
use Array::Compare;
use Algorithm::Combinatorics qw (combinations);;

# Global variables

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $line = <$fh>;
    close($fh);

    chomp $line;
    my @stones = split(/ /, $line);

    for (1..75)
    {
        my $run = $_;
        my @newstones = ();
        foreach my $stone (@stones)
        {
            if ($stone == 0)
            {
                push(@newstones, 1);
            }
            elsif ((length($stone) % 2) == 0)
            {
                my $length = length($stone);
                my $a = substr($stone, 0, $length / 2);
                my $b = substr($stone, $length / 2, $length / 2);
                $b =~ s/^0+$/0/;
                $b =~ s/^0+([^0]+)/$1/;
                push(@newstones, $a, $b);
            }
            else
            {
                push(@newstones, $stone * 2024);
            }
        }
        @stones = @newstones;
        say (scalar @stones) if ($run == 25);
        say $run if ($run > 25 and ($run % 5) == 0);
    }
    say (scalar @stones);
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
