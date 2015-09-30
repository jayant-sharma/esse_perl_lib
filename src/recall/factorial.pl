#!/usr/bin/perl

$num = $ARGV[0];
my $f = factorial($num);
print "Value of $num! = $f\n";

sub factorial {
	my ($n) = @_;
	return 1 if $n == 0;
	return factorial($n-1)*$n;
}

