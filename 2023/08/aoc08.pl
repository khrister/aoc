#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my @instructions;
my %elements;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    # Get instruction list
    my $l = <$fh>;
    chomp $l;
    @instructions = split("", $l);

    while (my $line = <$fh>)
    {
        chomp $line;
        next if ($line =~ /^$/);
        my $src;
        my $dests;
        ($src, $dests) = split(" = ", $line);
        $dests =~ s/[()]//g;
        $elements{$src} = [ split(", ", $dests) ];
    }
    close($fh);
}

my $i = 0;
my $steps = 0;
my $mod = @instructions;
my $elem = "AAA";

while (1)
{
    my $inst = $instructions[$i % $mod];
    if ($inst eq "L")
    {
        $elem = $elements{$elem}->[0];
    }
    elsif ($inst eq "R")
    {
        $elem = $elements{$elem}->[1];
    }
    else
    {
        print "Whoa! Error, inst is $inst\n";
    }
    $i++;
    last if ($elem eq "ZZZ");
}

print "$i\n";

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

Copyright Christer Boräng 2023

=cut
