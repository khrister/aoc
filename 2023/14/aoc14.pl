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
my @grid;


{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        push(@grid, [ split("", $line) ]);
    }
    close($fh);
}

for (my $i = $#grid; $i > 0; $i--)
{
    my @line = @{$grid[$i]};
 POINT:
    for (my $j = 0; $j <= $#line; $j++)
    {
        next POINT if ($line[$j] eq '#' or $line[$j] eq '.');
    STOP:
        foreach (my $k = $i - 1; $k >= 0; $k--)
        {
            my $p = $grid[$k]->[$j];
            last STOP if ($p eq '#');
            next STOP if ($p eq 'O');
            $grid[$k]->[$j] = 'O';
            $grid[$i]->[$j] = '.';
            last STOP;
        }
    }
}

my $sum;

for (my $i = 0; $i <= $#grid; $i++)
{
    $sum += (grep { /O/ } @{$grid[$i]}) * ($#grid + 1 - $i);
}

print "$sum\n";

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
