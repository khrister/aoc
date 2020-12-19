#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my %rules;
my @values;
my $reg = "";

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while ((my $line = <$fh>) !~ /^$/)
    {
        chomp $line;
        my ($n, $r) = split(/: /, $line);
        $rules{$n} = $r;
    }
    @values = <$fh>;
    close($fh);
}

$reg = make_rule(0);

my @res = grep { /^$reg$/ } @values;

print "" . (scalar @res) . "\n";

sub make_rule
{
    my $rv = shift;
    my $rule = "(?:";
    foreach my $r (split(/ /, $rules{$rv}))
    {
        if ($r =~ /^[0-9]+$/)
        {
            $rule .= make_rule($r);
        }
        else
        {
            $r =~ s/"//g;
            $rule .= $r;
        }
    }
    $rule .= ")";
}

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
