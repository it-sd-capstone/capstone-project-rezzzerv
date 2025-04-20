package edu.cvtc.rezzzerv;

import edu.cvtc.rezzzerv.db.DbConnection;
import org.junit.Test;

import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.*;

public class MainTest {

    @Test
    public void TestGetConnection(){
        assertDoesNotThrow(() -> {

            // create connection
            Connection connection = DbConnection.getConnection();

            //comment the line above and
            //uncomment the line bellow to test failure.

            //Connection connection = null;

            // check to see if it is null
            assertNotNull(connection, "Connection should not be null");
            // check to see if the connection is open
            assertFalse(connection.isClosed(), "Connection should be open");
            // close connection
            connection.close();
            // is connection close?
            assertTrue(connection.isClosed(), "Connection should be closed");
        });

    }

}
