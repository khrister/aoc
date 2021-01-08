use feature "say"; use Math::Prime::Util qw(divisor_sum); $i=1; while (1) { $a =  divisor_sum($i); if ($a >= 3310000) { say "$i  $a"; exit; } $i++}
