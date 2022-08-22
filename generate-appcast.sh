#!/bin/bash
# generate-appcast.sh
# Generate an appcast.xml file containing a single entry for the latest version
# of Whist. Print XML to standard output.
#
# Copyright 2022 Whist Technologies, Inc.

set -eu

NARGS=4

if [ "$#" -ne "$NARGS" ]; then
    test "$#" -gt "$NARGS" && echo "Error: Too many arguments"
    test "$#" -lt "$NARGS" && echo "Error: Too few arguments"
    echo "Usage: $0 <version> <bucket-name> <object-key> <sig-file>"
    exit 1
fi

VERSION="$1"
S3_BUCKET_NAME="$2"
S3_OBJECT_KEY="$3"
SIGNATURE_FILE="$4"

DOWNLOAD_LINK="https://$S3_BUCKET_NAME.s3.amazonaws.com/$S3_OBJECT_KEY"

XSLT_PARAMS="$(
    cat "$SIGNATURE_FILE" | sed -E 's/([^ ]+)=([^ ]+)/--param \1 \2/g'
)"

xsltproc $XSLT_PARAMS <<EOF \
	 --stringparam version "$CF_BUNDLE_VERSION" \
	 --stringparam download-link "$DOWNLOAD_LINK" \
	 template.xsl - \
    | xmllint --format --encode UTF-8 -
<?xml version="1.0" encoding="UTF-8"?>
<empty />
EOF
