# Copyright 2023 Amazon Web Services, Inc
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env bash

. "./parameters.sh"

export AWS_PROFILE=$TEAM_ACCOUNT_PROFILE

cognitoUserpoolId=`aws cognito-idp list-user-pools --max-results 10 | jq -r '.UserPools[] | select(.Name | contains("team06dbb7fc")) | .Id'`
clientID=`aws cognito-idp list-user-pool-clients --user-pool-id $cognitoUserpoolId | jq -r '.UserPoolClients[] | select(.ClientName | contains("clientWeb")) | .ClientId'`
applicationURL=`aws amplify list-apps | jq -r '.apps[] | select(.name=="TEAM-IDC-APP") | .defaultDomain' `
appURL=`aws cognito-idp describe-user-pool-client --user-pool-id $cognitoUserpoolId --client-id $clientID | jq -r '.UserPoolClient | .CallbackURLs[]'`
callbackUrl="$appURL"

aws cognito-idp create-identity-provider --user-pool-id $cognitoUserpoolId --provider-name=IDC --provider-type SAML --provider-details file://details.json --attribute-mapping email=Email --idp-identifiers team
aws cognito-idp update-user-pool-client --user-pool-id $cognitoUserpoolId \
--client-id $clientID \
--refresh-token-validity 1 \
--supported-identity-providers IDC \
--allowed-o-auth-flows code \
--allowed-o-auth-scopes "phone" "email" "openid" "profile" "aws.cognito.signin.user.admin" \
--logout-urls $callbackUrl \
--callback-urls $callbackUrl \
--allowed-o-auth-flows-user-pool-client