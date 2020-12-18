#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);

my @calculations;
my @values;
my $sum;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    @calculations = <$fh>;
    close($fh);
    chomp(@calculations);
}

foreach my $calc (@calculations)
{
    my $level = 0;
    $calc =~ s/ //g;
    my @list = split(//, $calc);
    push(@values, do_calc(@list));
}

print "Sum: " . sum(@values) . "\n";;

sub do_calc
{
    my @calc = @_;
    my $i = 0;
    my $operator;
    my $cur = 0;
    while ($i < @calc)
    {
        my $steps = 1;
        my $char = $calc[$i];
        if ($char eq "(")
        {
            my $tmp;
            ($tmp, $steps) = do_calc(@calc[($i + 1)..$#calc]);
            if ($operator)
            {
                $cur = eval "$cur $operator $tmp";
                $operator = undef;
            }
            else
            {
                $cur = $tmp;
            }
        }
        elsif ($char eq ")")
        {
            return ($cur, $i + 2);
        }
        elsif ($char =~ /[1-9]/)
        {
            if ($operator)
            {
                $cur = eval "$cur $operator $char";
                $operator = undef;
            }
            else
            {
                $cur = $char;
            }
        }
        else
        {
            $operator = $char;
        }

        $i += $steps;
    }
    return $cur;
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
