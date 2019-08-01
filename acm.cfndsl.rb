CloudFormation do

  cert_tags = []
  cert_tags << { Key: "Name", Value: Ref('AWS::StackName') }
  cert_tags << { Key: "Environment", Value: Ref("EnvironmentName") }
  cert_tags << { Key: "EnvironmentType", Value: Ref("EnvironmentType") }

  tags.each do |key, value|
    cert_tags << { Key: key, Value: value }
  end if defined? tags

  Condition('IsProd', FnEquals(Ref('EnvironmentName'), 'prod'))

  Resource("ACMCertificate") do
    Type 'Custom::CertificateValidator'
    Property 'ServiceToken',FnGetAtt('CertificateValidatorCR','Arn')
    Property 'AwsRegion', Ref('AWS::Region')
    Property 'DomainName', Ref('DomainName')
    Property 'AlternativeNames', defined?(alternative_names) ? alternative_names : ''
    Property 'Tags', cert_tags
  end

  Output("CertificateArn") { Value(Ref('ACMCertificate')) }

end
