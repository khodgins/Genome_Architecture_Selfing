# perl SLIM_stats_mut.pl out.txt m1.txt m2.txt m3.txt <gen to summarize> <number to examine allele stability over>

#/bin/perl
use warnings;
use strict;
#files
#read in files

#read in mutations

#open final output
my $out = $ARGV[0];

#open summary
my $file1 = $ARGV[1];
my $file2 = $ARGV[2];
my $file3 = $ARGV[3];

#enter generation you want to summarize
my $gen = $ARGV[4];

#enter the numberof generations the alleles need to be diverged before that
my $stab = $ARGV[5];

my $gen_cut=$gen-$stab;

my $cen_cut=$gen-$ARGV[6]; #The number of generations the average should be taken

#print "GEN $gen_cut\n";
#print "CEN $cen_cut\n";
my $fst_cut = 0;

my %gen_no; #number of sampled generations examined
my %cen_no;

my $i=0;
my $j=1;
my %mut_pos=();

my %gen_cut=();
my %cen_cut=();
my %mut2=();
my %gen=(); #generation hash position
my %f_p1=(); #freq in p1
my %f_p2=(); #freq in p2
my %a=(); #effect size
my %fst=(); #fst

open OUT, $out;
while (<OUT>){
       chomp;
       if(/^\s*$/){
       }else{
       		my @split = split;
		$mut_pos{$split[1]}= $split[2];
		$mut2{$split[1]} = $split[3];
	#	print "gen $split[0]\n";
		#total generation number
		#if generation exists in hash already skip
		#if generation does not exist and is equal of greater than the cut off count starting at 1
		if(exists $gen_no{$split[0]}){
		}elsif( $split[0] >= $gen_cut && $split[0] <= $gen ) {
			$i++;
			#print "$i $split[0] gen cut $gen_cut gen $split[0]\n";
			$gen_no{$split[0]}=$i;
		}
	
		#if generation is greater than cut off and diverged put in hash by position
	#	if($split[0] == $gen_cut && $split[11] > $fst_cut){
	#		#look into mutation stacking
        #      		$gen{$split[1]}=1; #id=generation no
			
		if($split[0] >= $gen_cut && $split[11] > $fst_cut && $split[0] <= $gen){
			
			#will update the hash and count all those that are present in the current generation
			if(exists $gen{$split[1]}){
				$gen{$split[1]}++;
			}else{
				$gen{$split[1]}=1;
			}
		}		
	
 		if(exists $cen_no{$split[1]} && $split[11] > $fst_cut && $split[0] <= $gen){
                        $cen_no{$split[1]}++;
		}elsif($split[0] >= $cen_cut && $split[11] > $fst_cut && $split[0] <= $gen) {
                        #print "new gen $split[0]\n";
               		$cen_no{$split[1]}=1;	
                }
		#get number of generations you want to average it across and record the sum and the total number of generations with data
		if($split[0] >= $cen_cut && $split[11] > $fst_cut && $split[0] <= $gen){

			#take rolling sum of allele frequencies and effect sizes and fst
			if(exists $f_p1{$split[1]}){
				$f_p1{$split[1]}=$f_p1{$split[1]}+$split[5];
				$f_p2{$split[1]}=$f_p2{$split[1]}+$split[7];
				$fst{$split[1]}=$fst{$split[1]}+$split[11];
			}else{	
				$a{$split[1]}=$split[3];
				$f_p1{$split[1]} = $split[5];
				$f_p2{$split[1]} = $split[7];
				$fst{$split[1]} = $split[11];
			}
		}

	}		
        	
}

my $c=0;
my %mut_type=();
my %mut_dom=();
my %mut_eff=();

open FILE1, $file1;

while (<FILE1>){
	chomp;
	if(/^#id/){
	}	
	else{
		my @split=split;
		$mut_pos{$split[4]}=$split[6];
		$mut_type{$split[4]}=$split[5];
		$mut_dom{$split[4]}=$split[8];
		$mut_eff{$split[4]}=$split[7];
	}
}

open FILE2, $file2;

while (<FILE2>){
        chomp;
        if(/^#id/){
        }       
        else{   
                my @split=split;
                $mut_pos{$split[4]}=$split[6];
                $mut_type{$split[4]}=$split[5];
                $mut_dom{$split[4]}=$split[8];
                $mut_eff{$split[4]}=$split[7];
        }
}

open FILE3, $file3;

while (<FILE3>){
        chomp;
        if(/^#id/){
        }       
        else{   
                my @split=split;
                $mut_pos{$split[4]}=$split[6];
                $mut_type{$split[4]}=$split[5];
                $mut_dom{$split[4]}=$split[8];
                $mut_eff{$split[4]}=$split[7];
        }
}

print "id position sampling_points_divergent total_no_sampling_points p1_freq p2_freq fst total_sampling_points_averaged deviation_avg_freq mutation_type dominance effect_size\n"; 

foreach my $k (keys %f_p1){
	my $f_p1a = $f_p1{$k}/$cen_no{$k};
	my $f_p2a = $f_p2{$k}/$cen_no{$k};
	my $fsta = $fst{$k}/$cen_no{$k};
	my $d= abs($f_p1a-$f_p2a);
	if(exists $mut_type{$k}){
	print "$k $mut_pos{$k} $gen{$k} $i $f_p1a $f_p2a $fsta $cen_no{$k} $d $mut_type{$k} $mut_dom{$k} $a{$k} $mut_eff{$k}\n";
	}else{
		print "$k $mut_pos{$k} $gen{$k} $i $f_p1a $f_p2a $fsta $cen_no{$k} $d m3 0.1 $a{$k} $mut2{$k}\n";
	}
}



