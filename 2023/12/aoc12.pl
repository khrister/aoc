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

# Global variables
my @input;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my @sec  = split(/ /, $line);
        my $str  = $sec[0];
        my @nums = map {int} split( /,/, $sec[1] );
        push($input[1]->@*, {str => $str, groups => [@nums]});
        push($input[2]->@*, {str => $str . (('?'. $str) x 4), groups => [(@nums) x 5]});
    }
    close($fh);
}


my %memo;

sub recurse
{
    # str to process, current potential group length, groups left to see
    my ($str, $len, @groups) = @_;

    # Grab state of params called with to access memo with later.
    my $state = join( $;, $str, $len, @groups );

    # Check memo
    return ($memo{$state}) if (exists $memo{$state});

    my $ret = 0;

    if (!$str)
    {
        # Out of input, must decide if we found a match:
        # All groups accounted for, no hanging group.
        $ret = 1  if (@groups == 0 and $len == 0);

        # Check if hanging group is the size of the only remaining group:
        $ret = 1  if (@groups == 1 and $groups[0] == $len);

        return( $memo{$state} = $ret );
    }

    # If out of groups, use regex to check if no manditory groups remain
    return( $memo{$state} = ($str =~ m/^[^#]*$/) ) if (!@groups);

    # ASSERT: length($str) > 0, $len >= 0, @groups > 0

    # Advance one character:
    my $chr = substr( $str, 0, 1, '' );

    if ($chr ne '.') # ? or #
    {
        # adv making grouping larger
        $ret += &recurse( $str, $len + 1, @groups );
    }

    if ($chr ne '#') # ? or .
    {
        if ($len == 0) {
            # no current grouping, just advance
            $ret += &recurse( $str, 0, @groups );

        }
        elsif ($len == $groups[0])
        {
            # current grouping matches current target
            shift @groups;
            $ret += &recurse( $str, 0, @groups );
        }
        # else: Bad block length!  Fail match, recurse no further
    }

    return( $memo{$state} = $ret );
}

foreach (1 .. 2)
{
    say "Part $_: ", sum map { &recurse( $_->{str}, 0, $_->{groups}->@* ) } $input[$_]->@*;
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
