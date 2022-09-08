#!/usr/bin/env python3
# format_version.py
# Print the release version in a format that is suitable to assign to the
# CFBundleVersion key in Info.plist.
#
# Copyright 2022 Whist Technologies, Inc.

import argparse
import re

WHIST_VERSION_PATTERN = re.compile(
    "(\d+)\.(\d+)\.(\d+)(?:-(dev|staging)-rc\.(\d+))?"
)

def format_version(version):
    """Replicate the transformation applied by _OverrideVersionKey.

    The value of each sparkle:version XML element in appcast.xml needs to match
    the corresponding application bundle's Info.plist CFBundleVersion key. In
    build/mac/tweak_info_plist.py the function _OverrideVersionKey applies a
    transformation to the version string specified in package.json. We apply
    that same transformation here.
    """

    match = WHIST_VERSION_PATTERN.fullmatch(version)

    if match is None:
        raise Exception(f"Failed to parse version string \"{version}\"")

    major, minor, patch, channel, prerelease = match.groups("")
    version = f"{int(major) * 100 + int(minor)}.{patch}"

    if channel == "dev":
        assert prerelease is not None
        version += f".2.{prerelease}"
    elif channel == "staging":
        assert prerelease is not None
        version += f".1.{prerelease}"

    return version

def main():
    parser = argparse.ArgumentParser(
        description="Print the release version in a format suitable to be set "
        "as the value of the CFBundleVersion key in Info.plist."
    )
    parser.add_argument(
        "version",
        help="The release version as specified in package.json",
    )

    args = parser.parse_args()

    print(format_version(args.version))

if __name__ == "__main__":
    main()
