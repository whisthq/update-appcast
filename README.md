# Update Appcast Action

This action generates a Sparkle appcast containing a link to the latest version of Whist and uploads it to S3.
The static file in S3 acts as an RSS feed that is read by the Sparkle update client built into Whist.

# Usage

```yaml
- uses: whisthq/update-appcast@v0.1
  with:
    # The latest version of Whist
    # Required
    version: "1.2.3-rc.4"

    # The name of the S3 bucket that will host the DMG and appcast.xml
    # Required
    bucket: "whist-browser-macos-arm64-prod

    # The name of the DMG file in S3
    # Required
    object-key: "Whist-Nightly-1.2.3-rc.4-x64.dmg"

    # The path to the file containing the Sparkle EdDSA signature produced by
    # the create_dist GN target
    # Required
    sparkle-sig-file: "/path/to/src/out/Release/Whist Beta.dmg.eddsa"

    # Your AWS access key ID. Only required if AWS credentials have not already
    # been set.
    aws-access-key-id: "ABCDEFG..."

    # Your AWS secret access key. Only required if AWS credentials have not
    # already been set.
    aws-secret-access-key: "***"
```

# Examples

## Publish Whist stable version 3.2.1 for M1 Macs

```yaml
- uses: whisthq/update-appcast@v0.1
  with:
    version: "3.2.1"
    bucket: "whist-browser-macos-arm64-prod"
    object-name: Whist-3.2.1-arm64.dmg
    sparkle-sig-file: "/path/to/src/out/Release/Whist Browser.dmg.eddsa
```
