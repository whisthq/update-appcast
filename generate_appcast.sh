#!/bin/bash
# generate_appcast.sh
# Generate an appcast.xml file containing a single entry for the latest version
# of Whist. Print XML to standard output.
#
# Copyright 2022 Whist Technologies, Inc.

set -euo pipefail

NARGS=5

if [ "$#" -ne "$NARGS" ]; then
    test "$#" -gt "$NARGS" && echo "Error: Too many arguments"
    test "$#" -lt "$NARGS" && echo "Error: Too few arguments"
    echo "Usage: $0 <human-version> <machine-version> <bucket-name> <object-key> <sig-file>"
    exit 1
fi

HUMAN_VERSION="$1"
MACHINE_VERSION="$2"
S3_BUCKET_NAME="$3"
S3_OBJECT_KEY="$4"
SIGNATURE_FILE="$5"

DOWNLOAD_LINK="https://$S3_BUCKET_NAME.s3.amazonaws.com/$S3_OBJECT_KEY"

XSLT_PARAMS="$(
    cat "$SIGNATURE_FILE" | sed -E 's/([^ ]+)=(\"[^ ]+\")/--param \1 \2/g'
)"

xsltproc $XSLT_PARAMS \
	 --stringparam version "$MACHINE_VERSION" \
	 --stringparam short-version "$HUMAN_VERSION" \
	 --stringparam download-link "$DOWNLOAD_LINK" \
	 template.xsl version.xml \
    | xmllint --format --encode UTF-8 -
