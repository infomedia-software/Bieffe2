package gestioneDB;

import beans.Allegato;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;


public class GestioneAllegati {

    private static GestioneAllegati istanza;
    
    public static GestioneAllegati getIstanza(){
        if(istanza==null)  
            istanza=new GestioneAllegati();
        return istanza;
    }
    
    /**
     * Metodo per ricercare gli allegati
     * @param q
     * @return 
     */
    public  ArrayList<Allegato> ricercaAllegati(String q){
        ArrayList<Allegato> toReturn=new ArrayList<Allegato>();
        try {                        
            Connection conn=DBConnection.getConnection();
            String query="SELECT * FROM allegati WHERE "+q;
            //System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
                Allegato temp=new Allegato();
                temp.setId(rs.getInt("allegati.id"));
                temp.setIdrif(rs.getString("allegati.idrif"));
                temp.setRif(rs.getString("allegati.rif"));
                temp.setUrl(rs.getString("allegati.url"));
                temp.setDescrizione(rs.getString("allegati.descrizione"));
                temp.setData(rs.getString("allegati.data"));
                temp.setStato(rs.getString("allegati.stato"));
                toReturn.add(temp);
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneAllegati", "ricercaAllegati", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneAllegati", "ricercaAllegati", ex);
        }
        return toReturn;
    }
    
            
}
