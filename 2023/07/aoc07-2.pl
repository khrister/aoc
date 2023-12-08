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
my %hands;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my @tmp = split(" ", $line);
        $hands{$tmp[0]} = $tmp[1];

    }
    close($fh);
}

my @ranked = sort { score($a) <=> score($b) or
                        high($a) cmp high($b) } keys %hands;

my $winnings = 0;

foreach my $i (0..$#ranked)
{
    my $hand;
    $hand = $ranked[$i];
    my $rank = $i + 1; # Array starts at 0, rank at 1
    $winnings += $rank * $hands{$hand};
}

print "Winnings: $winnings\n";

sub score
{
    my $hand = shift;
    $hand =~ tr/J/Z/;
    $hand = join("", sort(split("", $hand)));
    $hand =~ tr/Z/J/;
    return 6 if ($hand =~ m/([AKQJT2-9])(?:\1|J)(?:\1|J)(?:\1|J)(?:\1|J)/);
    return 5 if ($hand =~ m/.?([AKQJT2-9]).?(?:\1|J).?(?:\1|J).?(?:\1|J).?/);
    if ($hand =~ m/([AKQJT2-9]).*(?:\1|J).*(?:\1|J)/)
    {
        if ($hand =~ m/([^$1J]).*\1/)
        {
            return 4;
        }
        else
        {
            return 3;
        }
    }
    if ($hand =~ m/([AKQJT2-9]).*(?:\1|J)/)
    {
        if ($hand =~ m/([^$1J]).*\1/)
        {
            return 2;
        }
    }
    if ($hand =~ m/([AKQT2-9]).*(?:\1|J)/)
    {
        return 1;
    }
    return 0;
}

sub high
{
    my $hand = shift;
    $hand =~ s/A/Z/g;
    $hand =~ s/K/Y/g;
    $hand =~ s/Q/X/g;
    $hand =~ s/J/1/g;
    $hand =~ s/T/V/g;
    return $hand;
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
