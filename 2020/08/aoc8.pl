#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;

# Global variables
my @program;
my %done;
my $acc = 0;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;

    open($fh, '<', $file) or die "Couldn't open file $file";

    my $i = 0;
    while (my $input = <$fh>)
    {
        chomp $input;
        $program[$i] = [ split(/ /, $input) ];
        $i++;
    }
    close $file;
}

my $cur = 0;

while (1)
{
    last if ($done{$cur});
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

print "$acc\n";

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
