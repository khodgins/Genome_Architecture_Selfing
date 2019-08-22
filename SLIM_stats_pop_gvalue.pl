#perl SLIM_stats_pop.pl out2.txt
#d mean - average effect size
#number of loci impacting the phenotype
#d max - most extremely differentiated loci effect size
#c_a - average clustering distance we calculated the “clustering distance” as the average physical distance between the locus with dmax and all other stable differentiated loci

my $div_cut=0.9; #number of divergent generations over the examined period
my %p1=();
my %p2=();
my %d=();
my %a=();
my %pos=();
my %gv1=();
my %gv2=();
my %gvdiff=();
  
#/bin/perl
use warnings;
use strict;

my $out = $ARGV[0];

open OUT, $out;

my $asum=0;
my $aabs=0;
my $num=0;

while (<OUT>){
       chomp;
       if(/^id/ || /^\s*$/ ){
       }else{
		my @split=split;
		my $p_div=$split[2]/$split[3];
		if($p_div > $div_cut && $split[9] eq 'm2'){
			$p1{$split[0]}=$split[4];
			$p2{$split[0]}=$split[5];
			$d{$split[0]}=$split[8];
			$a{$split[0]}=$split[-1];
			$pos{$split[0]}=$split[1];
			$asum=$asum+$split[-1];
			$aabs=$aabs+abs($split[-1]);
			$gv1{$split[0]}=$split[4]*$split[-1];
			$gv2{$split[0]}=$split[5]*$split[-1];
			$gvdiff{$split[0]}=abs($gv1{$split[0]}-$gv2{$split[0]});
			$num++;
		#	print "p1 $split[0] $gv1{$split[0]} p2 $split[0] $gv2{$split[0]}\n";			
		} 
	}
}
if($num > 0){
	my @p1k = sort { $p1{$b} <=> $p1{$a} } keys(%p1);
	my @p2k = sort { $p2{$b} <=> $p2{$a} } keys(%p2);

	#my @gv1k = sort { abs($gv1{$b}) <=> abs($gv1{$a}) } keys(%gv1);
	#my @gv2k = sort { abs($gv2{$b}) <=> abs($gv2{$a}) } keys(%gv2);
	my @gvdiff = sort { abs($gvdiff{$b}) <=> abs($gvdiff{$a}) } keys(%gvdiff);
	
	my $dmax;
	my $gvmax;

	if($p1{$p1k[0]} > $p2{$p2k[0]}){
# 		print "p1 $p1k[0] $p1{$p1k[0]} $p2{$p1k[0]} $a{$p1k[0]}\n";
		$dmax=$p1k[0];
	}else{
#		print "p2 $p2k[0] $p2{$p2k[0]} $p1{$p2k[0]} $a{$p2k[0]}\n";
		$dmax=$p2k[0];
	}	

	#if(abs($gv1{$gv1k[0]}) > abs($gv2{$gv2k[0]})){
        	$gvmax=$gvdiff[0];
	#}else{
        #	$gvmax=$gv2k[0];
	#}

	my $sdist=0;
	foreach my $k (keys %pos){
		if($dmax != $k){
        		my $dist=abs($pos{$k}-$pos{$dmax});
			$sdist=$sdist+$dist;
		}
	}

	my $mean_dist= $sdist/$num/100000;
	my $mean_a = $aabs/$num;
	
	my $dsum=0;
	my $gv1sum=0;
	my $gv2sum=0;
	foreach my $k (keys %gvdiff){
		#print "$k $gvdiff{$k}\n";
		$dsum=$dsum+$gvdiff{$k};
		$gv1sum=$gv1sum+$gv1{$k};
		$gv2sum=$gv2sum+$gv2{$k};
	}
print "pos_dmax p1_freq p2_freq a_dmax a_sum a_abs num mean_a sum_dist mean_dist pos_gvmax gvp1_freq gvp2_freq gvmax a_sum a_abs num sum_dist mean_dist gvp1 gvp2 sum_diff\n";
print "$pos{$dmax} $p1{$dmax} $p2{$dmax} $a{$dmax} $asum $aabs $num $mean_a $sdist $mean_dist ";

	my $gvdist=0;
	foreach my $k (keys %pos){
        	if($gvmax != $k){
                	my $dist=abs($pos{$k}-$pos{$gvmax});
                	$gvdist=$gvdist+$dist;
        	}
	}	

	my $gvmean_dist= $gvdist/$num/1000000;

	#print "pos_gvmax gvp1_freq gvp2_freq gvmax a_sum a_abs num sum_dist mean_dist\n";
	print "$pos{$gvmax} $p1{$gvmax} $p2{$gvmax} $a{$gvmax} $asum $aabs $num $gvdist $gvmean_dist $dsum $gv1sum $gv2sum\n";

}else{
	print "NA NA NA NA NA NA $num NA NA NA NA NA NA NA NA NA $num NA NA NA NA NA\n"
}

