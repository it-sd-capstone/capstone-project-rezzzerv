#!/bin/bash

# Create necessary directories
mkdir -p build/WEB-INF/classes
mkdir -p build/WEB-INF/lib

# Compile Java files
echo "Compiling Java files..."
find src/main/java -name "*.java" | xargs javac -d build/WEB-INF/classes -cp "lib/*:build/WEB-INF/classes"

# Copy web resources
echo "Copying web resources..."
cp -r src/main/webapp/* build/

# Copy libraries
echo "Copying libraries..."
if [ -d "lib" ]; then
  cp -r lib/* build/WEB-INF/lib/
else
  echo "Warning: lib directory not found. No libraries copied."
fi

# Make sure WEB-INF/web.xml exists
if [ -f src/main/webapp/WEB-INF/web.xml ]; then
  mkdir -p build/WEB-INF
  cp src/main/webapp/WEB-INF/web.xml build/WEB-INF/
else
  echo "Warning: web.xml not found at src/main/webapp/WEB-INF/web.xml"
  # Create a minimal web.xml if it doesn't exist
  mkdir -p build/WEB-INF
  cat > build/WEB-INF/web.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
         version="5.0">
    <!-- This makes sure index.jsp is the homepage -->
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
</web-app>
EOF
  echo "Created a minimal web.xml file"
fi

echo "Build completed successfully!"
