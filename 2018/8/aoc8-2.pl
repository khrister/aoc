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

$total = value_node(0);

print "Total: $total\n";

sub value_node
{
    my $n = shift;
    my $value = 0;
    my %node = %{$nodes{$n}};
    my @children;

    @children = @{$node{children}} if ($node{children});
    my @metadata = @{$node{metadata}};

    foreach my $md (@metadata)
    {
        if (@children)
        {
            if (@children >= $md)
            {
                $value += value_node($children[$md - 1]); 
            }
        }
        else
        {
            $value += $md;
        }

    }
    return $value;
}

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
        if (!$nodes{$self}->{children})
        {
            $nodes{$self}->{children} = [];
        }
        my $child;
        ($child, @rest) = get_node($self, @rest);
        push(@{$nodes{$self}->{children}}, $child);
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
    return ($index, @rest);
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
