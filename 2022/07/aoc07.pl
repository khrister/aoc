#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2022

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Graph::Directed;
use Graph::TransitiveClosure::Matrix;

# Global variablesu
my $data;

my %dirs = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    local $/;
    $data =  <$fh>;
    close($fh);
}

my @commands = split(/\$ /, $data);
chomp @commands;
# D(\@commands);

my $g = Graph::Directed->new;

foreach my $cmd (@commands)
{
    if ($cmd =~ /^cd/)
    {
        print "$cmd\n";
    }
}


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

Copyright Christer Boräng 2019

=cut
