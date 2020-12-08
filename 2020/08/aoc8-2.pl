#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;
use Clone 'clone';

# Global variables
my @orig_program;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;

    open($fh, '<', $file) or die "Couldn't open file $file";

    my $i = 0;
    while (my $input = <$fh>)
    {
        chomp $input;
        $orig_program[$i] = [ split(/ /, $input) ];
        $i++;
    }
    close $file;
}

my $line_changed = 0;

PROGRAM:
while ($line_changed < @orig_program)
{
    my @program = @{ clone(\@orig_program) };
    my $oinst = $program[$line_changed]->[0];

    if ($oinst =~ m/(jmp|nop)/)
    {
        if ($oinst eq "jmp")
        {
            $program[$line_changed]->[0] = "nop";
        }
        else
        {
            $program[$line_changed]->[0] = "jmp";
        }
        $line_changed++;
    }
    else
    {
        $line_changed++;
        next PROGRAM;
    }

    my $cur = 0;
    my $loop = 0;
    my $acc = 0;
    my %done;
    INST:
    while ($cur < @program)
    {
        if ($done{$cur})
        {
            $loop = 1;
            last INST;
        }
        $done{$cur} = 1;
        my ($inst, $arg) = @{$program[$cur]};
        if ($inst eq "nop")
        {
            $cur++;
        }
        elsif ($inst eq "acc")
        {
            $acc += $arg;
            $cur++;
        }
        elsif ($inst eq "jmp")
        {
            $cur += $arg;
        }
    }
    if ($loop)
    {
        next PROGRAM;
    }
    print "Working program found, acc = $acc\n";
    last PROGRAM;
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
