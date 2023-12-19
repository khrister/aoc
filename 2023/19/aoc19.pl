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
my %flow_of = ();
my @parts = ();
{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        last if ($line =~ /^$/);
        chomp $line;
        my ($name, $rules) = split(/{/, $line);
        $rules =~ s/}//;
        $flow_of{$name} = $rules;
    }
    while (my $line = <$fh>)
    {
        my %part = ();
        $line =~ tr/{}//d;
        foreach my $stat (split(/,/, $line))
        {
            my ($cat, $val) = split(/=/, $stat);
            $part{$cat} = $val;
        }
        push(@parts, \%part);
    }
    close($fh);
}

sub flowto
{
    my $part = shift;
    my $flow = shift;
    return () if ($flow eq 'R');
    return $part if ($flow eq 'A');

    my @rules = split(/,/, $flow_of{$flow});
    foreach my $rule (@rules)
    {
        return flowto($part, $rule) if ($rule !~ /:/);
        my ($cond, $dest) = split(/:/, $rule);
        $cond = '$part->{' . substr($cond, 0, 1) . '}' . substr($cond, 1);
        if (eval $cond)
        {
            return flowto($part, $dest);
        }
    }
}

my $sum;

foreach my $part (@parts)
{
    my $res = flowto($part, "in");
    $sum += sum(values(%{$res})) if ($res);
}

print "$sum\n";

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
