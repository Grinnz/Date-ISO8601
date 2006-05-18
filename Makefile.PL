use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "Date::ISO8601",
	VERSION_FROM => "lib/Date/ISO8601.pm",
	PREREQ_PM => {
		"Math::BigInt" => "1.64",
		"Math::BigRat" => "0.08",
	},
);
