#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (product);
#use List::MoreUtils qw (first_index);
#use Array::Utils qw(intersect);;

my @player1 = ();
my @player2 = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    <$fh>; # Toss away first line
    while (my $line = <$fh>)
    {
        last if ($line =~ /^$/);
        chomp $line;
        push(@player1, $line);
    }
    <$fh>; # Toss away second player line
    while (my $line = <$fh>)
    {
        last if ($line =~ /^$/);
        chomp $line;
        push(@player2, $line);
    }
    close($fh);
}

while(@player1 and @player2)
{
    my $a = shift @player1;
    my $b = shift @player2;

    if ($a > $b)
    {
        push(@player1, $a, $b);
    }
    else
    {
        push(@player2, $b, $a);
    }
}

my @winner = ();
if (@player1)
{
    @winner = @player1;
}
else
{
    @winner = @player2;
}

@winner = reverse @winner;

my $i = 1;
my $total = 0;
foreach my $elem (@winner)
{
    $total += $elem * $i++;
}

print "Score: $total\n";

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
