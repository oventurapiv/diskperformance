export TIMES=$1
export SIZE=$2
export FOLDER=$3
mkdir -p $3
rm nohup.out

_EXECUTE() {
for (( i=1; i<=$TIMES; i++ ))
    do
        nohup dd if=/dev/sda1 of=${FOLDER}/${i} bs=${SIZE}k count=1 $OPTIONS &
    done
for job in `jobs -p`
    do
        echo $job
        wait $job || let "FAIL+=1"
    done

echo $FAIL

mv nohup.out $1
for (( i=1; i<=$TIMES; i++ ))
    do
        rm -f ${FOLDER}/${i}
    done
}

export OPTIONS=""
log_file=test1
_EXECUTE $log_file
export OPTIONS="iflag=direct"
log_file=test2
_EXECUTE $log_file
