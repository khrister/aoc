#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index);
use Array::Utils qw(:all);

# Global variables
my $sum;
my @nums = qw(one two three four five six seven eight nine);

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        my $first;
        my $firstindex;
        my $last;
        my $lastindex;

        ($first = $line) =~ s/^[^0-9]*([0-9]).*$/$1/;
        $firstindex = $-[1];
#        print "first: $first => " . $-[1] . "\n";;
        if (! defined($firstindex))
        {
            $first = 0;
            $firstindex = length($line);
        }
#        print "$first $firstindex\n\n\n";

        ($last = $line) =~  s/^.*([0-9])[^0-9]*$/$1/;
        $lastindex = $-[1];

        if (! defined($lastindex))
        {
            $last = 0;
            $lastindex = 0;
        }
#        print "After fix: $last $lastindex\n";
#        print "$first $last : $firstindex $lastindex\n";
        for (my $i = 0; $i <= $#nums; $i++)
        {
            my $foo = index($line, $nums[$i]);
            if ($foo > -1 and $foo < $firstindex)
            {
                $firstindex = $foo;
                $first = $i + 1;
                #                print "First changed: $first $firstindex\n";
            }
            my $bar = rindex($line, $nums[$i]);
            # print "Checking " . $nums[$i] . " => $bar $i\n";
            if ($bar > -1 and $bar > $lastindex)
            {
                $lastindex = $bar;
                $last = $i + 1;
                # print "Last changed: $last $lastindex\n";
            }
        }
        # print "Loop done: $first $last : $firstindex $lastindex\n";
        $sum += $first * 10 + $last;
    }
    close($fh);
}

print "$sum\n";



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
