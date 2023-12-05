#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum any);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

my $letters = join("", 'a' .. 'z');
my $letters2 = $letters . $letters;

# Global variables
my $sum = 0;

{
    my $file = shift @ARGV;
    open(my $fh, '<', $file) or die "Can't open file $file";
 LINE:
    while (my $line = <$fh>)
    {
        chomp $line;
        my $roomname;
        my $room;
        my $checksum;
        my $id;
        ($roomname, $checksum) = split(/\[/, $line);
        $checksum =~ s/\]//;
        ($id = $roomname) =~ s/^[a-z-]+\-//;
        $roomname =~ s/-[0-9]+//g;
        ($room = $roomname) =~ s/-//g;

        my %chars = ();
        foreach my $char (split(//, $room))
        {
            $chars{$char}++;
        }
        my @check = reverse sort { $chars{$a} <=> $chars{$b} or $b cmp $a } keys %chars;
        my $last = $chars{$check[4]};
        foreach my $i (0 .. $#check)
        {
            my $a = $check[$i];
            my $b = $chars{$a};
        }
    CHECK:
        foreach my $i (5 .. $#check)
        {
            if (defined($check[$i]))
            {
                next if ($chars{$check[$i]} == $last);
                @check = @check[0..($i - 1)];
                last CHECK;
            }
        }
        my $index = -1;
        foreach my $char (split(//, $checksum))
        {
            my $cur = first_index { /$char/ } @check;
            if ($cur == -1 or $cur < $index)
            {
                next LINE;
            }
            $index = $cur;
        }
        my $rot = $id % 26;
        my $key = substr($letters2, $rot, 26);
        eval "\$roomname =~ tr/$letters/$key/";
        $roomname =~ tr/-/ /;
        if ($roomname eq "northpole object storage")
        {
            print "$id\n";
            last LINE;
        }
    }
    close($fh);
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

Copyright Christer Boräng 2023

=cut
