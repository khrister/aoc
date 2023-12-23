#!/usr/bin/env perl
# Copyright Christer Boräng (mort@chalmers.se) 2023

# Always use strict and warnings
use strict;
use warnings;
no warnings 'recursion';
use Data::Dumper;

# Other modules
use List::Util qw (max sum);
use List::MoreUtils qw (first_index uniq);
use Array::Utils qw(:all);

# Global variables
my @history;

{
    die "Usage: $0 <file>" unless (@ARGV == 1);
    my $file = shift @ARGV;

    my $fh;
    open($fh, '<', $file);
    while (my $line = <$fh>)
    {
        chomp $line;
        push(@history, [ split(" ", $line) ] );
    }
    close($fh);
}

foreach my $hist (@history)
{
    my @orig = $hist;
    while(uniq(@{ $orig[$#orig]}) > 1)
    {
        my @old = @{ $orig[$#orig] };
        my @tmp;
        for (my $i = 0; $i<$#old; $i++)
        {
            push(@tmp, $old[$i + 1] - $old[$i]);
        }
        push(@orig, [ @tmp ]);
    }

    for(my $i = $#orig; $i > 0; $i--)
    {
        my $new = $orig[$i-1]->[0] - $orig[$i]->[0];
        unshift(@{$orig[$i - 1]}, $new  );
    }
    $hist = $orig[0];
}

my $sum;

#D(\@history);
foreach my $res (@history)
{
    #D(\$res);
    my @tmp = @{$res};
    $sum += $tmp[0];
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
