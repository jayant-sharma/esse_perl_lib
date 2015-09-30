#!/usr/bin/perl


#####################################################################
# Print File Names
#####################################################################
#dir_walk('.', \&print_filename, \&print_filename);

sub print_filename {
	print $_[0], "\n";
}

#####################################################################
# Dangling symbolic link detector
#####################################################################
#dir_walk('.', \&dangles);

sub dangles {
	my $file = shift;
	print "$file\n" if -l $file && -e $file;
}

#####################################################################
# Compute total size of current directory
#####################################################################
#$total_size = dir_walk('.', \&file_size, \&dir_size);

sub file_size { -s $_[0] }

sub dir_size {
        my $dir = shift;
        my $total = -s $dir;
        my $n;
        for $n (@_) { total += $n }
        printf "%6d %s\n", $total, $dir;
        return $total;
}

#####################################################################
# Callback to produce hash structure of directory
#####################################################################
sub file {
	my $file = shift;
	[short($file), -s $file];
}

sub short {
	my $path = shift;
	$path =~ s{.*/}{};
	$path;
}

sub dir {
	my ($dir, @subdirs) = @_;
	my %new_hash;
	for (@subdirs) {
		my ($subdir_name, $subdir_structure) = @$_;
		$new_hash{$subdir_name} = $subdir_structure;
	}
	return [short($dir), \%new_hash];
}

#####################################################################
# Directory Structure Walking Function
#####################################################################
sub dir_walk {
	my ($top, $filefunc, $dirfunc) = @_;
	my $DIR;

	if (-d $top) {
		my $file;
		unless (opendir $DIR, $top) {
			warn "Couldn't open directory $top: $!;\n";
			return;
		}
		
		my @results;
		while ($file = readdir $DIR) {
			next if $file eq '.' || $file eq '..';
			push @results, dir_walk("$top/$file", $filefunc, $dirfunc);
		}
		return $dirfunc ? $dirfunc->($top, @results) : ();
	}
	else {
		return $filefunc ? $filefunc->($top) : ();
	}
}

