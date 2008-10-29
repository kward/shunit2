#! /bin/sh
# $Id$
# vim:et

XML_VERSION='4.4'
XML_FILE="docbook-xml-${XML_VERSION}"
XML_URL="http://www.docbook.org/xml/${XML_VERSION}/${XML_FILE}.zip"

XSL_VERSION='1.73.2'
XSL_FILE="docbook-xsl-${XSL_VERSION}"
XSL_URL="http://downloads.sourceforge.net/docbook/${XSL_FILE}.tar.bz2"

#-----------------------------------------------------------------------------
# do no edit below here
#-----------------------------------------------------------------------------

PATH="${PATH}:${MY_DIR}"
PWD=${PWD:-`pwd`}

MY_BASE=`basename "$0"`
MY_DIR=`dirname "$0"`

# load shlib
. "${MY_DIR}/../lib/sh/shlib"

BASE_DIR=`shlib_relToAbsPath "${MY_DIR}/.."`
DL_DIR="${BASE_DIR}/tmp"
DOCBOOK_DIR="${BASE_DIR}/share/docbook"

CURL_OPTS='-C - -L -Os'
WGET_OPTS='-cq'

METHOD_NONE=0
METHOD_WGET=1
METHOD_CURL=2

get_url()
{
  url=$1
  echo '  downloading'
  cwd=`pwd`
  cd "${DL_DIR}"
  case ${method} in
    ${METHOD_CURL})
      ${curl} ${CURL_OPTS} "${url}"
      case $? in
        0) ;;  # download successful
        18) ;;  # file exists
        *) echo "    curl failed with $?"
      esac
      ;;
    ${METHOD_WGET})
      ${wget} ${WGET_OPTS} "${url}"
      case $? in
        0) ;;  # download successful
        *) echo "    wget failed with $?"
      esac
      ;;
  esac
  cd "${cwd}"
}

# determine method
method=${METHOD_NONE}
wget=`which wget`
[ $? -eq 0 ] && method=${METHOD_WGET}
curl=`which curl`
[ $? -eq 0 -a ${method} -eq ${METHOD_NONE} ] && method=${METHOD_CURL}
if [ ${method} -eq ${METHOD_NONE} ]; then
  echo "unable to locate wget or curl. cannot continue"
  exit 1
fi

# create download dir
mkdir -p "${DL_DIR}"

# get the docbook xml files
echo 'Docbook XML'
xml_file="${XML_FILE}.zip"
xml_path="${DL_DIR}/${xml_file}"
if [ ! -f "${xml_path}" ]; then
  get_url "${XML_URL}"
fi
if [ -f "${xml_path}" ]; then
  echo '  extracting'
  cd "${DL_DIR}"
  xml_dir="${DOCBOOK_DIR}/docbook-xml/${XML_VERSION}"
  rm -fr "${xml_dir}"
  mkdir -p "${xml_dir}"
  cd "${xml_dir}"
  unzip -oq "${xml_path}"
  cd ..
  rm -f current
  ln -s "${XML_VERSION}" current
else
  echo "error: unable to extract (${xml_file})" >&2
  exit 1
fi

# get the docbook xslt files
echo 'Docbook XSLT'
xsl_file="${XSL_FILE}.tar.bz2"
xsl_path="${DL_DIR}/${xsl_file}"
if [ ! -f "${xsl_path}" ]; then
  get_url "${XSL_URL}"
fi
if [ -f "${xsl_path}" ]; then
  echo '  extracting'
  cd "${DL_DIR}"
  xsl_dir="${DOCBOOK_DIR}/docbook-xsl"
  mkdir -p "${xsl_dir}"
  cd "${xsl_dir}"
  rm -fr ${XSL_VERSION}
  bzip2 -dc "${xsl_path}" |tar xf -
  mv ${XSL_FILE} ${XSL_VERSION}
  rm -f current
  ln -s "${XSL_VERSION}" current
else
  echo "error: unable to extract (${xsl_file})" >&2
  exit 1
fi
