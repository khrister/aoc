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
use List::MoreUtils qw (first_index any);
use Array::Utils qw(:all);
use Array::Compare;

# Global variables
my @orders;
my $pos;
my @maze;
my %move = ( "^" => [ 0, -1 ],
             ">" => [ 1, 0 ],
             "v" => [ 0, 1 ],
             "<" => [ -1, 0 ] );

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my @tmp = split(//, $line);
        if (grep { $_ eq "@" } @tmp)
        {
            my $x = index($line, "@");
            $tmp[$x] = ".";
            $pos = "$x," . ($. - 1);
        }
        push(@maze, \@tmp);

        last if ($line =~ /^$/);
    }
    {
        local $/;
        my $orderlist = <$fh>;
        close($fh);
        $orderlist =~ s/\n//g;
        @orders = split(//, $orderlist);
    }
}

foreach my $order (@orders)
{
    my $tmp = move($pos, $order, ".", ".");
    $pos = $tmp if ($tmp);
}

my $sum = 0;

foreach my $rowid (0 .. $#maze)
{
    my @row = @{$maze[$rowid]};
 BOX:
    foreach my $boxid (0 .. $#row)
    {
        my $box = $maze[$rowid]->[$boxid];
        next BOX unless ($box eq "O");
        $sum += $rowid * 100 + $boxid;
    }
}

say $sum;

sub move
{
    my $xy = shift;
    my $mv = shift;
    my $curloc = shift;
    my $prevloc = shift;

    my ($x, $y) = split(",", $xy);
    my ($vx, $vy) = @{$move{$mv}};

    my $x0 = $x + $vx;
    my $y0 = $y + $vy;
    my $newloc = $maze[$y0]->[$x0];
    if ($newloc eq ".")
    {
        $maze[$y0]->[$x0] = $curloc;
        $maze[$y]->[$x] = $prevloc;
        return "$x0,$y0";
    }
    elsif ($newloc eq "#")
    {
        return 0;
    }
    elsif (move("$x0,$y0", $mv, $newloc, $curloc))
    {
        $maze[$y0]->[$x0] = $curloc;
        $maze[$y]->[$x] = $prevloc;
        return "$x0,$y0";
    }
}

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
