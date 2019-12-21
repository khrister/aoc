#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Data::Dumper;
use IO::Prompter;
use POSIX qw/floor ceil/;
use IO::Handle;

# Global variables
my @prog;

STDOUT->autoflush(1);

my %func_op = (1 => \&{"add"},
               2 => \&{"multiply"},
               3 => \&{"input"},
               4 => \&{"output"},
               5 => \&{"jump_if_true"},
               6 => \&{"jump_if_false"},
               7 => \&{"less_than"},
               8 => \&{"equals"},
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
    # print STDERR $op . "\n";
    if ($func_op{$op})
    {
        $pos = $func_op{$op}($pos, $modes);
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
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));
    $prog[$prog[$pos + 3]] = $val1 + $val2;
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
    $prog[$prog[$pos + 3]] = $val1 * $val2;
    return $pos + 4;
}

sub input
{
    my $pos = shift;
    my $modes = shift;

    my $addr = $prog[$pos + 1];
    my $val = prompt('-iv', "");
    $prog[$addr] = $val;
#    print STDERR "Input received: $val\n";
    return $pos + 2;
}

sub output
{
    my $pos = shift;
    my $modes = shift;
#    print "output: pos $pos, modes $modes\n";
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

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    my $res = 0;
    if ($val1 < $val2)
    {
        $res = 1;
    }

    $prog[$prog[$pos + 3]] = $res;

    return $pos + 4;
}

sub equals
{
    my $pos = shift;
    my $modes = shift;
    my $val1;
    my $val2;

    $val1 = fetch($pos + 1, substr($modes, -1));
    $val2 = fetch($pos + 2, substr($modes, -2, 1));

    my $res = 0;

    if ($val1 == $val2)
    {
        $res = 1;
    }

    $prog[$prog[$pos + 3]] = $res;

    return $pos + 4;
}

# fetch data from $addr or what $addr points at
sub fetch()
{
    my $addr = shift;
    my $mode = shift;
    if ($mode)
    {
        return $prog[$addr];
    }
    else
    {
        return $prog[$prog[$addr]];
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
