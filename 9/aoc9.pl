#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use IO::Prompter;
#use POSIX qw/floor ceil/;
use IO::Handle;

# Global variables
my @prog;
my $relbase = 0;

STDOUT->autoflush(1);

my %func_op = (1 => \&{"add"},
               2 => \&{"multiply"},
               3 => \&{"input"},
               4 => \&{"output"},
               5 => \&{"jump_if_true"},
               6 => \&{"jump_if_false"},
               7 => \&{"less_than"},
               8 => \&{"equals"},
               9 => \&{"movebase"},
               99 => sub { exit; });


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
        $pos = do_op($pos, $prog[$pos]);
    }
}

sub do_op
{
    my $pos = shift;
    my $op = shift;
    my $modes = shift || 0;

#    die("pos not in prog anymore")
#        if ($pos > scalar @prog);

    if ($func_op{$op})
    {
        $pos = $func_op{$op}($pos, $modes);
    }
    elsif ($op > 99)
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
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));
    writemem($pos + 3, substr($modes, -3, 1), $val1 + $val2);

    return $pos + 4;
}

sub multiply
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));
    writemem($pos + 3, substr($modes, -3, 1), $val1 * $val2);

    return $pos + 4;
}

sub input
{
    my $pos = shift;
    my $modes = shift;
    my $addr;

    $addr = $prog[$pos + 1];

    my $val = prompt('-iv', "");

    writemem($pos + 1, $modes, $val);

    return $pos + 2;
}

sub output
{
    my $pos = shift;
    my $modes = shift;
    print fetch($pos + 1, $modes) . "\n";
    return $pos + 2;
}

sub jump_if_true
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    if ($val1)
    {
        return $val2;
    }
    return $pos + 3;
}

sub jump_if_false
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    if (!$val1)
    {
        return $val2;
    }
    return $pos + 3;
}

sub less_than
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;
    my $addr;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    my $res = 0;
    if ($val1 < $val2)
    {
        $res = 1;
    }

    writemem($pos + 3, substr($modes, -3, 1), $res);

    return $pos + 4;
}

sub equals
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;
    my $addr;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    my $res = 0;

    if ($val1 == $val2)
    {
        $res = 1;
    }

    writemem($pos + 3, substr($modes, -3, 1), $res);

    return $pos + 4;
}

sub movebase
{
    my $pos = shift;
    my $modes = shift;
    my $val;
    $val = fetch($pos + 1, $modes);

    $relbase += $val;

    return $pos + 2;
}

# write to memory
sub writemem
{
    my $cell = shift;
    my $mode = shift;
    my $val = shift;
    my $addr = $prog[$cell];

    # If mode is 0, write to $addr
    if (!$mode)
    {
        $prog[$addr] = $val;
    }
    # If mode is 2, write to $addr + $relbase
    elsif($mode == 2)
    {
        $prog[$addr + $relbase] = $val;
    }
}

# fetch data from $addr or what $addr points at
sub fetch()
{
    my $cell = shift;
    my $mode = shift;
    my $addr = $prog[$cell];

    # If mode is 0, fetch from what $addr points to
    if ($mode == 0)
    {
        my $ret = $prog[$addr];
        $ret = 0 if (!defined($ret));
        return $ret;

    }
    # If mode is 1, fetch from $addr directly
    elsif ($mode == 1)
    {
        $addr = 0 if (!defined($addr));
        return $addr;
    }
    # If mode is 2, fetch from what $addr + $relbase points to
    elsif ($mode == 2)
    {
        my $ret = $prog[$addr + $relbase];
        $ret = 0 if (!defined($ret));
        return $ret;
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
