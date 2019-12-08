#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# Always use strict and warnings
use strict;
use warnings;
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);
use Algorithm::Permute qw/permute/;
use Time::HiRes qw( usleep );

my @cmd = ();
my $in;
my $out;
my $err;
my $max = 0;
my @best;
my $t;

my $file = shift @ARGV;


@cmd = ('./aoc7.pl', $file);

my @list = (5..9);

my $p_iterator = Algorithm::Permute->new ( \@list );

while (my @perm = $p_iterator->next)
{
    my $pwr = 0;
    my $pipeorig = $SIG{PIPE};
    $SIG{PIPE} = "IGNORE";
    my @handle;

    $out = "";
    for my $amp(0..4)
    {
        $in = $perm[$amp] . "\n"; 
        $handle[$amp] = start (\@cmd, \$in, \$out);
        $handle[$amp]->pump();
    }
    $in = "0\n";

 DONE:
    while (1)
    {
        foreach my $amp (0..4)
        {
            my $h = $handle[$amp];
            my $next = ($amp + 1) % 5;
#            print "About to pump $in to amp $amp\n";
#            D(\@in);
#            D($handle[$amp]);
#            D(\@in);
            eval { $handle[$amp]->pump() until ($out or !$handle[$amp]->pumpable); };
#            print "Pumped: $out\n";
            last DONE unless ($out);

            $in = $out;
            chomp $out;
            $pwr = $out;
            $out = "";
 #           print "pwr (intermediate) $pwr\n";
            #            usleep(100000);
            #            D($h);
        }
#        print "pwr $pwr\n";
    }
    if ($pwr > $max)
    {
        $max = $pwr;
        @best = @perm;
    }
    foreach my $amp (0..4)
    {
        eval { $handle[$amp]->finish() };
    }
    $SIG{PIPE} = $pipeorig;
}

print "$max\n";
print join(",", @best) . "\n";

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

Copyright Christer Boräng 2011

=cut
