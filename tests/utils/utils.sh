function kyratSetUp() {
    export KYRAT_HOME=$(TMPDIR=/tmp mktemp -d -t kyrat-test-home.XXXXXXX)
    # should not match */kyrat-*
    export HOME=$(TMPDIR=/tmp mktemp -d -t user-kyrat-test-home.XXXXXXX)
}

function kyratTearDown(){
    rm -rf $KYRAT_HOME
    unset KYRAT_HOME
    if [[ "$HOME" == "/tmp/user-kyrat-test-home."* ]]; then
        rm -rf "$HOME"
    else
        echo "Error! Tried to remove \"$HOME\", exiting.."
        exit 1
    fi
    unset HOME
}

function setUpUnitTests(){
    OUTPUT_DIR="${SHUNIT_TMPDIR}/output"
    mkdir "${OUTPUT_DIR}"
    STDOUTF="${OUTPUT_DIR}/stdout"
    STDERRF="${OUTPUT_DIR}/stderr"
}

function assertCommandSuccess(){
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertTrue "The command $1 did not return 0 exit status" $?
}

function assertCommandFail(){
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertFalse "The command $1 returned 0 exit status" $?
}

# $1: expected exit status
# $2-: The command under test
function assertCommandFailOnStatus(){
    local status=$1
    shift
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertEquals $status $?
}
