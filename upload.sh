S3KEY=$1
S3SECRET=$2
S3BUCKET=$3
FILE_UPLOAD=$4

PUBKEY=public.key
ENCRYPTION_SUFFIX=encrypted
ENCRYPTED_FILE_TO_UPLOAD=$FILE_UPLOAD.$ENCRYPTION_SUFFIX


function encryptFile
{  
  echo "Encrypting file $FILE_UPLOAD"
  
  openssl rsautl -encrypt -pubin -inkey $PUBKEY -in $FILE_UPLOAD -out $ENCRYPTED_FILE_TO_UPLOAD
  encrypt_result=$?
}



function putS3WGet
{
  echo "Uploading file using WGET $ENCRYPTED_FILE_TO_UPLOAD"

  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:private"
  content_type='binary/octet-stream'
  string="PUT\n\n$content_type\n$date\n$acl\n/$S3BUCKET/$ENCRYPTED_FILE_TO_UPLOAD"
  
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  wget --method=PUT --body-file "$ENCRYPTED_FILE_TO_UPLOAD" \
    --header "Host: $S3BUCKET.s3.amazonaws.com" \
    --header "Date: $date" \
    --header "Content-Type: $content_type" \
    --header "$acl" \
    --header "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$ENCRYPTED_FILE_TO_UPLOAD"
  result=$?
}



function putS3
{
  echo "Uploading file $ENCRYPTED_FILE_TO_UPLOAD"

  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:private"
  content_type='binary/octet-stream'
  string="PUT\n\n$content_type\n$date\n$acl\n/$S3BUCKET/$ENCRYPTED_FILE_TO_UPLOAD"
  
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  curl -X PUT -T "$ENCRYPTED_FILE_TO_UPLOAD" \
    -H "Host: $S3BUCKET.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$ENCRYPTED_FILE_TO_UPLOAD"
  result=$?
}



encryptFile
if [ $encrypt_result -eq 0 ]; then
    echo "Encryption successful"
else
    echo "Encryption Failure $encrypt_result"
	exit -1
fi



putS3
if [ $result -eq 0 ]; then
    echo "Upload successful"
else
    echo "Upload Failure $result"
	exit -2
fi
