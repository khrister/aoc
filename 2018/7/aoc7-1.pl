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
use Graph::Directed;
use Graph::Traversal::BFS;

# Global variables
my @lines;
my %child_of = ();
my %parent_of = ();
my @available = ();
my $order = "";
my %visited = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    @lines = <$fh>;
    chomp(@lines);
    close ($fh);

    my %is_child = ();
    foreach my $line (@lines)
    {
        my ($parent, $child);
        $line =~ s/Step ([A-Z]) must be finished before step ([A-Z]) can begin.//;
        $parent = $1;
        $child = $2;
        if ($child_of{$parent})
        {
            push(@{$child_of{$parent}}, $child);
        }
        else
        {
            $child_of{$parent} = [$child];
        }
        $is_child{$child} = 1;
        if ($parent_of{$child})
        {
            push(@{$parent_of{$child}}, $parent);
        }
        else
        {
            $parent_of{$child} = [$parent];
        }
    }
    foreach my $p (keys %child_of)
    {
        next if ($is_child{$p});
        print "Found a start: $p\n";
        push(@available, $p);
    }
}

@available = sort @available;

while (@available)
{
    my $cur = shift @available;
    if (!$visited{$cur})
    {
        $order .= $cur;
        $visited{$cur} = 1;
    }
    my @new = ();
    foreach my $candidate (@{$child_of{$cur}})
    {
        my $done = 1;
        foreach my $p (@{$parent_of{$candidate}})
        {
            $done = 0 unless ($visited{$p});
        }
        push(@new, $candidate)
            if ($done);
    }
    @available = sort(@available, @new)
        if ($child_of{$cur});
}

print "$order\n";

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
