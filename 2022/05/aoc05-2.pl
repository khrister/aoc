#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2022

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

my @stacks = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

 STACKS:
    while (my $line = <$fh>)
    {
        chomp $line;
        if ($line !~ /\[/)
        {
            last STACKS;
        }

        # pos 1, 5, 9 etc
        for (my $i = 1; $i * 4 - 3 < length($line); $i++)
        {
            my $crate = substr($line, $i * 4 - 3, 1);
            push(@{$stacks[$i]}, $crate)
                if ($crate ne ' ');
        }
    }

    my $tmp = <$fh>;
    while (my $line = <$fh>)
    {
        chomp $line;
        my @moves = split(/ /, $line);

        # number of moves, from where, to where
        move($moves[1], $moves[3], $moves[5]);
    }
    close($fh);
}

my $out;
map { $out .= $_->[0] if ($_) } @stacks;
#D(\@stacks);
print "$out\n";

sub move
{
    my $moves = shift @_;
    my $from = shift @_;
    my $to = shift @_;

    my @crates = ();
    for (my $i = 0; $i < $moves; $i++)
    {
        push(@crates, shift(@{$stacks[$from]}));
    }
    unshift(@{$stacks[$to]}, @crates);
}




# Debug function
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
