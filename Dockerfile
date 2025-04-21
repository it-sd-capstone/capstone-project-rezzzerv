FROM tomcat:10-jdk21

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your web application to Tomcat's webapps directory
COPY out/artifacts/ReZZZerv_war_exploded/ /usr/local/tomcat/webapps/ROOT/

# Expose the port Tomcat runs on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
