#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2022

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my @rounds;

my %mscore = ( 'X' => 0, 'Y' => 3, 'Z' => 6, 'A' => 1, 'B' => 2, 'C' => 3 );

my $totalscore = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @rounds = <$fh>;
    chomp @rounds;
    close($fh);
}

#D(\@rounds);

DEPTH:
foreach my $round (@rounds)
{
    my $result;
    my $oppmove;
    ($oppmove, $result) = split(/ /, $round);

    $totalscore += $mscore{$result};

    if ($result eq 'X')
    {
        my $s = $mscore{$oppmove} - 1;
        $s = 3 if ($s == 0); #wrap around
        $totalscore += $s;
    }
    elsif ($result eq 'Y')
    {
        $totalscore += $mscore{$oppmove};
    }
    elsif ($result eq 'Z')
    {
        my $s = $mscore{$oppmove} + 1;
        $s = 1 if ($s == 4); #wraparound
        $totalscore += $s;
    }
}

print "$totalscore\n";

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
