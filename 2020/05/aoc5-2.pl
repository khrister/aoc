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
my @passes;
my $highest_id = 0;
my $lowest_id = 1000000;

my %ids;

STDOUT->autoflush(1);

{
    my $fh;
    my $file = shift @ARGV;

    open($fh, '<', $file) or die "Couldn't open file $file";

    while (my $input = <$fh>)
    {
        chomp $input;
        push(@passes, $input);
    }
    close $file;
}

foreach my $pass (@passes)
{
    my @chars = split(//, $pass);
    my @rowbits = @chars[0..6];
    my @colbits = @chars[7..9];

    my $id;
    my $row = 0;
    my $col = 0;
    my $pos = 0;

    while ($pos < 7)
    {
        my $bit = $rowbits[$pos];
        if ($bit eq "B")
        {
            $row += 2 ** (6 - $pos);
        }
        $pos++;
    }

    $pos = 0;

    while ($pos < 3)
    {
        my $bit = $colbits[$pos];
        if ($bit eq "R")
        {
            $col += 2 ** (2 - $pos);
        }
        $pos++;
    }
    $id = $row * 8 + $col;
    $ids{$id} = 1;
    $highest_id = $id if ($id > $highest_id);
    $lowest_id = $id if ($id < $lowest_id);
}

foreach my $id (($lowest_id + 1) .. ($highest_id - 1))
{
    next if ($ids{$id});
    next unless ($ids{$id - 1} and $ids{$id + 1});
    print "Seat id: $id\n";
    exit;
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

Copyright Christer Boräng 2019

=cut
