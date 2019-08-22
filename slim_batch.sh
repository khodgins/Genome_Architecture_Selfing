#!bin/bash
#this file creates folders and shell scripts to run the SLiM simulations as below

#replicate number
START=1
END=20

#migration - weak to high
mig=( 0.9999 0.999 0.99 0.9 )

#selection - strong to weak
std=( 1.0 2.0 3.0 4.0 )

#selfing outcrossing to selfing
s=( 1.0 0.75 0.5 0.25 0.1 0.01 )

for M in "${mig[@]}"
        do
        for SD in "${std[@]}"
        do
                for S in "${s[@]}"
                do
                        echo "${SD}"
                        echo "${M}"

                        for (( f=$START; f<=$END; f++ ))
                        do
                                mkdir M_"${M}"_SD"${SD}"_S"${S}_R$f"
                                #cp nonWFM_adaptive_1chrom_smalleffect_largeeffect_only_CL.slim  M_"${M}"_SD"${SD}"_S"${S}"_R$f/
                                cd  M_"${M}"_SD"${SD}"_S"${S}"_R$f
                                R=$(echo $RANDOM)
                                echo "slim -d m="${M}" -d sd="${SD}" -d s="${S}" -s $R nonWFM_adaptive_1chrom_normal_dist_effect_shift_opt.slim" > slim.sh
                                cd ../
                        done
                done
        done
done

