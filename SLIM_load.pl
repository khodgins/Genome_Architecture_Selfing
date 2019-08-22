use warnings;
use strict;


my $full=$ARGV[0];
my $out=$ARGV[1];
my $gen=$ARGV[2];


my %p1seg=();
my %p2seg=();
my %p1f=();
my %p2f=();

open OUT, $out;

while (<OUT>){
	chomp;
	my @split=split;
	if($split[0]==$gen){
		if($split[5] < 1 && $split[5] > 0 && $split[3] < 0){
			$p1seg{$split[1]}=$split[3];
			#print " ss $p1seg{$split[1]} $split[1]\n";
		}
		if($split[5] == 1 && $split[3] < 0){
                        $p1f{$split[1]}=$split[3];
			 #print "ff $p1f{$split[1]} $split[1]\n";
                }
		if($split[7] < 1 && $split[7] > 0 && $split[3] < 0){
			$p2seg{$split[1]}=$split[3];
		}
		 if($split[7] == 1 && $split[3] < 0){
                        $p2f{$split[1]}=$split[3];
                }

	}

}

#foreach my $k (keys %p1seg){
#	print "s $k $p1seg{$k}\n";
#}

#foreach my $k (keys %p1f){
#        print "f $k $p1f{$k}\n";
#}


open FULL, $full;

my %m3=();
my %genome1=();
my %genome2=();
my $m=0;
my %ind=();
my %eff=();
my %no1=();
my %no2=();
my %id=();
my %fit_seg=();
my %fit_fix=();

while (<FULL>){
	chomp;
	if(/m3/){	
		my @split=split;
		$m3{$split[0]}= $split[4]; #new mut id = effect size
		$id{$split[0]}=$split[1]; #new mut id = overall mut id
	}
	
	my @split=split;
	

	if(/p1:/){
		if(/i/){
			my @split=split;
			$ind{$split[2]}= $split[0];
			$ind{$split[3]}= $split[0];
			$eff{$split[0]}=1;
			$no1{$split[0]}=0;
			$no2{$split[0]}=0;
			$fit_seg{$split[0]}=1;##
			$fit_fix{$split[0]}=1;##
		}else{
			if($m==0){
			#	print "m==0 $_\n";
				for (my $i=2; $i<($#split+1); $i++){
					if(exists $m3{$split[$i]} ){
						$genome1{$split[$i]}=$m3{$split[$i]};
					}
				}	
				$m=1;
				%genome2=();
			}
			elsif($m==1){
			#	print "m==1 $_\n";
				for (my $i=2; $i<($#split+1); $i++){
                                	 if(exists $m3{$split[$i]}){
				        	if(exists $genome1{$split[$i]}){
							#print "genome $split[0] $ind{$split[0]} $hash{$split[$i]} $genome1{$split[$i]}\n";
							if(exists $p1seg{$id{$split[$i]}}){
								$no1{$ind{$split[0]}}++;
								$no2{$ind{$split[0]}}++;
			#					print "$i mut $split[$i] no1 $no1{$ind{$split[0]}} no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]} ge $ind{$split[0]}  $genome1{$split[$i]}\n";
			#					print "fitseg $fit_seg{$ind{$split[0]}}\n";
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+$m3{$split[$i]});
								$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+$m3{$split[$i]});##
							}elsif(exists $p1f{$id{$split[$i]}}){##
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+$m3{$split[$i]});
								 $fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+$m3{$split[$i]});##
			#					print "fitfix $ind{$split[0]}  $fit_fix{$ind{$split[0]}}\n";
							}##
			#				print "mut to delete from genome 1 $genome1{$split[$i]}\n";
							delete $genome1{$split[$i]};
							
						}else{
							if(exists $p1seg{$id{$split[$i]}}){
			#					print "$i mut $split[$i] no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]} \n";
								$no2{$ind{$split[0]}}++; #ind genome 2 count
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));
								$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));##
								
							}elsif(exists $p1f{$id{$split[$i]}}){##
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));
								$fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));##
							}##
						}
					}
				}
				foreach my $k (keys %genome1){
					#	print "G1 ID:$id{$k}      k:$k no1 $no1{$ind{$split[0]}} no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]}  \n";
                                        if(exists $p1seg{$id{$k}}){
						$no1{$ind{$split[0]}}++;
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
						$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
					}elsif(exists $p1f{$id{$k}}){##
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
						$fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));##
					}
				}
                                $m=0;
				%genome1=();
			}	
		}
	}

	


	if(/p2:/){
		if(/i/){
			my @split=split;
			$ind{$split[2]}= $split[0];
			$ind{$split[3]}= $split[0];
			$eff{$split[0]}=1;
			$no1{$split[0]}=0;
			$no2{$split[0]}=0;
			$fit_seg{$split[0]}=1;##
			$fit_fix{$split[0]}=1;##
		}else{
			if($m==0){
				#print "m==0 $_\n";
				for (my $i=2; $i<($#split+1); $i++){
					if(exists $m3{$split[$i]} ){
						$genome1{$split[$i]}=$m3{$split[$i]};
					}
				}	
				$m=1;
				%genome2=();
			}
			elsif($m==1){
			#	print "m==1 $_\n";
				for (my $i=2; $i<($#split+1); $i++){
                                	 if(exists $m3{$split[$i]}){
				        	if(exists $genome1{$split[$i]}){
							#print "genome $split[0] $ind{$split[0]} $hash{$split[$i]} $genome1{$split[$i]}\n";
							if(exists $p2seg{$id{$split[$i]}}){
								$no1{$ind{$split[0]}}++;
								$no2{$ind{$split[0]}}++;
			#					print "$i mut $split[$i] no1 $no1{$ind{$split[0]}} no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]} ge $ind{$split[0]}  $genome1{$split[$i]}\n";
			#					print "fitseg $fit_seg{$ind{$split[0]}}\n";
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+$m3{$split[$i]});
								$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+$m3{$split[$i]});##
							}elsif(exists $p2f{$id{$split[$i]}}){##
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+$m3{$split[$i]});
								 $fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+$m3{$split[$i]});##
			#					print "fitfix $ind{$split[0]}  $fit_fix{$ind{$split[0]}}\n";
							}##
			#				print "mut to delete from genome 1 $genome1{$split[$i]}\n";
							delete $genome1{$split[$i]};
							
						}else{
							if(exists $p2seg{$id{$split[$i]}}){
			#					print "$i mut $split[$i] no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]} \n";
								$no2{$ind{$split[0]}}++; #ind genome 2 count
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));
								$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));##
								
							}elsif(exists $p2f{$id{$split[$i]}}){##
								$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));
								$fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+(0.1*$m3{$split[$i]}));##
							}##
						}
					}
				}
				foreach my $k (keys %genome1){
			#			print "G1 ID:$id{$k}      k:$k no1 $no1{$ind{$split[0]}} no2 $no2{$ind{$split[0]}} count genome $split[0] ind  $ind{$split[0]}  \n";
                                        if(exists $p2seg{$id{$k}}){
						$no1{$ind{$split[0]}}++;
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
						$fit_seg{$ind{$split[0]}}=$fit_seg{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
					}elsif(exists $p2f{$id{$k}}){##
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));
						$fit_fix{$ind{$split[0]}}=$fit_fix{$ind{$split[0]}}*(1+(0.1*$genome1{$k}));##
					}
				}
                                $m=0;
				%genome1=();
			}	
		}
	}
}

foreach my $k (sort keys %eff){
	print "$k $eff{$k} $fit_seg{$k} $fit_fix{$k} $no1{$k} $no2{$k}\n";
}

