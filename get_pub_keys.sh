#!/usr/bin/env bash
# andre@bacao.pt

# Downloads the users public keys from AWS - IAM Groups - SSH
#
# Requires: awscli
# Requires: jq package to parse json

# Examples:
# TD_USERNAME "andre.bacao"
# UnsavedGroupName "sec" ou "sre" or "plat"

export UnsavedGroupName="$1"

COUNTER=0
NoUSERS=0
TD_USERNAME=""
PUBKEYDIR=".pubkeys"

# Force the creating of .pubkeys folder if it doesn't exists
if [[ ! -e $PUBKEYDIR ]]; then
    mkdir $PUBKEYDIR
elif [[ ! -d $PUBKEYDIR ]]; then
    echo "$PUBKEYDIR already exists but is not a directory" 1>&2
fi

NoUSERS=$(aws iam get-group --group-name "$UnsavedGroupName" --query "Users" | jq '.[] .UserName' | wc -l)

while [ $COUNTER -lt $NoUSERS ]; do
  TD_USERNAME=$(aws iam get-group --group-name "$UnsavedGroupName" --query "Users" | jq '.['$COUNTER'] .UserName' | tr -d '"')

  aws iam list-ssh-public-keys --user-name $TD_USERNAME --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" --output text | while read -r KeyId;
  do
    echo "Retrieving $TD_USERNAME key file..."
    aws iam get-ssh-public-key --user-name $TD_USERNAME --ssh-public-key-id "$KeyId" --encoding SSH --query "SSHPublicKey.SSHPublicKeyBody" --output text > .pubkeys/$TD_USERNAME.pub
  done
  let COUNTER=COUNTER+1
done
