#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
use v5.16;
no warnings 'recursion';

# Other modules
use Data::Dumper;
use IO::Handle;

# Global variables
my @numbers = ();
my $ones = 0;
my $threes = 1;
my %checked = ();

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

print "Check: " . check(0) . "\n";;

# Recurse until we've checked all paths

sub check
{
    my $this = shift;
    # Cache already computed results
    return $checked{$this} if ($checked{$this});

    my $i = $this + 1;
    my $sum = 0;

    # Loop over the next three numbers if they match the criteria
    while ($i < @numbers && $i <= $this + 4 && $numbers[$i] <= $numbers[$this] + 3)
    {
        my $tmp = check($i);
        $sum += $tmp;
        $i++;
    }

    # There's always one path
    $sum = 1 unless ($sum);

    # Cache and return
    $checked{$this} = $sum;
    return $sum;
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
