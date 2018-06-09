# s3-tools
Simple scripts for working with AWS S3 API

# Overview
## Upload
Uploads a specified file to the remote S3 bucket using either WGet or Curl. You can change the behaviour in the script by changing the called function.

A file will be encrypted prior to upload using a *public.key* in the execution directory.

## Download
Downloads a specified file from a remote S3 bucket using WGet or Curl. You can change the behaviour in the script by changing the called function.

# Usage
## Upload
Make sure you know:
* Your S3 bucket identifier
* Your S3 access identifier
* Your S3 secret
* A file to upload.

Also make sure you have generated a asymmetric key pair using OpenSSL. See below.

To execute the process:
```
./upload.sh S3_KEY_ID S3_KEY_SECRET S3_BUCKET_NAME FILE_NAME
```
## Download
*Assumes to download a file example.upload.encrypted*

Make sure you know:
* Your S3 bucket identifier
* Your S3 access identifier
* Your S3 secret

To execute the process:
```
./upload.sh S3_KEY_ID S3_KEY_SECRET S3_BUCKET_NAME
```
## Generating an OpenSSL Asymmetric key-pair
```
openssl genrsa -out private.key 1024
openssl rsa -in private.key -out public.key -outform PEM -pubout
```
