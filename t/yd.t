use Test::More tests => 1 + 3*8 + 3 + 6*9 + 9;

BEGIN {
	use_ok "Date::ISO8601",
		qw(year_days cjdn_to_yd yd_to_cjdn present_yd);
}

use Math::BigInt 1.16;
use Math::BigRat 0.04;

sub match_val($$) {
	my($a, $b) = @_;
	ok ref($a) eq ref($b) && $a == $b;
}

sub match_vec($$) {
	my($a, $b) = @_;
	unless(@$a == @$b) {
		ok 0;
		return;
	}
	for(my $i = 0; $i != @$a; $i++) {
		my $aval = $a->[$i];
		my $bval = $b->[$i];
		unless(ref($aval) eq ref($bval) && $aval == $bval) {
			ok 0;
			return;
		}
	}
	ok 1;
}

my @prep = (
	sub { $_[0] },
	sub { Math::BigInt->new($_[0]) },
	sub { Math::BigRat->new($_[0]) },
);

sub check_days($$) {
	my($y, $yd) = @_;
	foreach my $prep (@prep) {
		match_val year_days($prep->($y)), $yd;
	}
}

check_days(-2000, 366);
check_days(-1999, 365);
check_days(-1996, 366);
check_days(-1900, 365);
check_days(2000, 366);
check_days(2001, 365);
check_days(2004, 366);
check_days(2100, 365);

eval { yd_to_cjdn(2000, 0); };
like $@, qr/\Aday number /;
eval { yd_to_cjdn(2000, 367); };
like $@, qr/\Aday number /;
eval { yd_to_cjdn(2001, 366); };
like $@, qr/\Aday number /;

sub check_conv($$$) {
	my($cjdn, $y, $d) = @_;
	foreach my $prep (@prep) {
		match_vec [ cjdn_to_yd($prep->($cjdn)) ], [ $prep->($y), $d ];
		match_vec [ $prep->($cjdn) ], [ yd_to_cjdn($prep->($y), $d) ];
	}
}

check_conv(0, -4713, 328);
check_conv(1721060, 0, 1);
check_conv(2406029, 1875, 140);
check_conv(2441317, 1971, 365);
check_conv(2441318, 1972, 1);
check_conv(2443144, 1976, 366);
check_conv(2443145, 1977, 1);
check_conv(2451544, 1999, 365);
check_conv(2451545, 2000, 1);

is present_yd(2406029), "1875-140";
is present_yd(1875, 140), "1875-140";
is present_yd(2451545), "2000-001";
is present_yd(2000, 1), "2000-001";

is present_yd(1233, 0), "1233-000";
is present_yd(1233, 366), "1233-366";
is present_yd(1233, 999), "1233-999";
eval { present_yd(1233, -1) }; isnt $@, "";
eval { present_yd(1233, 1000) }; isnt $@, "";
