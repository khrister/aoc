#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum min/;
use List::MoreUtils 'first_index';
use Time::HiRes 'usleep';

# Global variables
my %transforms = ();
my %oldstate = ();
my %newstate = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my @lines = <$fh>;
    chomp(@lines);
    close ($fh);

    my $instate;
    $instate = shift @lines;
    $instate =~ s/initial state: //;

    my @tmp = split(//, $instate);
    @oldstate{0..$#tmp} = @tmp;

    foreach my $line (@lines)
    {
        next unless ($line =~ /=>/);
        my ($state, $result) = split(/ => /, $line);
        $transforms{$state} = $result;
    }
}

foreach my $i (1..20)
{
    %newstate = ();
    # Pad %oldstate so there are at least four . at the ends
    my @keys = sort { $a <=> $b } keys %oldstate;
    my $i;
    my $first = $keys[0];
 START:
    foreach my $key (@keys)
    {
        $i = $key;
        last START if ($oldstate{$key} eq "#");
    }

    my $j;
    my $last = $keys[$#keys];
 END:
    foreach my $key (reverse @keys)
    {
        $j = $key;
        last END if ($oldstate{$key} eq "#");
    }

    foreach my $key (($i - 4)..($first - 1), ($last + 1)..($j + 4))
    {
        $oldstate{$key} = ".";
    }

    # And grow some plants
    foreach my $pot (keys %oldstate)
    {
        my $pl = grow($pot);
        if (!$pl)
        {
            print "Awooga! pl is undefined. Position is $pot\n";
            exit;
        }
        $newstate{$pot} = $pl;
    }
    %oldstate = %newstate;
}

my @keys = sort { $a <=> $b } keys %oldstate;

my $total = 0;
foreach my $key (@keys)
{
    $total += $key if ($oldstate{$key} eq "#");
}

print "Plant total value: $total\n";

sub grow
{
    my $pos = shift;
    # Ignore the first and last two posisions, with the padding nothing can grow there
    return "." unless ($oldstate{$pos-2} and $oldstate{$pos+2});
    my $str = $oldstate{$pos-2} . $oldstate{$pos-1} . $oldstate{$pos}
        . $oldstate{$pos+1} . $oldstate{$pos+2};
    return ($transforms{$str} or ".");
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
