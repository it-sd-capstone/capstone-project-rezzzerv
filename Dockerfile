FROM tomcat:10-jdk21

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Create a working directory
WORKDIR /app

# Copy the entire repository
COPY . /app/

# List all files and directories to verify the structure
RUN echo "Project structure:" && \
    ls -la && \
    echo "Libraries in lib directory:" && \
    ls -la lib/ || echo "No lib directory found" && \
    echo "Libraries in webapp/WEB-INF/lib directory:" && \
    ls -la src/main/webapp/WEB-INF/lib/ || echo "No webapp/WEB-INF/lib directory found"

# Make build script executable
RUN chmod +x /app/build.sh

# Run the build script
RUN /app/build.sh

# Copy the built application to Tomcat's webapps directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/ && \
    cp -r /app/build/* /usr/local/tomcat/webapps/ROOT/

# Verify all necessary classes exist in the deployed application
RUN echo "Verifying deployed classes:" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/model/users/ || echo "No users classes found" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/model/reserve/ || echo "No reserve classes found" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/model/rooms/ || echo "No rooms classes found" && \
    echo "Verifying deployed libraries:" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/ || echo "No libraries found"

# Expose the port Tomcat runs on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
