FROM tomcat:10-jdk21

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Install necessary build tools
RUN apt-get update && apt-get install -y openjdk-21-jdk

# Create a working directory
WORKDIR /app

# Copy the entire repository
COPY . /app/

# Make build script executable
RUN chmod +x /app/build.sh

# Run the build script
RUN /app/build.sh

# Copy the built application to Tomcat's webapps directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/ \
    && cp -r /app/build/* /usr/local/tomcat/webapps/ROOT/

# Expose the port Tomcat runs on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
