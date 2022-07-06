package gestioneDB;

import beans.Fase;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneFasi {
    
    private static GestioneFasi istanza;
    
    public static GestioneFasi getIstanza(){
        if(istanza==null)
            istanza=new GestioneFasi();
        return istanza;
    }
    
    
     /**
     * Metodo per ricercare le fasi presenti nel DB Infogest
     * @param q
     * @return 
     */
    public  ArrayList<Fase> ricerca(String q){
        ArrayList<Fase> toReturn=new ArrayList<Fase>();        
        try{
            Connection conn=DBConnection.getConnection();
            if(q.equals(""))
                q=" stato='1' ORDER BY fasi.codice ASC";
            String query="SELECT * FROM fasi WHERE "+q;
            //System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               Fase act=new Fase();
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
            GestioneErrori.errore("GestioneFasi", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneFasi", "ricerca", ex);
        }
        
        return toReturn;
    }
    

    
}
