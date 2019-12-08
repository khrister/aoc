#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# This is an earlier version of what is in 7/aoc7.pl
# before the refactorisation


# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use IO::Prompter;
use POSIX qw/floor ceil/;

# Global variables
my @prog;

my %func_op = (1 => \&{"add"},
               2 => \&{"multiply"},
               3 => \&{"input"},
               4 => \&{"output"},
               5 => \&{"jump_if_true"},
               6 => \&{"jump_if_false"},
               7 => \&{"less_than"},
               8 => \&{"equals"},
               99 => sub { exit; });

D(\%func_op);

my $fh;
my $file = shift @ARGV;
open($fh, '<', $file)
    or die("Could not open $file: ");

while (my $line = <$fh>)
{
    my @program = ();
    chomp $line;
    @program = split(/,/, $line);
    run_program(@program);
}
close $fh;

sub run_program
{
    @prog = @_;
    my $pos = 0;
    while (1)
    {
 #       print "run_program: pos $pos\n";
 #       D(\@prog);
        $pos = do_op($pos, $prog[$pos]);
    }
}

sub do_op
{
    my $pos = shift;
    my $op = shift;
    my $modes = shift || 0;

    die("pos not in prog anymore")
        if ($pos > scalar @prog);

#    D(\@prog);
    if ($op == 1)
    {
        $pos += $func_op{1}($pos, $modes);
#        $pos += add($pos, $modes);
    }
    elsif ($op == 2)
    {
        $pos += multiply($pos, $modes);
        }
    elsif ($op == 3)
    {
        $pos += input($pos, $modes);
    }
    elsif ($op == 4)
    {
        $pos += output($pos, $modes);
    }
    elsif ($op == 5)
    {
        $pos = jump_if_true($pos, $modes);
    }
    elsif ($op == 6)
    {
        $pos = jump_if_false($pos, $modes);
    }
    elsif ($op == 7)
    {
        $pos += less_than($pos, $modes);
    }
    elsif ($op == 8)
    {
        $pos += equals($pos, $modes);
    }
    elsif ($op == 99)
    {
        #        D(\@prog);
        exit();
    }
    elsif ($op =~ /^\d\d\d+$/)
    {
        my $lop = $op % 100;
        my $mode = substr($op, 0, -2);
        $pos = do_op($pos, $lop, $mode);
    }
    else
    {
        print "Bad \$op: $op\n";
        D(\@prog);
        exit;
    }
    return $pos;
}

sub add
{
    my $pos = shift;
    my $modes = shift;
    my $res;

    if (!$modes)
    {
        $res = $prog[$prog[$pos + 1]] + $prog[$prog[$pos + 2]];
    }
    else
    {
        my $val1;
        my $val2;
        if ($modes % 10)
        {
            $val1 = $prog[$pos + 1];
        }
        else
        {
            $val1 = $prog[$prog[$pos + 1]];
        }
        if (floor ($modes / 10))
        {
            $val2 = $prog[$pos + 2];
        }
        else
        {
            $val2 = $prog[$prog[$pos + 2]];
        }
        $res = $val1 + $val2;
    }
    $prog[$prog[$pos + 3]] = $res;
    return 4;
}

sub multiply
{
    my $pos = shift;
    my $modes = shift;
    my $res;
    if (!$modes)
    {
        $res = $prog[$prog[$pos + 1]] * $prog[$prog[$pos + 2]];
    }
    else
    {
        my $val1;
        my $val2;
        if ($modes % 10)
        {
            $val1 = $prog[$pos + 1];
        }
        else
        {
            $val1 = $prog[$prog[$pos + 1]];
        }
        if (floor ($modes / 10))
        {
            $val2 = $prog[$pos + 2];
        }
        else
        {
            $val2 = $prog[$prog[$pos + 2]];
        }
        $res = $val1 * $val2;
    }
    $prog[$prog[$pos + 3]] = $res;
    return 4;
}

sub input
{
    my $pos = shift;
    my $modes = shift;

    my $addr = $prog[$pos + 1];
    my $val = prompt('-iv', "Input into addr $addr:");
    $prog[$addr] = $val;
    return 2;
}

sub output
{
    my $pos = shift;
    my $modes = shift;
#    print "output: pos $pos, modes $modes\n";
    if ($modes % 10)
    {
        print $prog[$pos + 1] . "\n";
    }
    else
    {
        print $prog[$prog[$pos + 1]] . "\n";
    }
    return 2;
}

sub jump_if_true
{
    my $pos = shift;
    my $modes = shift;
    my $val;

    #    print "$pos $modes " . join(",", @prog[$pos..($pos+2)]) . "\n";
    if ($modes % 10)
    {
        $val = $prog[$pos + 1];
    }
    else
    {
        $val = $prog[$prog[$pos + 1]];
    }
    if ($val)
    {
        if (floor($modes / 10))
        {
            return $prog[$pos + 2];
        }
        else
        {
            return $prog[$prog[$pos + 2]];
        }
    }
    return $pos + 3;
}

sub jump_if_false
{
    my $pos = shift;
    my $modes = shift;
    my $val;

    if ($modes % 10)
    {
        $val = $prog[$pos + 1];
    }
    else
    {
        $val = $prog[$prog[$pos + 1]];
    }
    if (!$val)
    {
        if (floor($modes / 10))
        {
            return $prog[$pos + 2];
        }
        else
        {
            return $prog[$prog[$pos + 2]];
        }
    }
    return $pos + 3;
}

sub less_than
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;

    if ($modes % 10)
    {
        $val1 = $prog[$pos + 1];
    }
    else
    {
        $val1 = $prog[$prog[$pos + 1]];
    }
    if (floor ($modes / 10))
    {
        $val2 = $prog[$pos + 2];
    }
    else
    {
        $val2 = $prog[$prog[$pos + 2]];
    }

    my $res = 0;
    if ($val1 < $val2)
    {
        $res = 1;
    }

    $prog[$prog[$pos + 3]] = $res;

    return 4;
}

sub equals
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;


    if ($modes % 10)
    {
        $val1 = $prog[$pos + 1];
    }
    else
    {
        $val1 = $prog[$prog[$pos + 1]];
    }
    if (floor ($modes / 10))
    {
        $val2 = $prog[$pos + 2];
    }
    else
    {
        $val2 = $prog[$prog[$pos + 2]];
    }
    my $res = 0;

    if ($val1 == $val2)
    {
        $res = 1;
    }

    $prog[$prog[$pos + 3]] = $res;

    return 4;
}


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

Copyright Christer Boräng 2011

=cut
