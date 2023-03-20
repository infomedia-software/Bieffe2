package gestioneDB;

import beans.ActPh;
import beans.Fase;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;


public class GestioneActPh {
 
    private static GestioneActPh istanza;

    public static GestioneActPh getIstanza(){
        if(istanza==null)
            istanza=new GestioneActPh();
        return istanza;
    }
        
    public ArrayList<ActPh> ricerca(String q){
        ArrayList<ActPh> toReturn=new ArrayList<ActPh>();        
        try{
            Connection conn=DBConnection.getConnection();
            if(q.equals(""))
                q=" stato='1' ORDER BY act_ph.ordinamento ASC";
            String query="SELECT * FROM act_ph WHERE "+q;            
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               ActPh act=new ActPh();
               act.setId(rs.getString("id"));
               act.setCodice(rs.getString("codice"));
               act.setNome(rs.getString("nome"));
               act.setNote(rs.getString("note"));
               act.setCategoria(rs.getString("categoria"));
               act.setStato(rs.getString("stato"));
               act.setOrdinamento(rs.getInt("ordinamento"));
               toReturn.add(act);
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneActPh", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneActPh", "ricerca", ex);
        }        
        return toReturn;
    }
}
