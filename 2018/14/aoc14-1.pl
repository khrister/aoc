#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum min/;
use List::MoreUtils 'first_index';
use Time::HiRes 'usleep';
use Term::ANSIColor;

# Global variables
my @recipes = (3, 7);
my @elf = (0, 1);
my $goal;
my $needed;

{
    $goal = shift @ARGV;
    chomp $goal;
    $needed = $goal + 10;
}

while (@recipes < $needed)
{
    my $new = $recipes[$elf[0]] + $recipes[$elf[1]];
    if (int($new / 10))
    {
        push(@recipes, 1);
    }
    push(@recipes, $new % 10);
    $elf[0] = (1 + $elf[0] + $recipes[$elf[0]]) % scalar @recipes;
    $elf[1] = (1 + $elf[1] + $recipes[$elf[1]]) % scalar @recipes;
}

print join("", @recipes[$goal..$goal+9]) . "\n";


#debug function
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
