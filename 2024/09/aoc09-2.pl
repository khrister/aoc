#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use feature 'say';

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);
use Array::Compare;
use Algorithm::Combinatorics qw (combinations);;

# Global variables

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my $line = <$fh>;
    close($fh);

    chomp $line;
    my @map = split(//, $line);
    my $first_free = 0;
    my $last_used;
    my @fs;
    my $id = 0;
    my @new_fs;

    while (my $c = shift(@map))
    {
        push(@fs, ($id++) x $c);
        my $free = shift(@map);
        last if (! defined($free));
        push(@fs, ('.') x $free);
    }
    $last_used = $#fs;

    #D(\@fs);
    #say join(",", @fs[($#fs - 40) .. $#fs]);
 FS:
    while ($first_free <= $last_used)
    {
        while ($fs[$first_free] ne ".")
        {
            push(@new_fs, $fs[$first_free]);
            $first_free++;
            last FS if ($first_free > $last_used);
        }
        while ($fs[$last_used] eq ".")
        {
            $last_used--;
            last FS if ($first_free > $last_used);
        }
        push(@new_fs, $fs[$last_used]);
        #say "$first_free $last_used";
        $first_free++;
        $last_used--;
    }
    #D(\@new_fs);
    #say join(",", @new_fs[($#new_fs - 100) .. $#new_fs]);
    my $total;
    for (my $i = 0; $i <= $#new_fs; $i++)
    {
        $total += $i * $new_fs[$i];
    }
    say $total;
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

Copyright Christer Boräng 2023

=cut
