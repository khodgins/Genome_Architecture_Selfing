# perl SLIM_ fst_100.txt > fst_out_100.txt
#
#/bin/perl
use warnings;
use strict;
#files
#read in files

#read in mutations
use POSIX;
my $out = $ARGV[0];

my %out=();
my %fst=();
my %fst2=();
my $pos=0;
my @gene=();

for my $f (1..5000){
        my $start=$pos;
        $pos=$pos+999;
        push(@gene, $start);
        $pos=$pos+1+4000;
}

#cycle each postion and if =>start and =<end give gene name

my %gene=();
my $fixed=0;
my %type=();

open(my $out2, '>', 'fst_sum_20.txt') or die "Could not open file fst_sum_20.txt $!";


open OUT, $out;

while (<OUT>){
	
	chomp;
	my @split = split;
	$out{$split[1]}=$_;
	$fst{$split[1]}=$split[11];
	$type{$split[1]}=$split[17];
	if($split[11]== 1.0){
		$fixed++;
	}
	
	for my $k (0..$#gene){
		if($split[2] >= $gene[$k] && $split[2] <= ( $gene[$k]+999) ) {
			$gene{$split[1]}=$k+1;
		}
	}

	if($split[9] > 0.05){
		$fst2{$split[1]}=$split[11];
	}
}

my $size = keys %out;
my @keys = sort { $fst{$b} <=> $fst{$a} } keys(%fst);
my @vals = @fst{@keys};

my $length=$#keys;
my $one=sprintf("%.0f",($#keys*0.01)); #CHANGE FOR DIFFERENT CUT OFF
my $five=sprintf("%.0f",($#keys*0.05));
my $two5=sprintf("%.0f",($#keys*0.25));
my $fifty=sprintf("%.0f",($#keys*0.5));

print $out2 "$length $one $vals[$length] $fixed $vals[$one] $vals[$five] $vals[$two5] $vals[$fifty] $fixed ";

my @keys2 = sort { $fst2{$b} <=> $fst2{$a} } keys(%fst2);
my @vals2 = @fst2{@keys2};

my $length2=$#keys2;
my $one2=sprintf("%.0f",($#keys2*0.01)); #CHANGE FOR DIFFERENT CUT OFF
my $five2=sprintf("%.0f",($#keys2*0.05));
my $two52=sprintf("%.0f",($#keys2*0.25));
my $fifty2=sprintf("%.0f",($#keys2*0.5));

print $out2 "5% $length2 $one2 $vals2[$length2] $fixed $vals2[$one2] $vals2[$five2] $vals2[$two52] $vals2[$fifty2] $fixed ";

my %key_o=();
my %key_f=();
my %key_oc=();
my %key_fc=();
my $tpo=0;
my $tno=0;
my $fpo=0;
my $fno=0;

my $tpf=0;
my $tnf=0;
my $fpf=0;
my $fnf=0;

my $tpoc=0;
my $tnoc=0;
my $fpoc=0;
my $fnoc=0;

my $tpfc=0;
my $tnfc=0;
my $fpfc=0;
my $fnfc=0;


for my $k (0..$#keys){
	if($fst{$keys[$k]} >= $fst{$keys[$one]}){
		$key_o{$keys[$k]}='Y';
		if($type{$keys[$k]} eq 'm2'){
                                $tpo++;
                        }else{
                                $fpo++;
                        }

	}else{
		$key_o{$keys[$k]}='N';
		if($type{$keys[$k]} eq 'm2'){
                                $fno++;
                        }else{
                                $tno++;
                        }

	}
	if($fst{$keys[$k]} >= $fst{$keys[$five]}){	
		$key_f{$keys[$k]}='Y';
		if($type{$keys[$k]} eq 'm2'){
                                $tpf++;
                        }else{
                                $fpf++;
                        }

        }else{
                $key_f{$keys[$k]}='N';
		if($type{$keys[$k]} eq 'm2'){
                                $fnf++;
                        }else{
                                $tnf++;
                        }

        }

	if(exists $fst2{$keys[$k]}){
         	if($fst2{$keys[$k]} >= $vals2[$one2] ){
	        	$key_oc{$keys[$k]}='Y';
			if($type{$keys[$k]} eq 'm2'){
                                $tpoc++;
                        }else{
                                $fpoc++;
                        }

        	}else{
                	$key_oc{$keys[$k]}='N';
			if($type{$keys[$k]} eq 'm2'){
                                $fnoc++;
                        }else{
                                $tnoc++;
                        }

       	 	}

                if($fst2{$keys[$k]} >= $vals2[$five2] ){        
			$key_fc{$keys[$k]}='Y';
			if($type{$keys[$k]} eq 'm2'){
				$tpfc++;
			}else{
				$fpfc++;
			}
                }else{
                        $key_fc{$keys[$k]}='N';
                	if($type{$keys[$k]} eq 'm2'){
                                $fnfc++;
                        }else{
                                $tnfc++;
                        }
		}
		
	

	}else{
		$key_fc{$keys[$k]}='NA';
		$key_oc{$keys[$k]}='NA';
	}
	
	my $bin= ceil($gene{$keys[$k]}/10);
	my $bin2= ceil($gene{$keys[$k]}/20);
	print "$key_o{$keys[$k]} $key_f{$keys[$k]} $key_oc{$keys[$k]} $key_fc{$keys[$k]} $out{$keys[$k]} $gene{$keys[$k]} $bin $bin2\n";
}

print $out2 "#TP $tpo $tpf $tpoc $tpfc FP $fpo $fpf $fpoc $fpfc FN $fno $fnf $fnoc $fnfc TN $tno $tnf $tnoc $tnfc\n";



