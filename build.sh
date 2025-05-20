#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

echo "Starting build process..."

# Create necessary directories
mkdir -p build/WEB-INF/classes
mkdir -p build/WEB-INF/lib

# Build classpath from both possible library locations
CLASSPATH="."

# Check root lib directory
if [ -d "lib" ]; then
  echo "Found libraries in /lib directory"
  for jar in lib/*.jar; do
    CLASSPATH="$CLASSPATH:$jar"
  done
  # Copy these libraries to the build
  cp -r lib/* build/WEB-INF/lib/
else
  echo "No libraries found in /lib directory"
fi

# Check webapp lib directory
if [ -d "src/main/webapp/WEB-INF/lib" ]; then
  echo "Found libraries in /src/main/webapp/WEB-INF/lib directory"
  for jar in src/main/webapp/WEB-INF/lib/*.jar; do
    CLASSPATH="$CLASSPATH:$jar"
  done
  # These will be copied later when we copy the webapp resources
else
  echo "No libraries found in /src/main/webapp/WEB-INF/lib directory"
fi

echo "Using classpath: $CLASSPATH"

# Compile Java files - collect all files first, then compile together
echo "Compiling Java files..."
find src/main/java -name "*.java" > sources.txt
if [ -s sources.txt ]; then
  echo "Found Java source files to compile"

  # Compile all files in a single javac command with the classpath
  javac -classpath "$CLASSPATH" -d build/WEB-INF/classes @sources.txt

  # Check compilation result
  if [ $? -eq 0 ]; then
    echo "Compilation successful!"
  else
    echo "Compilation failed!"
    exit 1
  fi
else
  echo "No Java source files found!"
  exit 1
fi

# Copy web resources
echo "Copying web resources..."
cp -r src/main/webapp/* build/

# Make sure WEB-INF/web.xml exists
if [ -f build/WEB-INF/web.xml ]; then
  echo "web.xml found in the build"
else
  echo "Warning: web.xml not found in the build"
  # Create a minimal web.xml if it doesn't exist
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

# Verify libraries in the build
echo "Libraries in the build:"
find build/WEB-INF/lib -name "*.jar" | sort

# List all compiled classes for verification
echo "Compiled classes:"
find build/WEB-INF/classes -name "*.class" | sort

echo "Build completed successfully!"
