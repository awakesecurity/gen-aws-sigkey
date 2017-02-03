# Welcome!

This is a small Haskell CLI utility that generates AWS V4 scoped signing keys
given an AWS Secret Access Key. AWS documentation on their V4 protocol is here:
https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html.

## Example Usage

```shell
$ gen-aws-sigkey --help
Generate AWS V4 scoped signing keys

Usage: gen-aws-sigkey [--region TEXT] [--service TEXT] [--protocol TEXT]
                      [--sigonly] --key TEXT

Available options:
  -h,--help                Show this help text
  --region TEXT            AWS region [default: us-east-1]
  --service TEXT           AWS service [default: s3]
  --protocol TEXT          AWS protocol [default: aws4_request]
  --sigonly                Print the signature only
  --key TEXT               AWS secret access key
```

Signatures are by-default generated for the `us-east-1` region, the `s3`
service, and the `aws4_request` protocol:

```shell
$ gen-aws-sigkey --key 'SEj1MtygPTPfa1Tyg/T9eLdNSIOqeDjgbMrzz3zq'
{"scope":"20170517/us-east-1/s3/aws4_request","signing-key":"3xI8OjI6UqA+LUpIqFYqWbDfT5T6d5FxEfHp0pjHYK8="}
```

```shell
$ gen-aws-sigkey --key 'SEj1MtygPTPfa1Tyg/T9eLdNSIOqeDjgbMrzz3zq' --region us-west-2
{"scope":"20170517/us-west-2/s3/aws4_request","signing-key":"nlx8+wS36Tabx3EGgTuJDDF9PQr1gABCf8yBVOqjNHE="}
```

```shell
$ gen-aws-sigkey --key 'SEj1MtygPTPfa1Tyg/T9eLdNSIOqeDjgbMrzz3zq' --region us-west-2 --sigonly
nlx8+wS36Tabx3EGgTuJDDF9PQr1gABCf8yBVOqjNHE=
```

