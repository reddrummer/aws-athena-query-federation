#!/bin/bash
set -x

aws athena --profile drumwave-sbx \
    create-data-catalog \
  --name ext_cat_gcs_bdb \
  --type LAMBDA \
  --description "Google Cloud Storage Connector" \
  --parameters function=arn:aws:lambda:us-east-1:058264346350:function:AthenaGcsConnector

export AWS_ACCOUNT_ID=058264346350

aws glue --profile drumwave-sbx create-database \
  --catalog-id ${AWS_ACCOUNT_ID} \
  --database-input '{
    "Name": "gcs_bdb",
    "Description": "Database for GCS data",
    "LocationUri": "google-cloud-storage-flag"
}'

aws glue --profile drumwave-sbx create-table --database-name gcs_bdb --table-input '{
    "Name": "cc_fatura",
    "StorageDescriptor": {
        "Columns": [
            {"Name": "transactionid", "Type": "string"},
            {"Name": "cnpjcpfnumber", "Type": "string"},
            {"Name": "identificationnumber", "Type": "string"},
            {"Name": "transactionname", "Type": "string"},
            {"Name": "billid", "Type": "string"},
            {"Name": "creditdebittype", "Type": "string"},
            {"Name": "transactiontype", "Type": "string"},
            {"Name": "transactionaladditionalinfo", "Type": "string"},
            {"Name": "paymenttype", "Type": "string"},
            {"Name": "feetype", "Type": "string"},
            {"Name": "feetypeadditionalinfo", "Type": "string"},
            {"Name": "othercreditstype", "Type": "string"},
            {"Name": "othercreditsadditionalinfo", "Type": "string"},
            {"Name": "chargeidentificator", "Type": "bigint"},
            {"Name": "chargenumber", "Type": "bigint"},
            {"Name": "brazilianamount_amount", "Type": "double"},
            {"Name": "brazilianamount_currency", "Type": "string"},
            {"Name": "amount_amount", "Type": "double"},
            {"Name": "amount_currency", "Type": "string"},
            {"Name": "transactiondate", "Type": "string"},
            {"Name": "billpostdate", "Type": "string"},
            {"Name": "payeemcc", "Type": "bigint"}
        ],
        "Location": "gs://dw-bdb-gcp/cc_fatura/",
        "InputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
        "OutputFormat": "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat",
        "SerdeInfo": {
            "SerializationLibrary": "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
        }
    },
    "TableType": "EXTERNAL_TABLE",
    "Parameters": {
        "classification": "parquet",
        "sourceFile": "cc_fatura.parquet"
    }
}'
