#!/usr/bin/perl

$num = $ARGV[0];
@position = ('', ('A')x$num);
hanoi($num, 'A', 'C', 'B', \&check_move);

###################################################################
# Callback function to check the validity of move
###################################################################
sub check_move {
	my $i;
	my ($disk, $start, $end) = @_;
	if ($disk < 1 || $disk > $#position) {
		die "Bad disk number $disk.\n";
	}
	unless ($position[$disk] eq $start) {
		die "Tried to move disk $disk from $start, but it is on peg $position[$disk].\n";
	}
	for $i (1 .. $disk-1) {
		if ($position[$i] eq $start) {
			die "Can't move disk $disk from $start because $i is on top of it.\n";
		}
		elsif ($position[$i] eq $end) {
			die "Can't move disk $disk to $end because $i is already there.\n";
		}
	}
	print "Moving disk $disk from $start to $end.\n";
	$position[$disk] = $end;
}

###################################################################
# Function for Hanoi Tower movement
###################################################################
sub hanoi {
	my ($n, $start, $end, $extra, $move_disk) = @_;
	if ($n == 1) {
		$move_disk->(1, $start, $end);
	}
	else {
		hanoi($n-1, $start, $extra, $end, $move_disk);
		$move_disk->($n, $start, $end);
		hanoi($n-1, $extra, $end, $start, $move_disk);
	}
}


