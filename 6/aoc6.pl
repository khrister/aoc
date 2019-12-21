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

# Global variables
my %childs_of = ();
my $orbits;

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

#D(\%childs_of);

my $tree = Tree::Simple->new("COM", Tree::Simple->ROOT);

populate_tree($tree);

$tree->traverse(sub {
                    my ($_tree) = @_;
                    # getDepth starts from -1
                    my $depth = $_tree->getDepth() + 1;
                    $orbits += $depth;
                });

print "Orbits: $orbits\n";

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
