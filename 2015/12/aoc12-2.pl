#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use Carp;
use List::Util qw( sum any );
use Algorithm::Permute qw/permute/;
use JSON;
use POSIX;

my $str;
my $sum = 0;

{
    my $file = shift @ARGV or croak("Usage: $0 <file>");;
    open(my $fh, '<', $file) or croak("Can't open file $file");
    $str = <$fh>;
    chomp $str;
    close($fh);
}

my $json = JSON->new();

my $res = $json->decode($str);


check_ref($res);

print "$sum\n";

# recursive function, avoid going down hashes with "red" in an element
sub check_ref
{
    my $cur = shift;
    my $type = ref($cur);
    return unless ($cur);
    if ($type eq "ARRAY")
    {
        foreach my $elem (@{$cur})
        {
            check_ref($elem);
        }
    }
    elsif ($type eq "HASH")
    {
        if (any { $_ eq "red" } values(%{$cur}))
        {
            return;
        }
        foreach my $elem (keys %{$cur})
        {
            check_ref($cur->{$elem});
        }
    }
    else
    {
        if ($cur =~ qr/ ^ [[:digit:]-]+ $ /x)
        {
            $sum += $cur;
        }
    }
}

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
