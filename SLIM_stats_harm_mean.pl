
#/bin/perl
use warnings;
use strict;
#read in phenotypes
my $file = $ARGV[0];
my $gen = $ARGV[1];
my $time = $ARGV[2];
my $start= $gen-$time;

my %pheno=();
my %pheno1=();

open FILE, $file;
while (<FILE>){
       	chomp;
	my @split=split;
       	if(/Pop/ || /^\s*$/ ){
       		#print"skip $_\n";
	}elsif(/gen/){
       		#print"skip $_\n";
	}else{
		if($split[1] <= $gen){
			$pheno{$split[1]}=$split[2];
			if($split[1] >= $start){
				$pheno1{$split[1]}=$split[2];
			}
		}
	}
}	


sub harmonic_mean {
  my $sum_k=0;
  my $count=0;
  my (%hash) = @_;
        foreach my $key ( keys %hash ) {
                $sum_k=$sum_k+(1/$hash{$key}) ;
                $count++;
        }
	my $h_mean=$count/$sum_k;
        my @h_mean=($h_mean, $count);
	return (@h_mean);
}

my @array=harmonic_mean(%pheno);
my @array1=harmonic_mean(%pheno1);

print "@array @array1\n";
