S3KEY=$1
S3SECRET=$2
S3BUCKET=$3
FILE_UPLOAD=$4

function putS3WGet
{
  echo "Uploading file using WGET $FILE_UPLOAD"

  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:private"
  content_type='binary/octet-stream'
  string="PUT\n\n$content_type\n$date\n$acl\n/$S3BUCKET/$FILE_UPLOAD"
  
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  wget --method=PUT --body-file "$FILE_UPLOAD" \
    --header "Host: $S3BUCKET.s3.amazonaws.com" \
    --header "Date: $date" \
    --header "Content-Type: $content_type" \
    --header "$acl" \
    --header "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$FILE_UPLOAD"
  result=$?
}



function putS3
{
  echo "Uploading file $FILE_UPLOAD"

  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:private"
  content_type='binary/octet-stream'
  string="PUT\n\n$content_type\n$date\n$acl\n/$S3BUCKET/$FILE_UPLOAD"
  
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  curl -X PUT -T "$FILE_UPLOAD" \
    -H "Host: $S3BUCKET.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$FILE_UPLOAD"
  result=$?
}


putS3WGet
if [ $result -eq 0 ]; then
    echo "Upload successful"
else
    echo "Upload Failure $result"
	exit -2
fi
