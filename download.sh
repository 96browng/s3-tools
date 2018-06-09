S3KEY=$1
S3SECRET=$2
S3BUCKET=$3

download_dir=incoming



function getFiles
{
  file=example.upload.encrypted
  date=$(date +"%a, %d %b %Y %T %z")
  content_type='binary/octet-stream'
  string="GET\n\n$content_type\n$date\n/$S3BUCKET/$file"
  
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  
  curl -H "Host: $S3BUCKET.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$file" \
	-o $download_dir/$file
}

getFiles
