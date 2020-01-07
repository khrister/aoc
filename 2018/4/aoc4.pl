#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum/;
use List::MoreUtils 'first_index';

# Global variables
my %guards = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);
    %guards = parse_lines(@lines);
}

# Part 1
my $most = 0;
my $gtotal = 0;

foreach my $guard (keys %guards)
{
    my $total = sum(@{$guards{$guard}});
    if ($total > $gtotal)
    {
        $gtotal = $total;
        $most = $guard;
    }
}
my $max = max(@{$guards{$most}});
my $min = first_index { $max == $_ } @{$guards{$most}};

print "Guard #$most slept $max times at minute $min, result: " . ($most * $min) . "\n";

# Part 2
my $sleepy;
my $tmax = 0;

foreach my $guard (keys %guards)
{
    my $max = max @{$guards{$guard}};
    if ($max > $tmax)
    {
        $tmax = $max;
        $sleepy = $guard;
    }
}

$min = first_index { $tmax == $_ } @{$guards{$sleepy}};
print "Guard #$sleepy slept $tmax times at minute $min, result: " . ($sleepy * $min) . "\n";


sub parse_lines
{
    my @lines = sort @_;
    my %g = ();
    my $guard;
    my $from;
    foreach my $line (@lines)
    {
        if ($line =~ /Guard #([0-9]+)/)
        {
            # $guard is now on duty
            $guard = $1;
            if (!$g{$guard})
            {
                # Seed the array for $guard
                $g{$guard} = [ (0) x 60 ];
            }
        }
        elsif ($line =~ /:([0-9][0-9])\] falls asleep/)
        {
            $from = $1;
        }
        elsif ($line =~ /:([0-9][0-9])\] wakes up/)
        {
            foreach my $min ($from .. $1 - 1)
            {
                $g{$guard}->[$min]++;
            }
        }
    }
    return %g;
}

#debug function
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

Copyright Christer Boräng 2019

=cut
