#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IO::Prompter;
use List::Util 'max';
use File::FindLib 'lib/Intcode.pm';
use Intcode;

my %grid = ();
my %line_start_end = ();

my $sq = 0;
my $puzzlecode = "";

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    $puzzlecode = <$fh>;
    chomp $puzzlecode;
    close ($fh);
}

my $ic = Intcode->new({"program" => $puzzlecode});

my @code = (
    'NOT A T', # If there's no ground in front of the bot, set T
    'NOT C J', # If there's no ground at C, set J
    'OR T J',  # If T is set, set J
    'AND D J', # But only jump if there's ground at D
    'RUN');

my @inst = ();
foreach my $l (@code)
{
    push(@inst, encode($l));
}

my $res = $ic->run(@inst);

foreach my $chr (@$res)
{
#    D(\$chr);
    if ($chr < 128)
    {
        print chr(int($chr));
    }
    else
    {
        print "$chr\n";
    }
}

sub encode
{
    my $str = shift;
    my @res = ();

    my @entities = split(//, $str);
    foreach my $en (@entities)
    {
        push(@res,ord("$en"));
    }
    push(@res, 10);
    return @res;
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
