#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( min );

my @cmds;
my %coords = ("0,0" => 1);
my $x = 0;
my $y = 0;

my $total = 0;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    my $cmdstr = <$fh>;
    chomp $cmdstr;
    @cmds = split(//, $cmdstr);
    close($fh);
}

foreach my $cmd (@cmds)
{
    if ($cmd eq '>')
    {
        $x++;
    }
    elsif ($cmd eq '<')
    {
        $x--;
    }
    elsif ($cmd eq '^')
    {
        $y++;
    }
    elsif ($cmd eq 'v')
    {
        $y--;
    }
    $coords{"$x,$y"} += 1;
}

print "" . (scalar keys %coords) . "\n";



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
