#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2019

# Always use strict and warnings
use strict;
use warnings;

# Other modules
use Carp;
use Data::Dumper;
use POSIX qw/floor ceil/;
use Text::Fuzzy;
use List::Util qw/max sum min/;
use List::MoreUtils 'first_index';
use Graph::Directed;
use Graph::Traversal::BFS;

# Global variables
my @lines;
my %child_of = ();
my %parent_of = ();
my @available = ();
my $order = "";
my %visited = ();
my @elf = ();
my @work = ();
my $basetime = 0;
my $next_tick = 0;
my $last_tick = 0;

{
    croak("Usage: $0 <number of elves> <base amount of seconds>")
        unless (@ARGV == 3);
    my $file = shift @ARGV;
    my $number_of_elves = shift @ARGV;
    @elf = (0) x $number_of_elves;
    @work = ("") x $number_of_elves;
    $basetime = shift;
    open(my $fh, '<', $file) or die "Couldn't open file $file";
    @lines = <$fh>;
    chomp(@lines);
    close ($fh);

    my %is_child = ();
    foreach my $line (@lines)
    {
        my ($parent, $child);
        $line =~ s/Step ([A-Z]) must be finished before step ([A-Z]) can begin.//;
        $parent = $1;
        $child = $2;
        if ($child_of{$parent})
        {
            push(@{$child_of{$parent}}, $child);
        }
        else
        {
            $child_of{$parent} = [$child];
        }
        $is_child{$child} = 1;
        if ($parent_of{$child})
        {
            push(@{$parent_of{$child}}, $parent);
        }
        else
        {
            $parent_of{$child} = [$parent];
        }
    }
    foreach my $p (keys %child_of)
    {
        next if ($is_child{$p});
        print "Found a start: $p\n";
        push(@available, $p);
    }
}

#D(\@elf);
#D(\@work);

@available = sort @available;

# Loop until we've completed all instructions
while (length($order) < scalar(keys %child_of) + 1)
{
    # Loop through the elves and take care of what they've done
    my $i = 0;
    while ($i < @elf)
    {
        $elf[$i] -= ($next_tick - $last_tick);
        $elf[$i] = 0 if ($elf[$i] < 0);

        # If the elf is done...
        if ($elf[$i] == 0)
        {
            # ...and they actually worked on something...
            if ($work[$i])
            {
                # Put it in the outbin and mark it as done
                $order .= $work[$i];
                $visited{$work[$i]} = 2;
                # Add children of the work to the candidates, maybe
                my @new = ();
                if ($child_of{$work[$i]})
                {
                    foreach my $candidate (@{$child_of{$work[$i]}})
                    {
                        my $done = 1;
                        foreach my $p (@{$parent_of{$candidate}})
                        {
                            $done = 0 unless ($visited{$p} and $visited{$p} == 2);
                        }
                        push(@new, $candidate)
                            if ($done);
                    }
                    # And sort the new available children into the list
                    @available = sort(@available, @new);
                }
                # And mark the elf as not working on anything
                $work[$i] = "";
            }
        }
        $i++;
    }

    # And then loop through them again to start them on new jobs
    $i = 0;
    while ($i < @elf)
    {
        if ($elf[$i] == 0)
        {
            my $cur = shift @available;
            if ($cur)
            {
                if (!$visited{$cur})
                {
                    $visited{$cur} = 1;
                }
                $work[$i] = $cur;
                my $c = cost($cur);
                $elf[$i] = $c;
            }
        }
        $i++;
    }

    # And finally check when the next item will be finished
    $last_tick = $next_tick;
    $next_tick += min(grep { $_ != 0 } @elf) if (grep { $_ != 0 } @elf);
}

print "$order\n";
print "$next_tick $last_tick\n";

sub cost
{
    my $c = shift;
    return ord($c) - 64 + $basetime;
}

#debug function
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
