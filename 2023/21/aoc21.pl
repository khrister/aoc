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
my @maze;
my %moves;
my @queue;
my $start;
my $steps = 6;
my $xmax;
my $ymax;

{
    die "Usage: $0 <file>" unless (@ARGV >= 1);
    my $file = shift @ARGV;
    $steps = shift @ARGV if (@ARGV);

    my $fh;
    open($fh, '<', $file);
    my @lines = <$fh>;
    close($fh);

    chomp(@lines);
    for (my $y = 0; $y <= $#lines; $y++)
    {
        my @line = split(//, $lines[$y]);
        if (grep { $_ eq "S" } @line)
        {
            my $x = index($lines[$y], "S");
            $start = "$x,$y";
            $moves{$start} = 0;
        }
        push(@maze, \@line);
    }
    $ymax = $#lines;
    $xmax = length($lines[0]);
}

#paint(@maze);

print "$start, $steps\n";
push(@queue, $start);
for (my $step = 1; $step <= $steps; $step++)
{
    my @newqueue = ();
    foreach my $cur (@queue)
    {
        my @neighbours = neighbours($cur);
        foreach my $n (@neighbours)
        {
            $moves{$n} = $step;
            push(@newqueue, $n);
        }
    }
    @queue = @newqueue;
}

#D(\%moves);

my $num = grep { $_ % 2 == 0 } values(%moves);

say $num;

sub neighbours
{
    my $cur = shift;
    my @next;
    my ($x, $y) = split(/,/, $cur);

    my $tmp = check($x + 1, $y);
    push(@next, $tmp) if $tmp;
    $tmp = check($x - 1, $y);
    push(@next, $tmp) if $tmp;
    $tmp = check($x, $y + 1);
    push(@next, $tmp) if $tmp;
    $tmp = check($x, $y - 1);
    push(@next, $tmp) if $tmp;
    return @next;
}

sub check
{
    my $x = shift;
    my $y = shift;
    if ($x < 0 or $x > $xmax or $y < 0 or $y > $ymax)
    {
        return;
    }
    if (defined($moves{"$x,$y"}))
    {
        return;
    }
    if ($maze[$y]->[$x] ne '.')
    {
        return;
    }
    return "$x,$y";;
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
