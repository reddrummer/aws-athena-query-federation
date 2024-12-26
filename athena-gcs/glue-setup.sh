aws athena --profile drumwave-sbx \
    create-data-catalog \
  --name external-cat-gcs-bdb \
  --type LAMBDA \
  --description "Google Cloud Storage Connector" \
  --parameters function=arn:aws:lambda:us-east-1:058264346350:function:AthenaGcsConnector
