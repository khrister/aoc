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
my @times;
my @records;
my $result = 1;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    my $line = <$fh>;
    chomp $line;

    (undef, @times) = split(" ", $line);

    $line = <$fh>;
    chomp $line;

    (undef, @records) = split(" ", $line);

    close($fh);
}

foreach my $i (0..$#times)
{

    my $time = $times[$i];
    my $record = $records[$i];
    my $wins = 0;

    foreach my $charge (1 .. ($time - 1))
    {
        my $res = $charge * ($time - $charge);
        $wins++ if ($res > $record);
    }
    $result *= $wins;
}

print "$result\n";


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
