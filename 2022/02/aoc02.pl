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

my %mscore = ( 'X' => 1, 'Y' => 2, 'Z' => 3, 'A' => 1, 'B' => 2, 'C' => 3 );

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
    my $move;
    my $oppmove;
    ($oppmove, $move) = split(/ /, $round);

    $totalscore += $mscore{$move};

    my $om = $mscore{$oppmove};
    my $m = $mscore{$move};
    my $res = $m - $om;
    if ($res == 1 or $res == -2)
    {
        #win
        $totalscore += 6;
    }
    elsif ($res == -1 or $res == 2)
    {
        #loss
        $totalscore += 0;
    }
    elsif ($res == 0)
    {
        #draw
        $totalscore += 3;
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
