# == functions
say() {
    MESSAGE="$1"
    TIMESTAMP=$(date +"%F %T")
    echo -e "$TIMESTAMP $MESSAGE"
    logger -t $LOG_TAG -p $LOG_FACILITY.$LOG_LEVEL "$MESSAGE".
}

err()  {
    MESSAGE="ERROR: $1"
    TIMESTAMP=$(date +"%F %T")
    echo -e $TIMESTAMP $MESSAGE >&2
    logger -t $LOG_TAG -p $LOG_FACILITY.$LOG_LEVEL_ERR "$MESSAGE"
    LockUnset
    exit 1
}

quit() {
    MESSAGE="$1"
    TIMESTAMP=$(date +"%F %T")
    echo -e $TIMESTAMP $MESSAGE >&2
    logger -t $LOG_TAG -p $LOG_FACILITY.$LOG_LEVEL_ERR "$MESSAGE"
    LockUnset
    exit 0
}

LockSet() {
    me=`basename "$0"`
    lock_file="/tmp/${me}.lock"
    [ -f $lock_file ] && err "$lock_file exist"
    touch $lock_file
}

LockUnset() {
    rm -rf $lock_file
}
# == end of functions
