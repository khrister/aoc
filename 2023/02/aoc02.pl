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

my %total = ( red => 12,
              green => 13,
              blue => 14 );
my $sum = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
 LINE:
    while (my $line = <$fh>)
    {
        my $game;
        chomp $line;

        ($game, $line) = split(/: /, $line);
        $game =~ s/^Game ([0-9]+)$/$1/;

        my @moves = split(/; /, $line);
        foreach my $move (@moves)
        {
            my @cubes = split(/, /, $move);
            foreach my $cube (@cubes)
            {
                my $num;
                my $col;
                ($num, $col) = split(/ /, $cube);
                next LINE if ($num > $total{$col});
            }

        }
        $sum += $game;
    }
    close($fh);
}

print "$sum\n";



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
