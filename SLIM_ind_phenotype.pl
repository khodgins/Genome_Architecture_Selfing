use warnings;
use strict;


my $full=$ARGV[0];
my $gen=$ARGV[2];

open FULL, $full;

my %m2=();
my %genome1=();
my $m=0;
my %ind=();
my %eff=();
my %no1=();
my %no2=();
my %id=();

while (<FULL>){
	chomp;
	if(/m2/){	
		my @split=split;
		$m2{$split[0]}= $split[4]; #new mut id = effect size
		$id{$split[0]}=$split[1]; #new mut id = overall mut id
	}
	
	my @split=split;
	

	if(/p1:/){
		if(/i/){
			my @split=split;
			$ind{$split[2]}= $split[0];
			$ind{$split[3]}= $split[0];
			$eff{$split[0]}=0;
		}else{
			if($m==0){
				for (my $i=2; $i<($#split+1); $i++){
					if(exists $m2{$split[$i]} ){
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}+$m2{$split[$i]};
					}
				}	
				$m=1;
			}
			elsif($m==1){
				for (my $i=2; $i<($#split+1); $i++){
                                	 if(exists $m2{$split[$i]}){
						$eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}+$m2{$split[$i]};
					}
				}
                                $m=0;
			}	
		}
	}

	


	if(/p2:/){
		if(/i/){
                        my @split=split;
                        $ind{$split[2]}= $split[0];
                        $ind{$split[3]}= $split[0];
                        $eff{$split[0]}=0;
                }else{
                        if($m==0){
                                for (my $i=2; $i<($#split+1); $i++){
                                        if(exists $m2{$split[$i]} ){
                                                $eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}+$m2{$split[$i]};
                                        }
                                }
                                $m=1;
                        }
                        elsif($m==1){
                                for (my $i=2; $i<($#split+1); $i++){
                                         if(exists $m2{$split[$i]}){
                                                $eff{$ind{$split[0]}}=$eff{$ind{$split[0]}}+$m2{$split[$i]};
                                        }       
                                }       
                                $m=0;
                        }       
                }     
	}
}

foreach my $k (sort keys %eff){
	print "$k $eff{$k}\n";
}

