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
    $calc =~ s/(\d+(\+\d+)+)/($1)/g;
    while ($calc =~ s/(\([^()]+\))/XX/)
    {
        my $c = $1;
        $c =~ s/[()]//g;
        $c = do_calc(split(//, $c));
        $calc =~ s/XX/$c/;
        $calc =~ s/(\d+(\+\d+)+)/($1)/g;
    }
    push(@values, do_calc(split(//, $calc)));
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
        my $char = $calc[$i];
        if ($char =~ /[+*]/)
        {
            $operator = $char;
        }
        else
        {
            my $j = $i + 1;
            while (defined($calc[$j]) and $calc[$j] =~ /[0-9]/)
            {
                $char .= $calc[$j++];
                $i++;
            }
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

        $i++;
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
