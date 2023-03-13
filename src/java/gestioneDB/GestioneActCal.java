package gestioneDB;


import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import utility.GestioneErrori;


public class GestioneActCal {

    private static GestioneActCal istanza;
    
    public static GestioneActCal getIstanza(){
        if(istanza==null)
            istanza=new GestioneActCal();
        return istanza;
    }
    
    public Map<String,String> ricerca(String query_input){
        Map<String,String> toReturn=new TreeMap<String,String>();
                  
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT * FROM act_cal WHERE "+query_input;        
        System.out.println(query);
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                String data=rs.getString("data");
                String attivo=rs.getString("attivo");
                toReturn.put(data, attivo);
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActCal", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        
        return toReturn;
    }
}
