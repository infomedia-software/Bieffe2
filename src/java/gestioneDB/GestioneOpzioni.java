package gestioneDB;

import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneOpzioni {

    private static GestioneOpzioni istanza;
    
    private static HashMap<String,String> opzioni;
    
    
    public static String ATTIVITA_LIBERO_1="ATTIVITA_LIBERO_1";
    public static String ATTIVITA_LIBERO_2="ATTIVITA_LIBERO_2";
    public static String ATTIVITA_LIBERO_3="ATTIVITA_LIBERO_3";
    public static String ATTIVITA_LIBERO_4="ATTIVITA_LIBERO_4";
    public static String ATTIVITA_LIBERO_5="ATTIVITA_LIBERO_5";
    public static String ATTIVITA_LIBERO_6="ATTIVITA_LIBERO_6";
    public static String ATTIVITA_LIBERO_7="ATTIVITA_LIBERO_7";
    
    public static GestioneOpzioni getIstanza(){
        if(istanza==null){
            istanza=new GestioneOpzioni();
            carica_opzioni();
        }
        return istanza;
    }
    
    /**
     * 
     * @param opzione
     * @return 
     */
    public  String getOpzione(String opzione){
       String toReturn="";
       if(opzioni.get(opzione)!=null)
           toReturn=opzioni.get(opzione);
       return toReturn;
    }
    
    
    /**
     * Metodo per caricare le opzioni
     * @return 
     */
    public static  String carica_opzioni(){
        opzioni=new HashMap<String,String>();
        String toReturn="";
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM opzioni WHERE 1;";
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){
                String etichetta=rs.getString("etichetta");
                String valori=rs.getString("valori");
                opzioni.put(etichetta, valori);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneOpzioni", "carica_opzioni", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneOpzioni", "carica_opzioni", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }       
        return toReturn;
    }
}
