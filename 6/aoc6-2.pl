#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';

# Other modules
use Data::Dumper;
use IO::Prompter;
use POSIX qw/floor ceil/;
use Tree::Simple;
use List::MoreUtils qw/first_index/;;

# Global variables
my %childs_of = ();
my $orbits;
my $from;
my $to;

if (scalar(@ARGV) != 2)
{
    print "Need two arguments.\n";
    exit;
}

$from = shift @ARGV;
$to = shift @ARGV;

while (my $line = <>)
{
    my $p;
    my $c;
    chomp $line;
    ($p, $c) = split(/\)/, $line);
    if ($childs_of{$p})
    {
        push($childs_of{$p}, $c);
    }
    else
    {
        $childs_of{$p} = [$c];
    }
}

my $tree = Tree::Simple->new("COM", Tree::Simple->ROOT);

populate_tree($tree);

$tree->traverse(sub {
                    my ($_tree) = @_;
                    # getDepth starts from -1
                    my $depth = $_tree->getDepth() + 1;
                    $orbits += $depth;
                });

print "Orbits: $orbits\n";

my $from_node = find_node($from);
my $to_node = find_node($to);

my $distance = find_distance($from_node, $to_node);

print "distance $distance\n";

sub find_distance
{
    my $fromref = shift;
    my $toref = shift;
    my @from_to_root = get_rootpath($fromref);
    my @to_to_root = get_rootpath($toref);

    my $common;
    my $steps;
    foreach my $node (@from_to_root)
    {
        $steps = first_index { $node eq $_ } @to_to_root;
        $common = $node;
        last if ($steps ne -1);
    }
    $steps += first_index { $common eq $_ } @from_to_root;
    return $steps;
}

sub get_rootpath
{
    my $node = shift;
    my @path;
    while (1)
    {
        $node = $node->getParent();
        push(@path, $node->getNodeValue());
        last if ($node->isRoot());
    }
    return @path;
}

sub find_node
{
    my $name = shift;
    my $node;
    $tree->traverse(sub {
                        my ($_tree) = @_;
                        my $val = $_tree->getNodeValue();
                        if ($val eq $name) { $node = $_tree; return 'ABORT' }
                    });
    return $node;
}

sub populate_tree
{
    my $node = shift;
    my @childs = @{ $childs_of{$node->getNodeValue()}}
        if ($childs_of{$node->getNodeValue()});
    foreach my $child (@childs)
    {
        $node->generateChild($child);
    }
    foreach my $child ($node->getAllChildren())
    {
        populate_tree($child);
    }
}

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
