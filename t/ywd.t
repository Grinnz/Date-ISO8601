use Test::More tests => 1 + 3*12 + 5 + 6*21 + 4;

BEGIN {
	use_ok "Date::ISO8601",
		qw(year_weeks cjdn_to_ywd ywd_to_cjdn present_ywd);
}

use Math::BigInt;
use Math::BigRat;

my @prep = (
	sub { $_[0] },
	sub { Math::BigInt->new($_[0]) },
	sub { Math::BigRat->new($_[0]) },
);

sub check_weeks($$) {
	my($y, $yw) = @_;
	foreach my $prep (@prep) {
		is year_weeks($prep->($y)), $yw;
	}
}

check_weeks(-1994, 52);
check_weeks(-1993, 52);
check_weeks(-1991, 53);
check_weeks(-1985, 53);
check_weeks(-1980, 53);
check_weeks(-1975, 52);
check_weeks(2006, 52);
check_weeks(2007, 52);
check_weeks(2009, 53);
check_weeks(2015, 53);
check_weeks(2020, 53);
check_weeks(2025, 52);

eval { ywd_to_cjdn(2006, 0, 1); };
like $@, qr/\Aweek number /;
eval { ywd_to_cjdn(2006, 53, 1); };
like $@, qr/\Aweek number /;
eval { ywd_to_cjdn(2009, 54, 1); };
like $@, qr/\Aweek number /;
eval { ywd_to_cjdn(2000, 1, 0); };
like $@, qr/\Aday number /;
eval { ywd_to_cjdn(2000, 1, 8); };
like $@, qr/\Aday number /;

sub check_conv($$$$) {
	my($cjdn, $y, $w, $d) = @_;
	foreach my $prep (@prep) {
		is_deeply [ cjdn_to_ywd($prep->($cjdn)) ],
			[ $prep->($y), $w, $d ];
		is_deeply [ $prep->($cjdn) ],
			[ ywd_to_cjdn($prep->($y), $w, $d) ];
	}
}

check_conv(0, -4713, 48, 1);
check_conv(1721060, -1, 52, 6);
check_conv(2406029, 1875, 20, 4);
check_conv(2441317, 1971, 52, 5);
check_conv(2441318, 1971, 52, 6);
check_conv(2441319, 1971, 52, 7);
check_conv(2441320, 1972, 1, 1);
check_conv(2441683, 1972, 52, 7);
check_conv(2441684, 1973, 1, 1);
check_conv(2442047, 1973, 52, 7);
check_conv(2442048, 1974, 1, 1);
check_conv(2442049, 1974, 1, 2);
check_conv(2443139, 1976, 52, 7);
check_conv(2443140, 1976, 53, 1);
check_conv(2443141, 1976, 53, 2);
check_conv(2443142, 1976, 53, 3);
check_conv(2443143, 1976, 53, 4);
check_conv(2443144, 1976, 53, 5);
check_conv(2443145, 1976, 53, 6);
check_conv(2443146, 1976, 53, 7);
check_conv(2443147, 1977, 1, 1);

is present_ywd(2406029), "1875-W20-4";
is present_ywd(1875, 20, 4), "1875-W20-4";
is present_ywd(2441320), "1972-W01-1";
is present_ywd(1972, 1, 1), "1972-W01-1";
