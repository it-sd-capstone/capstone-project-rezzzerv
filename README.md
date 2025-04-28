# ReZZZerv

ReZZZerv is a hotel reservation system built as a responsive web application. It allows users to register, log in, 
search for available rooms, view hotel details, and make or cancel reservations. The system is backed by a MySQL 
database and emphasizes usability, clean navigation, and a smooth booking experience for desktop and mobile users.

The system is built using:
- Java (Servlets)
- HTML, CSS, JavaScript (Frontend)
- MySQL (Database)
- Hosted using Tomcat locally and Render for deployment

## Installation

To run this project:

1. Clone the repository:
   git clone git@github.com:it-sd-capstone/capstone-project-rezzzerv.git

2. Open the project in IntelliJ IDEA
    - IntelliJ may prompt you to import from existing sources. Accept the default configuration.

3. Configure dependencies:
    - Go to File → Project Structure → Modules → Dependencies
    - Click the + button → JARs or directories
    - Navigate to the lib/ folder and add all the included JARs

4. Set up your Tomcat server:
    - Go to Run → Edit Configurations
   
    - Under Server Tab:
      - Add a new Tomcat Server → Local configuration
      - Change URL to http://localhost:8080/rezzzerv
   
    - Under Deployment Tab:
      - click + → Artifact → your exploded WAR
      - Change Application context to /rezzzerv
   
   - In Before launch, ensure Build Artifacts is selected
   - Apply and Ok

5. Configure Environment Variables
   - Create a resources directory in src/main.
   - Right-click on the resources folder and Mark Directory as Resources Root.
   - Create an .env file in the resources folder.
   - Add the following lines of text to the .env file using your local database credentials:
       DB_HOST=localhost 
       DB_NAME=rezzzerv_db
       DB_USER=root
       DB_PASSWORD=mysqlmysql

6. Database Setup
   - Ensure your MySQL server is running.
   - Create the database schema by:
     - Copying and pasting the text in the setup_db.txt file (in the db folder) into the query window.
     - Execute (click the lightning bolt)
   - Refresh schemas
   - Right-click on rezzzerv_db and "Set As Default Schema"


## Testing

We use JUnit to test application functionality.

7. Test your Local MySQL connection is established:
   - Open MainTest.java
   - Right-click the file and select Run MainTest, or select Current File in the drop-down and Click Play

8. Test adding a user to the db:
   - Open Main.java
   - Right-click the file and select Run Main, or select Current File in the drop-down and Click Play
   - Choose 1. Register Customer and follow the prompts
   - Check that the new user was added in MySQL Workbench:
     - refresh the rezzzerv_db schema
     - right-click on users and choose "Select Rows"


## Usage

After building and launching the project through IntelliJ:

- Open your browser and visit the homepage:  
  (http://localhost:8080/rezzzerv/)

- To confirm servlet setup, visit the TestServlet:  
  (http://localhost:8080/rezzzerv/info)
