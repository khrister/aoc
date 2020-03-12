#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

my @instructions = ();
my $level;
my $position = 1;
{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    my $line = <$fh>;
    close($fh);
    chomp $line;
    @instructions = split(//, $line);
}

foreach my $inst (@instructions)
{
    if ($inst eq '(')
    {
        $level++;
    }
    elsif ($inst eq ')')
    {
        $level--;
    }
    else
    {
        print "Wrong instruction $inst\n";
    }
    if ($level == -1)
    {
        print "Pos: $position\n";
        exit;
    }
    $position++;
}

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
