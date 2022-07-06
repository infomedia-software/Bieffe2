package gestioneDB;

import connection.ConnectionPoolException;
import connection.ConnectionPool_External_DB;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection_External_DB {
          
    public static Connection getConnection() throws ConnectionPoolException {
        Connection toReturn=null;
        toReturn=ConnectionPool_External_DB.getConnectionPool().getConnection();        
        return toReturn;
    }
    
    
    
    
    
    public static void releaseConnection(Connection conn){       
        try {
            ConnectionPool_External_DB.getConnectionPool().releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            Logger.getLogger(DBConnection_External_DB.class.getName()).log(Level.SEVERE, null, ex);
        }
    }        
}
