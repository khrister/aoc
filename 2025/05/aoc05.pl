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
my %frange;
my $freshitems = 0;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $y = 0;
    while (my $line = <$fh>)
    {
        chomp $line;
        last if ($line =~ /^$/);
        my $start;
        my $end;
        ($start, $end) = split(/-/, $line);
        my $oldend = $frange{$start};
        $frange{$start} = $end if !defined($oldend) or $end > $oldend;
    }
    while (my $line = <$fh>)
    {
        chomp $line;
    FRANGE:
        foreach my $start (keys %frange)
        {
            if ($line >= $start and $line <= $frange{$start})
            {
                $freshitems++;
                last FRANGE;
            }
        }
    }
    close($fh);
}

say $freshitems;

my $size = 0;
my $cur_max = 0;

for my $rref (sort { $a <=> $b } keys %frange)
{
    my $start = $rref;
    my $end = $frange{$rref};

    if ($end >= $cur_max)
    {
        $size += $end - max($start, $cur_max) + 1;
        $cur_max = $end + 1;
    }
}

say $size;

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
