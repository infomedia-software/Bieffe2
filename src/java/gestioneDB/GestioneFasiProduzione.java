package gestioneDB;

import beans.Fase;
import beans.Fase_Input;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;


public class GestioneFasiProduzione {

    private static GestioneFasiProduzione istanza;
    
    public static GestioneFasiProduzione getIstanza(){
        if(istanza==null)
            istanza=new GestioneFasiProduzione();
        return istanza;
    }
    
    /**
     * 
     * @param q
     * @return 
     */
    public synchronized ArrayList<Fase_Input> ricerca(String q){
        ArrayList<Fase_Input> toReturn=new ArrayList<Fase_Input>();        
        try{
            Connection conn=DBConnection.getConnection();
            if(q.equals(""))
                q=" 1 ORDER BY fasi_produzione.codice ASC";
            String query="SELECT * FROM fasi_produzione WHERE "+q;
            //System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               Fase_Input act=new Fase_Input();
               
               act.setId(rs.getString("id"));
               act.setCodice(rs.getString("codice"));
               act.setNome(rs.getString("nome"));
               act.setNote(rs.getString("note"));
               act.setStato(rs.getString("fasi_produzione.stato"));
               
               toReturn.add(act);
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneFasiProduzione", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneFasiProduzione", "ricerca", ex);
        }
        
        return toReturn;
    }
}
