#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw( sum );
use Algorithm::Permute qw/permute/;

my $str;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
    $str = <$fh>;
    chomp $str;
    close($fh);
}

# print "$str\n";

foreach my $i (1..50)
{
    my $newstr = "";
    my @chars = split(//, $str);
    my $idx = 0;
    my $curstr = "";
    my $curnum = 0;

    if (length($str) == 1)
    {
        $str = "1" . $str;
        next;
    }
#    print "str $str\n";
 STR:
    while ($idx <= length($str))
    {
        if ($idx == length($str))
        {
            $newstr .= $curnum;
            $newstr .= $curstr;
            last STR;
        }
        my $new = $chars[$idx];
        if (!$curstr)
        {
            $curstr = $new;
            $curnum = 1;
        }
        elsif ($new eq $curstr)
        {
            $curnum++;
        }
        elsif ($curnum)
        {
            $newstr .= $curnum;
            $newstr .= $curstr;
            $curstr = "$new";
            $curnum = 1;
        }
        else
        {
            print "Uh oh why are we here\n";
        }
#        print "c $curstr n $newstr idx $idx\n";
        $idx++;
    }
    $str = $newstr;
#    print "$i: $str\n";
}

print "Length: " . length($str) . "\n";

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
