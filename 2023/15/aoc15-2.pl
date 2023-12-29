#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';
# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Hash::Ordered;

# Global variables
# Array of arrays of hash
my @boxes;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $line = <$fh>;
    chomp $line;
    close($fh);

    foreach my $str (split(/,/, $line))
    {
        my @chars = split(//, $str);
        my $cur = 0;
        my $label = "";;
        my $op;
        my $focal;
    CHAR:
        foreach my $char (@chars)
        {
            if ($char =~ /[-=]/)
            {
                $op = $char;
                next CHAR;
            }
            if ($char =~ /[0-9]/)
            {
                $focal = $char;
                last CHAR;
            }
            $label .= $char;
            $cur += ord($char);
            $cur *= 17;
        }
        $cur %= 256;
        #say "$cur $op";
        if ($op eq '=')
        {
            if ($boxes[$cur])
            {
                my $oh = $boxes[$cur];
                if ($oh->get($label))
                {
                    $oh->set($label => $focal);
                }
                else
                {
                    $oh->push($label => $focal);
                }
                $boxes[$cur] = $oh;
            }
            else
            {
                my $oh = Hash::Ordered->new($label => $focal);
                $boxes[$cur] = $oh;
            }
        }
        elsif ($op eq '-')
        {
            if ($boxes[$cur])
            {
                my $oh = $boxes[$cur];
                if ($oh->exists($label))
                {
                    $oh->delete($label);
                    $boxes[$cur] = $oh;
                }
            }
        }
    }
}

my $total = 0;

for (my $i = 0; $i <= $#boxes; $i++)
{
    next if (!$boxes[$i]);
    my $oh = $boxes[$i];
    my @keys = $oh->keys();
    next unless (@keys);

    my $box = $i + 1;

    for (my $j = 0; $j <= $#keys; $j++)
    {
        my $lens = $j + 1;
        my $focal = $oh->get($keys[$j]);
        my $power = $box * $lens * $focal;
        $total += $power;
        #say "$box $lens $power $focal";
    }
}

say $total;


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
