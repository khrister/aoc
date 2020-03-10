#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

my $ns = 0;
my $ew = 0;
my $dir = 0;
my %visited = ('0,0' => 1);
my @moves;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    my $out = <$fh>;
    $out =~ s/ //g;
    chomp $out;
    @moves = split(/,/, $out);
    close($fh);
}

MOVE:
foreach my $inst (@moves)
{
    my $dc = substr($inst, 0, 1);
    my $len = substr($inst, 1);
    $dir = ($dir + ($dc eq "L" ? -1 : 1)) % 4;

    print "=== $dc : $len ===\n";
    if ($dir == 0)
    {
        foreach my $foo (($ns + 1) .. ($ns + $len))
        {
            $visited{"$ew,$foo"}++;
            print "$ew,$foo\n";
            if ($visited{"$ew,$foo"} == 2)
            {
                print "$ew,$foo\n";
                $ns = $foo;
                last MOVE;
            }

        }
        $ns += $len;
    }
    elsif ($dir == 1)
    {
        foreach my $foo (($ew + 1) .. ($ew + $len))
        {
            $visited{"$foo,$ns"}++;
            print "$foo,$ns\n";
            if ($visited{"$foo,$ns"} == 2)
            {
                print "$foo,$ns\n";
                $ew = $foo;
                last MOVE;
            }
        }
        $ew += $len;
    }
    elsif ($dir == 2)
    {
        foreach my $foo (reverse(($ns - $len) .. ($ns - 1)))
        {
            $visited{"$ew,$foo"}++;
            print "$ew,$foo\n";
            if ($visited{"$ew,$foo"} == 2)
            {
                print "$ew,$foo\n";
                $ns = $foo;
                last MOVE;
            }
        }
        $ns -= $len;
    }
    elsif ($dir == 3)
    {
        foreach my $foo (reverse(($ew - $len) .. ($ew - 1)))
        {
            $visited{"$foo,$ns"}++;
            print "$foo,$ns\n";
            if ($visited{"$foo,$ns"} == 2)
            {
                print "$foo,$ns\n";
                $ew = $foo;
                last MOVE;
            }
        }
        $ew -= $len;
    }
}

D(\%visited);

print "Distance is " . (abs($ns) + abs($ew)) . "\n";

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
