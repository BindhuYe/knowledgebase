FROM maven:3.8.4-openjdk-11
WORKDIR /app
COPY pom.xml . 
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package
CMD ["java", "-jar", "target/bmi-1.0.jar"]
EXPOSE 8000