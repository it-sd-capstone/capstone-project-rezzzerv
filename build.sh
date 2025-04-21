#!/bin/bash

# Create necessary directories
mkdir -p out/artifacts/ReZZZerv_war_exploded/WEB-INF/classes
mkdir -p out/artifacts/ReZZZerv_war_exploded/WEB-INF/lib

# Compile Java files
javac -d out/artifacts/ReZZZerv_war_exploded/WEB-INF/classes -cp "lib/*" src/**/*.java

# Copy web resources
cp -r web/* out/artifacts/ReZZZerv_war_exploded/

# Copy libraries
cp -r lib/* out/artifacts/ReZZZerv_war_exploded/WEB-INF/lib/

# Make sure WEB-INF/web.xml exists
if [ ! -f out/artifacts/ReZZZerv_war_exploded/WEB-INF/web.xml ]; then
  mkdir -p out/artifacts/ReZZZerv_war_exploded/WEB-INF
  cp web/WEB-INF/web.xml out/artifacts/ReZZZerv_war_exploded/WEB-INF/
fi

echo "Build completed successfully!"
