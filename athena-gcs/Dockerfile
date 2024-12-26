FROM --platform=linux/amd64 public.ecr.aws/lambda/java:21

COPY target/athena-gcs-2022.47.1.jar ${LAMBDA_TASK_ROOT}/lib/
CMD ["com.amazonaws.athena.connectors.gcs.GcsCompositeHandler::handleRequest"]