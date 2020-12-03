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
my $width;
my $height;
my %tree_at;
my @rights = (1, 3, 5, 7, 1);
my @downs = (1, 1, 1, 1, 2);
my $mul = 1;

STDOUT->autoflush(1);


{
    my $fh;
    my $y = 0;
    my $file = shift @ARGV;

    open($fh, '<', $file) or die "Couldn't open file $file";
    while (my $input = <$fh>)
    {
        chomp $input;
        $width = length($input)
            unless ($width);

        my $x = 0;
        foreach my $point (split("", $input))
        {
            if ($point eq "#")
            {
                $tree_at{"$x:$y"} = 1;
            }
            $x++;
        }
        $y++;
    }
    close $file;
    $height = $y;
}

my $r = 0;
while ($r < @rights)
{
    my $trees_hit;
    my $cury = 0;
    my $curx = 0;
    while ($cury < $height)
    {
        my $tree = $tree_at{"$curx:$cury"};
        if ($tree)
        {
            #print "Tree found at $curx:$cury\n";
            $trees_hit++;
        }
        #print "No tree at $curx:$cury\n";
        $cury += $downs[$r];
        $curx = ($curx + $rights[$r]) % $width;
    }
    print "$trees_hit in $r\n";
    $mul *= $trees_hit;
    $r++;
}

print "Total mul gives: $mul\n";


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
