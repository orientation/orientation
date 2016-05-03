require 'aws-sdk'

Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::SharedCredentials.new({
    # the `path` option is inferred so make sure you have a ~/.aws/credentials
    # file that contains the following:
    #   [orientation]
    #   aws_access_key_id = YOURACCESSKEYID
    #   aws_secret_access_key = YOURSECRETKEYID
    #
    profile_name: "orientation"
  })
})
