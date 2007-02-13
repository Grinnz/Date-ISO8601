use Test::More tests => 1 + 3*14;

BEGIN { use_ok "Date::ISO8601", qw(present_y); }

use Math::BigInt;
use Math::BigRat 0.02;

my @prep = (
	sub { $_[0] },
	sub { Math::BigInt->new($_[0]) },
	sub { Math::BigRat->new($_[0]) },
);

sub check($$) {
	my($y, $pres) = @_;
	foreach my $prep (@prep) {
		is present_y($prep->($y)), $pres;
	}
}

check(-123456, "-123456");
check(-12345, "-12345");
check(-1234, "-1234");
check(-123, "-0123");
check(-12, "-0012");
check(-1, "-0001");
check(0, "0000");
check(1, "0001");
check(12, "0012");
check(123, "0123");
check(1234, "1234");
check(12345, "+12345");
check(123456, "+123456");
check("+00000123", "0123");
