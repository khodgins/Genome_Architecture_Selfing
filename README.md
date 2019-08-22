# Genome_Architecture_Selfing

slim script for large effect deleterious simulations but can be easily modified for the small effect and neutral simulations:

nonWFM_adaptive_1chrom_normal_dist_effect_shift_opt_del.slim 

example usage

```bash
slim -d m=0.999 -d sd=3 -d s=0.1 -s 410 nonWFM_adaptive_1chrom_normal_dist_effect_shift_opt.slim

```

bash script for creating file structure and bash script to run slim in parallel
```bash
sh slim_batch.sh
```
scripts for identifying stably diverged loci and summarizing slim output:
```bash
perl SLIM_summary_gen.pl mutations.txt freq_p1.txt freq_p2.txt freq.txt fst.txt > out.txt
perl SLIM_stats_mut.pl out.txt m1.txt m2.txt m3.txt 200000 20000 20000 > out_200.txt
perl SLIM_stats_pop_gvalue.pl out_200.txt  > summary.txt
perl SLIM_stats_harm_mean.pl phenotype.txt 200000 20000 > pop_size.txt
```


get fst and mutation type for a particular generation and only keep variable sites using SLIM_summary_missing_fst.pl
```bash
perl SLIM_summary_missing_fst.pl out.txt m1.txt m2.txt m3.txt 100000 > fst_100.txt
```

sort and get fst outliers 
```bash
perl SLIM_outlier_fst.pl fst_100.txt | sort -nk7,7 |  sed 's/#OUT: / /g' > fst_out_100.txt
```

run R script to get fst outlier windows
```bash
Rscript fst_Rscript_100.R
```

to calculate drift and segregation load
```bash
perl SLIM_load.pl full_100.txt out.txt 100000 > load_100.txt
```

to calculate migration load
```bash
perl  SLIM_ind_phenotype.pl full_100.txt 100000 | sed 's/:/ /g' > ind_phenotype.txt
Rscript SLIM_ind_phenotype.R
```

