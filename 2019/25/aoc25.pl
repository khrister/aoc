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
use Intcode qw ( decode encode );;

my $puzzlecode = "";

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    $puzzlecode = <$fh>;
    chomp $puzzlecode;
    close ($fh);
}

my $ic = Intcode->new({"program" => $puzzlecode});
my @inst;

while(1)
{
    if ($ic->get_status() == 2)
    {
        print "Game over!\n\n";
        exit;
    }
    my $res = $ic->run(@inst);
    decode($res);
    my $in = prompt("");
    $in = prep($in);
    @inst = encode($in);
}

sub prep
{
    my $s = shift;
    $s = "north" if ($s eq "n");
    $s = "south" if ($s eq "s");
    $s = "east" if ($s eq "e");
    $s = "west" if ($s eq "w");
    $s = "inv" if ($s eq "i");
    $s =~ s/^get /take /;
    return $s;
}

#sub decode
#{
#    my $out = shift;
#    foreach my $chr (@$out)
#    {
#        #    D(\$chr);
#        if ($chr < 128)
#        {
#            print chr(int($chr));
#        }
#        else
#        {
#            print "$chr\n";
#        }
#    }
#}
#
#sub encode
#{
#    my $str = shift;
#    my @res = ();
#
#    my @entities = split(//, $str);
#    foreach my $en (@entities)
#    {
#        push(@res,ord("$en"));
#    }
#    push(@res, 10);
#    return @res;
#}

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
