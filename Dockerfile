FROM tomcat:10-jdk21

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Install necessary build tools
RUN apt-get update && apt-get install -y openjdk-21-jdk

# Create a working directory
WORKDIR /app

# Copy the entire repository
COPY . /app/

# Create necessary directories
RUN mkdir -p /app/out/artifacts/ReZZZerv_war_exploded/WEB-INF/classes \
    && mkdir -p /app/out/artifacts/ReZZZerv_war_exploded/WEB-INF/lib

# Make build script executable and run it
RUN chmod +x /app/build.sh && /app/build.sh

# Copy the built application to Tomcat's webapps directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/ \
    && cp -r /app/out/artifacts/ReZZZerv_war_exploded/* /usr/local/tomcat/webapps/ROOT/

# Expose the port Tomcat runs on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
