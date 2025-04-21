# ReZZZerv

ReZZZerv is a hotel reservation system built as a web application designed for desktop access. 
It allows users to register, log in, search for available rooms, view hotel details, and make or 
cancel reservations. The system is backed by a relational database and emphasizes usability, clean 
navigation, and a smooth booking experience for desktop users. The system is built using Java, 
HTML, CSS, and JavaScript, and uses MySQL or SQLite for database storage.

## Installation

To run this project:

1. Clone the repository:

   git clone git@github.com:it-sd-capstone/capstone-project-rezzzerv.git

2. Open the project in IntelliJ IDEA
    - IntelliJ will prompt you to import from existing sources. Accept the default configuration.

3. Configure dependencies:
    - Go to File → Project Structure → Modules → Dependencies
    - Click the + button → JARs or directories
    - Navigate to lib/servlet-api.jar and add it
    - Set the Scope to Provided

4. Set up your Tomcat server:
    - Go to Run → Edit Configurations
    - Add a new Tomcat Server → Local configuration
    - Under Deployment, click + → Artifact → your exploded WAR
    - Set Application context to /rezzzerv
    - In Before launch, ensure Build Artifacts is selected

## Testing

We use JUnit to test application functionality.

To run the tests:

- Open MainTest.java)
- Right-click the file and select Run MainTest

## Required JARs for Testing

Make sure the following JARs are in the lib/ folder and added to IntelliJ’s classpath with a Scope of Test:

- junit-jupiter-5.10.2.jar
- junit-jupiter-api-5.10.2.jar
- junit-jupiter-engine-5.10.2.jar
- junit-jupiter-params-5.10.2.jar
- junit-platform-commons-1.10.2.jar
- apiguardian-api-1.1.2.jar
- slf4j-api-2.0.9.jar
- slf4j-nop-2.0.9.jar


To add:

1. Go to File → Project Structure → Modules → Dependencies
2. Click + → JARs or directories
3. Select all JARs in the lib/ folder related to JUnit
4. Set the Scope to Test
5. Apply and close

## Usage

After building and launching the project through IntelliJ:

- Open your browser and visit the homepage:  
  (http://localhost:8080/rezzzerv/)

- To confirm servlet setup, visit the TestServlet:  
  (http://localhost:8080/rezzzerv/info)
