#!/bin/sh
BASEDIR=`dirname $0`
echo $BASEDIR | grep "^/" >/dev/null
if [ $? -ne 0 ] ; then
    BASEDIR=`pwd`/$BASEDIR
fi
if [ "" = "$TMPDIR" ] ; then
    TMPDIR=/tmp
fi
_mktemp=`which mktemp 2>/dev/null`
if [ -x "${_mktemp}" ] ; then
    tmpdirTemplate="$TMPDIR/sophos_distribution_XXXXXXX"
    SOPHOS_INSTALL_TMP=`${_mktemp} -d ${tmpdirTemplate}`
    [ $? = 0 ] || { echo "Could not create temporary directory" 1>&2 ; exit 1 ; }
else
    _od=`which od 2>/dev/null`
    if [ -x "${_od}" ] ; then
        _random=/dev/urandom
        [ -f "${_random}" ] || _random=/dev/random
        SOPHOS_INSTALL_TMP=$TMPDIR/sophos_distribution_`${_od} -An -N16 -tu2 "${_random}" | tr -d " \t\r\n"`.$$
    else
        SOPHOS_INSTALL_TMP=$TMPDIR/sophos_distribution_${RANDOM-0}.${RANDOM-0}.${RANDOM-0}.$$
    fi

    [ -d "${SOPHOS_INSTALL_TMP}" ] && { echo "Temporary directory already exists" 1>&2 ; exit 1 ; }
    (umask 077 && mkdir ${SOPHOS_INSTALL_TMP}) || { echo "Could not create temporary directory" 1>&2 ; exit 1 ; }
fi
if [ ! -d "${SOPHOS_INSTALL_TMP}" ] ; then
    echo "Could not create temporary directory" 1>&2
    exit 1
fi

echo "exit 0" > "$SOPHOS_INSTALL_TMP/exectest" && chmod +x "$SOPHOS_INSTALL_TMP/exectest"
$SOPHOS_INSTALL_TMP/exectest || {
    echo "Cannot execute files within $TMPDIR directory. Please see KBA 131783 http://www.sophos.com/kb/131783" 1>&2
    rm -rf $SOPHOS_INSTALL_TMP
    exit 15
}

export SOPHOS_INSTALL_TMP
cd $SOPHOS_INSTALL_TMP
tar xf "$BASEDIR/sav.tar"
[ -f "$BASEDIR/uncdownload.tar" ] && tar xf "$BASEDIR/uncdownload.tar"
[ -f "$BASEDIR/talpa.tar" ] && tar xf "$BASEDIR/talpa.tar"
sophos-av/install.sh "$@"
RETCODE=$?
cd /
rm -rf $SOPHOS_INSTALL_TMP
exit $RETCODE
