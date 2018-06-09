S3KEY=$1
S3SECRET=$2
S3BUCKET=$3
FILEDATE=$4

download_dir=incoming


function getFilesWGet
{
  file="S1STD-UK_$1_1_1_999.PDF"

  echo "Downloading $file"

  date=$(date +"%a, %d %b %Y %T %z")
  string="GET\n\n\n$date\n/$S3BUCKET/$file"

  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)

  wget --header="Host: $S3BUCKET.s3.amazonaws.com" \
    --header="Date: $date" \
    --header="Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$file"
  RESULT=$?
  echo "Download complete"
}



function getFiles
{
  file="S1STD-UK_$1_1_1_999.PDF"

  echo "Download $file"

  date=$(date +"%a, %d %b %Y %T %z")
  content_type='binary/octet-stream'
  string="GET\n\n\n$date\n/$S3BUCKET/$file"
  echo $string

  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)

  curl -H "Host: $S3BUCKET.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$S3BUCKET.s3.amazonaws.com/$file" \
      -o $download_dir/$file
   RESULT=$?
   echo "Download complete"
}

getFilesWGet $FILEDATE
echo $RESULT
