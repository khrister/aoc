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
use List::MoreUtils qw (first_index any);
use Array::Utils qw(:all);
use Array::Compare;

# Global variables

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    my @ordering;
    my @badupdate;
    my $sum;

    while ((my $line = <$fh>) !~ /^$/)
    {
        chomp $line;

        # For part 1
        $line =~ s/([0-9]+)\|([0-9]+)/$2.*$1/;
        push(@ordering, $line);
    }
    #D(\@ordering);
 UPDATE:
    while(my $line = <$fh>)
    {
        chomp $line;
        foreach my $order (@ordering)
        {
            #say "$line $order";
            if ($line =~ /$order/)
            {
                push(@badupdate, $line);
                next UPDATE;
            }
        }
        #say "$line correct";
        my @update = split(/,/, $line);
        $sum += $update[$#update / 2];
    }
    say $sum;

    $sum = 0;
    foreach my $update (@badupdate)
    {
        my @newupdate;
        my @values = split(/,/, $update);

    CHECK:
        while(1)
        {
            my $error;
            foreach my $order (@ordering)
            {
                my ($a, $b) = check_order($update, $order);
                if ($a)
                {
                    $update =~ s/($a)(.*)($b)/$3$2$1/;
                    $error++;
                }
            }
            last CHECK unless($error);
            #say $update;
        }
        #say $update;
        my @update = split(/,/, $update);
        $sum += $update[$#update / 2];
    }
    say $sum;
    close($fh);
}

sub check_order
{
    my $update = shift;
    my $order = shift;
    if ($update =~ /$order/)
    {
        #say "Wrong order: $order, $update";
        return split(/\.\*/, $order);
    }
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
