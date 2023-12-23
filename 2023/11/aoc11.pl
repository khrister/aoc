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
use List::MoreUtils qw (first_index indexes);
use Array::Utils qw(:all);
use Algorithm::Permute qw/permute/;
use Math::Combinatorics qw/combine/;

# Global variables
my @maze;
my @galaxy;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        push(@maze, [ split("", $line) ]);
        if ($line !~ /#/)
        {
            push(@maze, [ split("", $line) ]);
        }
    }
    close($fh);
    my $width = scalar(@{$maze[0]});
 ROW:
    for (my $x = $width - 1; $x >= 0; $x--)
    {
        foreach my $row (@maze)
        {
            next ROW if ($row->[$x]) eq '#';
        }
        for (my $y = 0; $y <= $#maze; $y++)
        {
            my @foo = @{$maze[$y]};
            splice(@foo, $x, 0, ".");
            $maze[$y] = \@foo;
        }
    }
}

my $width = scalar(@{$maze[0]});

for (my $y = 0; $y <= $#maze; $y++)
{
    my @tmp = indexes { $_ eq "#" } @{$maze[$y]};
    foreach my $index (@tmp)
    {
        push(@galaxy, "$index,$y");
    }
}

my $p = Math::Combinatorics->new(count => 2,
                                 data => [@galaxy]);

my $sum = 0;

while (my @perms = $p->next_combination)
{
    my ($x0, $y0) = split(/,/, $perms[0]);
    my ($x1, $y1) = split(/,/, $perms[1]);
    $sum += abs($x0-$x1);
    $sum += abs($y0-$y1);
}

say $sum;

sub mkstring
{
    my @arr = @_;
    my $res = "";
    foreach my $line (@arr)
    {
        $res .= join("", @{$line}) . "\n";
    }
    return $res;
}

sub paint
{
    my @arr = @_;
    print mkstring(@arr);
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
