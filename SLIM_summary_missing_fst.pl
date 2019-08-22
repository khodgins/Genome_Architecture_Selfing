# perl SLIM_ out.txt m1.txt m2.txt m3.txt 100000 > fst_100.txt
#
#/bin/perl
use warnings;
use strict;
#files
#read in files

#read in mutations

my $out = $ARGV[0];
my $m1 = $ARGV[1];
my $m2 = $ARGV[2];
my $m3 = $ARGV[3];
my $gen = $ARGV[4];

my %out=();
open OUT, $out;

while (<OUT>){
	chomp;
	my @split = split;
	if($split[0] == $gen){
		if($split[9] > 0 && $split[9] < 1 ){
			$out{$split[1]}=$_;
		}
	}
}


#foreach my $k (keys %out){
#	print "$k $out{$k}\n";
#}
my %type=();
my %m1=();
open M1, $m1;
while (<M1>){
        chomp;
        if(/^#id/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
		if(exists $out{$split[4]} && $split[1] == $gen){
			$type{$split[4]}=$_;	
		}
	}
}

my %m2=();
open M2, $m2;
while (<M2>){
        chomp;
        if(/^#id/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
                if(exists $out{$split[4]} && $split[1] == $gen){
			$type{$split[4]}=$_;
		}
        }
}

my %m3=();
open M3, $m3;
while (<M3>){
        chomp;
        if(/^#id/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
                if(exists $out{$split[4]} && $split[1] == $gen){
                	$type{$split[4]}=$_;
		}
        }
}



for my $k (keys %out){
	print "$out{$k} $type{$k}\n";
}
