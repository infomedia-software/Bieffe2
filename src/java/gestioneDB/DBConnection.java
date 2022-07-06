package gestioneDB;

import connection.ConnectionPool;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
          
    public static Connection getConnection() throws ConnectionPoolException {
        Connection toReturn=null;
        toReturn=ConnectionPool.getConnectionPool().getConnection();        
        return toReturn;
    }
    
    
    
    
    
    public static void releaseConnection(Connection conn){       
        try {
            ConnectionPool.getConnectionPool().releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }        
}
