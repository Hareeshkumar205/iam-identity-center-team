---
layout: default
title: Security considerations
nav_order: 4
parent: Solution overview
---

# Security considerations

## Content Security Legal Disclaimer

> The sample code; software libraries; command line tools; proofs of concept; templates; or other related technology (including any of the foregoing that are provided by our personnel) is provided to you as AWS Content under the AWS Customer Agreement, or the relevant written agreement between you and AWS (whichever applies). You should not use this AWS Content in your production accounts, or on production or other critical data. You are responsible for testing, securing, and optimizing the AWS Content, such as sample code, as appropriate for production grade use based on your specific quality control practices and standards. Deploying AWS Content may incur AWS charges for creating or using AWS chargeable resources, such as running Amazon EC2 instances or using Amazon S3 storage.
{: .important}

## Access control
The TEAM solution controls access to your AWS environment and must be treated with extreme care in order to prevent unauthorized access. Special care should be taken to protect the integrity of the solution code and configuration.

## Elevated access and session duration
TEAM solution workflow operates by attaching and removing permission sets from a user entity within the duration of the requested elevated access. The duration specified in a request determines the time window for which elevated access is active, if the request is approved. During this time window, the requester can invoke sessions to access the AWS target environment. It does not affect the duration of each session. Session duration is configured independently for each permission set by an IAM Identity Center administrator, and determines the time period for which IAM temporary credentials are valid for all sessions using that permission set. Be aware that sessions invoked just before elevated access ends may remain valid beyond the end of the elevated access period. Consider minimizing the session duration configured in your permission sets, for example by setting them as the default **1 hour** in IAM Identity Center.

## Availability
While most of the services that the TEAM app leverages are highly available by default, Amazon Cognito and AWS IAM Identity Center are regional services. TEAM's dependence on these regional services indicates that it cannot be used as a break glass solution for granting temporary access to your AWS environment in the event of a failure of the region where your IAM Identity Center is deployed.

## Management account access
The management account is a highly privileged account and to adhere to the principal of least privilege, we highly recommend that you restrict access to the management account to as few people as possible.
TEAM is designed to be deployed in an account that is a [delegated admin](https://docs.aws.amazon.com/singlesignon/latest/userguide/delegated-admin.html) for IAM Identity Center. The delegated administrator feature is intended to minimize the number of people who require access to the management account.

> The delegated adminstrator account (and TEAM) by design cannot be used to perform the following tasks:
  - Enable or disable user access in the management account
  - Manage permission sets provisioned in the management account
{: .note}

## Identity and access management
The TEAM solution is not a replacement for proper Identity and Access management. While it has delegated access to manage your AWS IAM Identity Center environment, it does not ensure that proper configurations or access controls are implemented; nor does it assume proper controls and configuration of the roles you enable users to request within the TEAM app. Please familiarize yourself with the SLA and product pages for the leveraged AWS services for more information.

## Appsync API security
AWS Appsync API endpoints for now support TLS 1.0 and 1.1, as well as some older cipher suites, for backwards compatibility with a long tail of older clients that cannot use more modern TLS configurations. They do so, however, using a number of mitigations such that, especially when combined with Sigv4, which independently provides message integrity as well as not being subject to replay attacks, make the use of 1.0 and 1.1 perfectly reasonable. In any case, those older protocols are only offered to clients, not required; and the actual protocol and cipher suite are fully client-selectable, so any customer using more modern clients will automatically negotiate TLS 1.2 and modern cipher suites. So in reality there is absolutely nothing dangerous or risky about the TLS behavior of these services. Note: Support for TLS 1.0 and 1.1 will end during 2023, see [documentation](https://aws.amazon.com/blogs/security/tls-1-2-required-for-aws-endpoints/.)

Furthermore, the TEAM solution does not enable WAF on the AppSync api endpoint by default. You can use AWS WAF to protect your AppSync API from common web exploits, such as SQL injection and cross-site scripting (XSS) attacks. These could affect API availability and performance, compromise security, or consume excessive resources. For example, you can use rate-based rules to specify the number of web requests that are allowed by each client IP in a trailing, continuously updated, 5-minute period. For further information on integrating AWS WAF with your AppSync API, see AWS [documentation](https://docs.aws.amazon.com/appsync/latest/devguide/WAF-Integration.html)

## Amplify S3 bucket access logging
AWS Amplify creates an s3 bucket for storing artifacts for deploying the TEAM application. 
> It is recommended to enable **Server access logging** for the bucket. However, each organization has its own directives on how this must be achieved. E.g. some organizations mandate that the server access logs be sent to a bucket in a central log archive account which entails additional cross-account permissions. Please refer to [Enabling Amazon S3 server access logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html) for an explanation on how this can be achieved.
{: .note}