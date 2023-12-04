#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

my $sum = 0;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";

    while (my $line = <$fh>)
    {
        chomp $line;
        my @r1 = split(" ", $line);
        $line = <$fh>;
        my @r2 = split(" ", $line);
        $line = <$fh>;
        my @r3 = split(" ", $line);

        foreach my $i (0..2)
        {
            my @tri = ( $r1[$i], $r2[$i], $r3[$i] );
            @tri = sort { $a <=> $b } @tri;
            $sum++ if ($tri[0] + $tri[1] > $tri[2]);
        }
    }
    close($fh);
}

print "$sum\n";

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
