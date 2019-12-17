#!/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2010

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use IPC::Run qw( start pump finish timeout timer pumpable);
use IO::Prompter;
use List::Util 'max';

my @cmd = ();
my $in;
my $out;
my $err;
$SIG{PIPE} = "IGNORE";

my $robot;

my $dust = 0;

my $file = shift @ARGV;

@cmd = ('./intcode.pl', $file);

my $main = "A,B,A,B,C,C,B,A,B,C";
my $a = "L,12,L,10,R,8,L,12";
my $b = "R,8,R,10,R,12";
my $c = "L,10,R,12,R,8";

$in = "";

#Run the robot
$robot = start (\@cmd, \$in, \$out);

{
    my @input = encode($main);
    push(@input, encode($a));
    push(@input, encode($b));
    push(@input, encode($c));
    push(@input, encode("n"));

D(\@input);
    my $result = enter(@input);

    print "dust = $result\n";

}


# Done with the robot
eval { $robot->finish() };

sub enter
{
    my @cmds = @_;
    foreach my $cmd (@cmds)
    {
        print "Entering command $cmd\n";
        $out = "";
        $in = "$cmd\n";
        $robot->pump() until ( $out =~ /input:/ or !$robot->pumpable);
        #print $out;
    }
    $robot->pump() until ( $out =~ /input:/ or !$robot->pumpable); 
    return $out;
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

Copyright Christer Boräng 2011

=cut
