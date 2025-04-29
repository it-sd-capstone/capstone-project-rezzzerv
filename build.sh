#!/bin/bash

# Create necessary directories
mkdir -p out/artifacts/rezzzerv_war_exploded/WEB-INF/classes
mkdir -p out/artifacts/rezzzerv_war_exploded/WEB-INF/lib

# Compile Java files
echo "Compiling Java files..."
find src/main/java -name "*.java" | xargs javac -d out/artifacts/rezzzerv_war_exploded/WEB-INF/classes -cp "lib/*:out/artifacts/rezzzerv_war_exploded/WEB-INF/classes"

# Copy web resources
echo "Copying web resources..."
cp -r src/main/webapp/* out/artifacts/rezzzerv_war_exploded/

# Copy libraries
echo "Copying libraries..."
if [ -d "lib" ]; then
  cp -r lib/* out/artifacts/rezzzerv_war_exploded/WEB-INF/lib/
else
  echo "Warning: lib directory not found. No libraries copied."
fi

# Make sure WEB-INF/web.xml exists
if [ -f src/main/webapp/WEB-INF/web.xml ]; then
  mkdir -p out/artifacts/rezzzerv_war_exploded/WEB-INF
  cp src/main/webapp/WEB-INF/web.xml out/artifacts/rezzzerv_war_exploded/WEB-INF/
else
  echo "Warning: web.xml not found at src/main/webapp/WEB-INF/web.xml"
fi

echo "Build completed successfully!"
# Test
