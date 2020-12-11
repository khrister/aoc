#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util 'max';
use List::MoreUtils qw (first_index);

my @current = ();
my %coords = ();
my %priors = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        next unless ($line =~ /[.L]/);
        push(@current, [ split(//, $line) ] );
    }
    close($fh);
    my $x = 0;
    my $y = 0;
    foreach my $line (@current)
    {
        $x = 0;
        foreach my $pixel (@{$line})
        {
            $coords{"$x,$y"} = $pixel;
            $x++;
        }
        $y++;
    }
}
$priors{mkstring(@current)} = 1;

while (1)
{
    @current = tick(@current);

    print "Tick\n";
    #print mkstring(@current);

    if ($priors{mkstring(@current)})
    {
        print "Found prior!\n";
        my $tmp = mkstring(@current);
        my $occupied = () = $tmp =~ m/#/g;
        print "$occupied seats taken\n";
        exit;
    }
    $priors{mkstring(@current)} = 1;
}

sub tick
{
    my @cur = @_;
    my @new = ();
    my $x = 0;
    my $y = 0;
 ROW:
    foreach my $line (@cur)
    {
        $x = 0;
    POSITION:
        foreach my $pixel (@{$line})
        {
            my $neighbours = 0;
            foreach my $dir (dirs($x, $y))
            {
                if ($coords{$dir} and $coords{$dir} eq '#')
                {
                    $neighbours++;
                }
            }
            if ($pixel eq "#" and ($neighbours >= 4))
            {
                $new[$y]->[$x] = "L";
            }
            elsif ($pixel eq "L" and $neighbours == 0)
            {
                $new[$y]->[$x] = "#";
            }
            else
            {
                $new[$y]->[$x] = $pixel;
            }
            $x++;
        }
        $y++;
    }
    foreach my $c (keys %coords)
    {
        my $x;
        my $y;
        ($x, $y) = split(/,/, $c);
        $coords{$c} = $new[$y]->[$x];
    }
    return @new
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

sub dirs
{
    my $x = shift;
    my $y = shift;
    return ("$x," . ($y - 1), "$x," . ($y + 1),       # up down
            ($x - 1) . ",$y", ($x + 1) . ",$y",       # left right
            ($x - 1) . "," . ($y - 1), ($x + 1) . "," . ($y - 1), # upleft upright
            ($x - 1) . "," . ($y + 1), ($x + 1) . "," . ($y + 1));# downleft downright
}


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
