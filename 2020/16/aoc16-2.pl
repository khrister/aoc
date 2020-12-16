#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use feature 'bitwise';
#use bigint;
#use Math::BigInt;

use Data::Dumper;
use List::Util 'sum';
use List::MoreUtils qw (first_index);

# Array of hashes
my %fields = ();
my @tickets = ();
my @my_ticket = ();
my %possible_fields = ();
my %final_fields = ();

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);

    while (my $line = <$fh>)
    {
        chomp $line;
        last if ($line =~ /^$/);
        my $tmp;
        my $name;
        ($name, $tmp) = split(/: /, $line);
        # Split up into the two ranges
        my ($r1, $r2) = split(/ or /, $tmp);

        # Take the range and put it into a hash
        my ($r1s, $r1e) = split(/-/, $r1);
        my %h1 = map { $_ => 1 } $r1s..$r1e;

        # And again with the second range
        my ($r2s, $r2e) = split(/-/, $r2);
        my %h2 = map { $_ => 1 } $r2s..$r2e;

        $fields{$name} = {%h1, %h2};
    }

    <$fh>; # Get rid of "your ticket" line
    @my_ticket = split(/,/, <$fh>);

    <$fh>;<$fh>; # Get rid of empty line and "nearby tickets"

    while(my $line = <$fh>)
    {
        chomp $line;
        next if ($line !~ m/\d+,\d+/);
        my @values = split(/,/, $line);
        push(@tickets, [ @values ]);
    }
    close($fh);
}

{
    # More setup
    my $fn = keys %fields;
    my %hashpf = map { $_ => 1 } 0..($fn - 1);
    foreach my $f (keys %fields)
    {
        $possible_fields{$f} = { %hashpf };;
    }
}


# Get rid of invalid tickets
TICKET:
foreach my $ticket (@tickets)
{

 TICKETFIELD:
    foreach my $tf (@{$ticket})
    {
        foreach my $field (values %fields)
        {
            # If tf is in field, this part of the ticket is valid
            if ($field->{$tf})
            {
                next TICKETFIELD;
            }
        }
        # Discard ticket
        $ticket = undef;
        next TICKET;
    }
}

foreach my $ticket (@tickets)
{
    next unless ($ticket);

    my $i = 0;
    while ($i < @{$ticket})
    {
        my $tf = $ticket->[$i];
        foreach my $field (keys %fields)
        {
            if (! $fields{$field}->{$tf})
            {
                delete($possible_fields{$field}->{$i});
            }
        }
        $i++;
    }
}


my @sorted_fields= sort { %{$possible_fields{$a}} <=> %{$possible_fields{$b}} } keys %possible_fields;

foreach my $field (@sorted_fields)
{

    my $val = (keys %{$possible_fields{$field}})[0];
    $final_fields{$field} = $val;
    foreach my $f (values %possible_fields)
    {
        delete $f->{$val};
    }
}

my $mul = 1;
foreach my $field (@sorted_fields)
{
    next unless ($field =~ m/^departure/);
    $mul *= $my_ticket[$final_fields{$field}];
}

print "$mul\n";

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
