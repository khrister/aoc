#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;

# Other modules
use Data::Dumper;
use IO::Handle;
use Algorithm::Combinatorics qw(combinations);

# Global variables
my @numbers = ();
my $ones = 0;
my $threes = 1;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;
    open($fh, '<', $file) or die "Couldn't open file $file";
    @numbers = <$fh>;
    chomp @numbers;
    close $file;
}

push(@numbers, 0);
@numbers = sort { $a <=> $b } @numbers;

D(\@numbers);

my $i = 0;
while ($i < scalar(@numbers) - 1)
{
    my $cur = $numbers[$i];
    my $next = $numbers[$i + 1];
    $i++;
    if ($next - $cur == 1)
    {
        $ones++;
    }
    elsif ($next - $cur == 3)
    {
        $threes++;
    }
}

print "" . ($ones * $threes) . "\n";

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
