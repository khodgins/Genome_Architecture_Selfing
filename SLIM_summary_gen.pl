# perl SLIM_summary.pl mutations.txt freq_p1.txt freq_p2.txt freq.txt fst.txt > out.txt
#/bin/perl
use warnings;
use strict;
#files
#read in files

#read in mutations

my $mut = $ARGV[0];
my $p1 = $ARGV[1];
my $p2 = $ARGV[2];
my $p = $ARGV[3];
my $fst = $ARGV[4];


open MUTA, $mut;
my $gen=0;
my %gen=();
my $tot=0;
while (<MUTA>){
	chomp;

	if(/^#Gen/){
		if($gen>0){
			$gen{$gen}=$tot;
		}
		my @split = split;
		$gen=$split[1];
		$tot=0;
	}elsif(/^#id/){
	}elsif(/^\s*$/){

	}else{
		$tot++;
	}
}

$gen{$gen}=$tot;

#foreach my $k (keys %gen){
#	print "$k $gen{$k}\n";
#}

my %p1gen=();
open P1a, $p1;
my @p1a=();
while (<P1a>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
#               print "$split[0]\n";
                $gen=$split[0];
		$p1gen{$gen}=$#split-1;
	}
}
close(P1a);

my %p2gen=();
open P2a, $p2;
my @p2a=();
while (<P2a>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
                $gen=$split[0];
                $p2gen{$gen}=$#split-1;
	}
}
close(P2a);


my %pgen=();
open Pa, $p;
my @pa=();
while (<Pa>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
                $gen=$split[0];
                $pgen{$gen}=$#split-1;
        }
}
close(Pa);

my %fstgen=();
open FSTa, $fst;
my @fsta=();
while (<FSTa>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
        }else{
                my @split = split;
                $gen=$split[0];
                $fstgen{$gen}=$#split;
        #	print "$gen $#split\n";
	}
}
close(FSTa);

my %key=();
foreach my $k (keys %gen){
	if(exists $fstgen{$k} && exists $pgen{$k} && exists $p2gen{$k} && exists $p1gen{$k}){
		if( ($fstgen{$k} == $gen{$k}) && ($pgen{$k} == $p1gen{$k} ) && ( $fstgen{$k} ==  $p2gen{$k})){
       		#	print "$k $p1gen{$k} $gen{$k}\n";
			$key{$k}=1;
		}
	}else{
		#print "$k not exist\n";
	}
}


open MUT, $mut;
my @mut=();
$gen=();
while (<MUT>){
        chomp;

        if(/^#Gen/){
                my @split = split;
                $gen=$split[1];
        }elsif(/^#id/){
        }elsif(/^\s*$/){

        }else{
                if(exists $key{$gen}){
                my @tmp=();
                push(@tmp, $gen, $_);
                my $join = join " ", @tmp ;
		push (@mut, $join);
        	}	
	}
}


open P1, $p1; 
my @p1=();
while (<P1>){
        chomp;
        if(/^#Gen/){
	}elsif(/^\s*$/){
        }else{
                my @split = split;
#               print "$split[0]\n";
                $gen=$split[0];
		if(exists $key{$gen}){
		for (my $k=2; $k < ($#split+1); $k++){
			my @tmp=();
			push(@tmp, $gen, $split[$k]);
			my $join=();
			$join = join " ", @tmp ;
                	push (@p1, $join);	
		}
		}
        }

}



my @p2=();
open P2, $p2;

while (<P2>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
	}else{
                my @split = split;
                $gen=$split[0];
                if(exists $key{$gen}){
		for (my $k=2; $k < ($#split+1); $k++){
                        my @tmp=();
			push(@tmp, $gen, $split[$k]);
                        my $join=();
                        $join = join " ", @tmp ;
                        push (@p2, $join);
                
		}
		}
        }

}






my @p=();

open P, $p;

while (<P>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
	}else{
                my @split = split;
#               print "$split[0]\n";
                $gen=$split[0];
                if(exists $key{$gen}){
		for (my $k=2; $k < ($#split+1); $k++){
                        my @tmp=();
                        #print "$gen\n";
                        push(@tmp, $gen, $split[$k]);
                        my $join=();
                        $join = join " ", @tmp ;
                        push (@p, $join);

                }
		}
        }

}


my @fst=();

open FST, $fst;

while (<FST>){
        chomp;
        if(/^#Gen/){
        }elsif(/^\s*$/){
	}else{
                my @split = split;
#               print "$split[0]\n";
                $gen=$split[0];
                if(exists $key{$gen}){
		for (my $k=1; $k < ($#split+1); $k++){
                        my @tmp=();
                       #print "$gen\n";
                        push(@tmp, $gen, $split[$k]);
                        my $join=();
                        $join = join " ", @tmp ;
                        push (@fst, $join);
		}
                }
        }

}

for (my $k=0; $k < ($#p1+1); $k++){
	print "$mut[$k] $p1[$k] $p2[$k] $p[$k] $fst[$k]\n";
}

