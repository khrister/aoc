#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw(max any);
use List::MoreUtils qw (first_index);
use Array::Utils qw (intersect);

my @ing_list = ();
my %allergens = ();
my %ingredients;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @ing_list = <$fh>;
    close($fh);
    chomp(@ing_list);
}

foreach my $line (@ing_list)
{
    next if $line =~ /^$/;
    my ($ing, @all, undef) = split(/\(contains |, |\)/, $line);
    foreach my $a (@all)
    {
        $allergens{$a} = 1;
    }
    my @ings = split(/ /, $ing);
    foreach my $i (@ings)
    {
        $ingredients{$i}++;
    }
}

my %badfood = ();

foreach my $all (keys %allergens)
{
    my @plist = keys %ingredients;  # List of possible allergens
    my @all_in = grep { /\b$all/ } @ing_list;
    foreach my $line (@all_in)
    {
        # First split out ingredients
        my ($tmp, undef) = split(/\(/, $line);
        my @ings = split(/ /, $tmp);
        @plist = intersect(@ings, @plist);
    }
    foreach my $tmp (@plist)
    {
        $badfood{$tmp} = 1;
    }
}

my $total = 0;
foreach my $tmp (keys %ingredients)
{
    # Manually figured these out
    next if (any { /$tmp/ } keys %badfood);
    $total += $ingredients{$tmp};
}

print "Total $total\n";

# Debug function
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
