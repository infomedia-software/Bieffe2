package gestioneDB;

import java.sql.*;
import utility.GestioneErrori;


public class DBUtility {
     
   
    static public int executeOperation(Connection pConnect, String pSql) throws SQLException {
        Statement stmt = pConnect.createStatement();
        int tResult = stmt.executeUpdate(pSql);
        stmt.close();
        return tResult;
    }
               
            
    static public void closeQuietly(ResultSet rs){        
        try {
            if(rs!=null)
                rs.close();
        } catch (Exception ex) {
            GestioneErrori.errore("DBUtility", "closeQuietly-> ResultSet", ex);
        }
    }    
    
    static public void closeQuietly(PreparedStatement ps){        
        try {
            if(ps!=null)
                ps.close();
        } catch (Exception ex) {
            GestioneErrori.errore("DBUtility", "closeQuietly-> PreparedStatement", ex);
        }
    }    
    
      static public void closeQuietly(Statement ps){        
        try {
            if(ps!=null)
                ps.close();
        } catch (Exception ex) {
            GestioneErrori.errore("DBUtility", "closeQuietly-> PreparedStatement", ex);
        }
    }    
}
