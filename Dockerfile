# First stage: build the JAR file
FROM registry.access.redhat.com/ubi8/openjdk-17:1.16-2 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package

# Second stage: create the final image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5
MAINTAINER Muhammad Edwin <edwin at redhat dot com>
LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
LABEL JAVA_VERSION="11"

RUN microdnf install --nodocs java-11-openjdk-headless && microdnf clean all

WORKDIR /work/
COPY --from=builder /app/target/*.jar /work/application.jar

EXPOSE 8080
CMD ["java", "-jar", "application.jar"]
