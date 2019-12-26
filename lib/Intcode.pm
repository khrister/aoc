package Intcode;

use version; our $VERSION = qv('0.2.0');

use warnings;
use strict;
no warnings 'substr';

use base qw( Exporter );
our @EXPORT_OK = qw( encode decode );

use Class::Std;
{
    use Data::Dumper;
    use IO::Handle;

    # Global variables
    my %relbase_of  : ATTR;  # Relative base
    my %program_of  : ATTR( :get<program> );;  # Program
    my %pos_of      : ATTR;  # position

    my %status   : ATTR( :get<status> );  # status 0 = running
                                          # status 1 = waiting for input
                                          # status 2 = done with program
    my %func_op = (1 => \&{"add"},
                   2 => \&{"multiply"},
                   3 => \&{"input"},
                   4 => \&{"output"},
                   5 => \&{"jump_if_true"},
                   6 => \&{"jump_if_false"},
                   7 => \&{"less_than"},
                   8 => \&{"equals"},
                   9 => \&{"movebase"},
                   99 => \&{"done"});
    my %out_of      : ATTR;
    my %in_of       : ATTR; # Input data

    sub BUILD
    {
        my ($self, $ident, $arg_ref) = @_;

        my @tmp = split(/,/, $arg_ref->{"program"});
        $program_of{ident $self} = \@tmp;
        $pos_of{ident $self} = 0;
        $out_of{ident $self} = [];
        $in_of{ident $self} = $arg_ref->{"input"};
        $relbase_of{ident $self} = 0;
        $status{ident $self} = 0;
    }

    sub run
    {
        my $self = shift;
        my @in = @_;

        return if ($status{ident $self} == 2);

        $in_of{ident $self} = \@in;

        $status{ident $self} = 0;

        while (1)
        {
            my $stat = $status{ident $self};
            if ($stat == 0)
            {
                $pos_of{ident $self} = do_op($self, $pos_of{ident $self}, $program_of{ident $self}->[$pos_of{ident $self}]);
            }
            elsif ($stat == 1)
            {
                return $out_of{ident $self};
            }
            elsif ($stat == 2)
            {
                return $out_of{ident $self}
            }
        }
    }

    sub do_op : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $op = shift;
        my $modes = shift || 0;


        # print "pos $pos, op $op, modes $modes\n";

        if ($func_op{$op})
        {
            $pos = $func_op{$op}($self, $pos_of{ident $self}, $modes);
        }
        elsif ($op > 99)
        {
            my $lop = $op % 100;
            my $mode = substr($op, 0, -2);
            $pos = do_op($self, $pos, $lop, $mode);
        }
        else
        {
            print "Bad \$op: $op\n";
            D(\$program_of{ident $self});
            print "Bad \$op: $op, pos: $pos, modes: $modes\n";
            exit;
        }
        return $pos;
    }

    sub add : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;

        $val1 = fetch($self,$pos + 1, substr($modes, -1));
        $val2 = fetch($self,$pos + 2, substr($modes, -2, 1));
        writemem($self, $pos + 3, substr($modes, -3, 1), $val1 + $val2);

        return $pos + 4;
    }

    sub multiply : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;

        $val1 = fetch($self,$pos + 1, substr($modes, -1));
        $val2 = fetch($self,$pos + 2, substr($modes, -2, 1));
        writemem($self, $pos + 3, substr($modes, -3, 1), $val1 * $val2);

        return $pos + 4;
    }

    sub input : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $addr;
        my $val;

        $addr = $program_of{ident $self}->[$pos + 1];
        if ($in_of{ident $self} and @{$in_of{ident $self}})
        {
            $val = shift $in_of{ident $self};
        }
        else
        {
            $status{ident $self} = 1;
            return $pos;
        }
        writemem($self, $pos + 1, $modes, $val);

        return $pos + 2;
    }

    sub output : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        push(@{$out_of{ident $self}}, fetch($self,$pos + 1, $modes));
        return $pos + 2;
    }

    sub jump_if_true : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;

        $val1 = fetch($self,$pos + 1, substr($modes, -1));
        $val2 = fetch($self,$pos + 2, substr($modes, -2, 1));

        if ($val1)
        {
            return $val2;
        }
        return $pos + 3;
    }

    sub jump_if_false : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;

        $val1 = fetch($self,$pos + 1, substr($modes, -1));
        $val2 = fetch($self,$pos + 2, substr($modes, -2, 1));

        if (!$val1)
        {
            return $val2;
        }
        return $pos + 3;
    }

    sub less_than : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;
        my $addr;

        $val1 = fetch($self,$pos + 1, substr($modes, -1));
        $val2 = fetch($self,$pos + 2, substr($modes, -2, 1));

        my $res = 0;
        if ($val1 < $val2)
        {
            $res = 1;
        }

        writemem($self, $pos + 3, substr($modes, -3, 1), $res);

        return $pos + 4;
    }

    sub equals : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val1;
        my $val2;
        my $addr;

        $val1 = fetch($self, $pos + 1, substr($modes, -1));
        $val2 = fetch($self, $pos + 2, substr($modes, -2, 1));

        my $res = 0;

        if ($val1 == $val2)
        {
            $res = 1;
        }

        writemem($self, $pos + 3, substr($modes, -3, 1), $res);

        return $pos + 4;
    }

    sub movebase : PRIVATE
    {
        my $self = shift;
        my $pos = shift;
        my $modes = shift;
        my $val;
        $val = fetch($self,$pos + 1, $modes);

        $relbase_of{ident $self} += $val;

        return $pos + 2;
    }

    # write to memory
    sub writemem : PRIVATE
    {
        my $self = shift;
        my $cell = shift;
        my $mode = shift;
        my $val = shift;

        my $addr = $program_of{ident $self}->[$cell];

        # If mode is 0, write to $addr
        if (!$mode)
        {
            $program_of{ident $self}->[$addr] = $val;
        }
        # If mode is 2, write to $addr + $relbase
        elsif($mode == 2)
        {
            $program_of{ident $self}->[$addr + $relbase_of{ident $self}] = $val;
        }
    }

    # fetch data from $addr or what $addr points at
    sub fetch : PRIVATE
    {
        my $self = shift;
        my $cell = shift;
        my $mode = shift;
        my $addr = $program_of{ident $self}->[$cell];

        # If mode is 0, fetch from what $addr points to
        if (!$mode)
        {
            my $ret = $program_of{ident $self}->[$addr];
            $ret = 0 if (!defined($ret) or !$ret);
            return $ret;
        }
        # If mode is 1, fetch from $addr directly
        elsif ($mode == 1)
        {
            $addr = 0 if (!defined($addr) or !$addr);
            return $addr;
        }
        # If mode is 2, fetch from what $addr + $relbase points to
        elsif ($mode == 2)
        {
            my $ret = $program_of{ident $self}->[$addr + $relbase_of{ident $self}];
            $ret = 0 if (!defined($ret) or !$ret);
            return $ret;
        }
    }

    sub done : PRIVATE
    {
        my $self = shift;
        $status{ident $self} = 2;
    }

    sub decode
    {
        my $out = shift;
        foreach my $chr (@$out)
        {
            #    D(\$chr);
            if ($chr < 128)
            {
                print chr(int($chr));
            }
            else
            {
                print "$chr\n";
            }
        }
    }

    sub encode
    {
        my $str = shift;
        my @res = ();

        my @entities = split(//, $str);
        foreach my $en (@entities)
        {
            push(@res,ord("$en"));
        }
        push(@res, 10);
        return @res;
    }

    # Debug function
    sub D
    {
        my $str = shift;
        print Dumper($str);
    }
}
1;

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
