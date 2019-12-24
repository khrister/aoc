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
        next unless ($line =~ /[.#]/);
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

my $n = 0;
while (1)
{
 #   last if ($n > 1);
    @current = tick(@current);

#    print "Tick\n";
#    print mkstring(@current);
#    foreach my $foo (sort {scalar (reverse $a) cmp scalar (reverse $b) } keys %coords)
#    {
#        print $coords{$foo};
#    }
#    print "\n";
    if ($priors{mkstring(@current)})
    {
        print "Found prior!\n";
        print scalar(keys %priors) . "\n";
        paint(@current);
        my $bio = 0;
        my $worth = 1;
        foreach my $line (@current)
        {
            foreach my $cell (@{$line})
            {
                $bio += $worth  if ($cell eq "#");
                $worth *= 2;
            }
        }
        print "Biodiversity: $bio\n";
        exit;
    }
    $priors{mkstring(@current)} = 1;
    $n++;
}

sub tick
{
    my @cur = @_;
    my @new = ();
    my $x = 0;
    my $y = 0;

    foreach my $line (@cur)
    {
        $x = 0;
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
            if ($pixel eq "." and ($neighbours == 1 or $neighbours == 2))
            {
                $new[$y]->[$x] = "#";
            }
            elsif ($pixel eq "#" and $neighbours != 1)
            {
                $new[$y]->[$x] = ".";
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
    return ("$x," . ($y - 1), "$x," . ($y + 1),
            ($x - 1) . ",$y", ($x + 1) . ",$y");
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
