#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Carp;
use List::Util qw( sum any );
use Algorithm::Permute qw/permute/;
use JSON;
use POSIX;

my %relations;

{
    my $file = shift @ARGV or croak("Usage: $0 <file>");;
    open(my $fh, '<', $file) or croak("Can't open file $file");
    my @lines;
    @lines = <$fh>;
    chomp @lines;
    close($fh);
    foreach my $line (@lines)
    {
        my ($cur, $val, $target);
        $line =~ s/[.]//;
        my @tmp = split(/ /, $line);
        $cur = $tmp[0];
        $val = $tmp[3];
        $target = $tmp[10];

        $val = -$val if ($tmp[2] eq "lose");

        $relations{$cur} = {} unless $relations{$cur};
        $relations{$cur}->{$target} = $val;
    }
}

my @guests = keys %relations;

# For part 2, add myself as "Me"
$relations{"Me"} = {};

foreach my $guest (@guests)
{
    $relations{"Me"}->{$guest} = 0;
    $relations{$guest}->{"Me"} = 0;
}

@guests = keys %relations;

my $p_iterator = Algorithm::Permute->new(\@guests);

my $max = 0;

while (my @try = $p_iterator->next)
{
    my $sum = 0;
    my $i = 0;
#    D(\@try);
#    D($try[$#try]);
#    D($relations{$try[$i]});
#    D($relations{$try[$i]}->{$try[$#try]});
#    exit;
    while ($i < @try)
    {
        if ($i == 0)
        {
            $sum += $relations{$try[$i]}->{$try[$#try]};
        }
        else
        {
            $sum += $relations{$try[$i]}->{$try[$i - 1]};
        }

        if ($i == $#try)
        {
            $sum += $relations{$try[$i]}->{$try[0]};
        }
        else
        {
            $sum += $relations{$try[$i]}->{$try[$i + 1]};
        }
        $i++;
    }
#    print "$sum\n";
    if ($sum > $max)
    {
        $max = $sum;
    }
}

print "Highest: $max\n";

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
