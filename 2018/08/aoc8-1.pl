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
my @values = ();
my %nodes = ();

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    my $line = <$fh>;
    chomp($line);
    close ($fh);
    @values = split(/ /, $line);
}

my @tmp = get_node(-1, @values);

my $total = 0;
foreach my $node (keys %nodes)
{
    my @md = @{$nodes{$node}->{metadata}};
    map { $total += $_ } @md;
}

print "Total: $total\n";

sub get_node
{
    my $parent = shift;
    my $childs = shift;
    my $meta = shift;
    my @rest = @_;

    my $index = $parent + 1;
    $index++ until(! $nodes{$index});
    my $self = $index;
    $nodes{$self} = ();
    if ($parent > -1)
    {
        $nodes{$self}->{parent} = $parent;
    }
    while ($childs-- > 0)
    {
        @rest = get_node($self, @rest);
    }
    if ($meta)
    {
        my @selfmeta = ();
        while ($meta-- > 0)
        {
            my $tmp = shift @rest;
            push(@selfmeta, $tmp);
        }
        $nodes{$self}->{metadata} = [ @selfmeta ];
    }
    return @rest;
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
