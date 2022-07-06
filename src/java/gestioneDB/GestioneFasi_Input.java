package gestioneDB;

import beans.Fase;
import beans.Fase_Input;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import utility.GestioneErrori;


public class GestioneFasi_Input {

    private static GestioneFasi_Input istanza;
    
    public static GestioneFasi_Input getIstanza(){
        if(istanza==null)
            istanza=new GestioneFasi_Input();
        return istanza;
    }
    
      
     /**
     * Metodo per ricercare le fasi presenti nel DB Infogest
     * @param q
     * @return 
     */
    public  ArrayList<Fase_Input> ricerca(String q){
        ArrayList<Fase_Input> toReturn=new ArrayList<Fase_Input>();        
        try{
            Connection conn=DBConnection.getConnection();
            if(q.equals(""))
                q=" 1 ORDER BY fasi_input.codice ASC";
            String query="SELECT * FROM fasi_input LEFT OUTER JOIN fasi ON fasi_input.fase=fasi.id WHERE "+q;
            //System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               Fase_Input act=new Fase_Input();
               
               act.setId(rs.getString("id"));
               act.setCodice(rs.getString("codice"));
               act.setNome(rs.getString("nome"));
               act.setNote(rs.getString("note"));
               act.setCategoria(rs.getString("categoria"));
               act.setStato(rs.getString("fasi_input.stato"));
               act.setEsterna(rs.getString("fasi_input.esterna"));
               act.setStampa(rs.getString("fasi_input.stampa"));
               act.setAllestimento(rs.getString("fasi_input.allestimento"));
               String fase_string=rs.getString("fase");
               Fase fase=new Fase();
               if(fase_string.equals("")){
                   fase.setId("");
                   fase.setCodice("");
                   fase.setNome("");
                   fase.setOrdinamento(0);
               }else{
                    fase.setId(rs.getString("fasi.id"));
                    fase.setCodice(rs.getString("fasi.codice"));
                    fase.setNome(rs.getString("fasi.nome"));
                    fase.setOrdinamento(rs.getInt("fasi.ordinamento"));
               }
               act.setFase(fase);
               
               toReturn.add(act);
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Fase_Input", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Fase_Input", "ricerca", ex);
        }
        
        return toReturn;
    }

 
     public synchronized  Map<String,Fase_Input> mappa(String q){
        Map<String,Fase_Input> toReturn=new HashMap<String,Fase_Input>();        
        try{
            Connection conn=DBConnection.getConnection();
            if(q.equals(""))
                q=" 1 ORDER BY fasi_input.codice ASC";
            String query="SELECT * FROM fasi_input LEFT OUTER JOIN fasi ON fasi_input.fase=fasi.id WHERE "+q;
            System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               Fase_Input act=new Fase_Input();
               
               act.setId(rs.getString("id"));
               act.setCodice(rs.getString("codice"));
               act.setNome(rs.getString("nome"));
               act.setNote(rs.getString("note"));
               act.setCategoria(rs.getString("categoria"));
               act.setStato(rs.getString("fasi_input.stato"));
               
               String fase_string=rs.getString("fase");
               Fase fase=new Fase();
               if(fase_string.equals("")){
                   fase.setId("");
                   fase.setCodice("");
                   fase.setNome("");
                   fase.setOrdinamento(0);
               }else{
                    fase.setId(rs.getString("fasi.id"));
                    fase.setCodice(rs.getString("fasi.codice"));
                    fase.setNome(rs.getString("fasi.nome"));
                    fase.setOrdinamento(rs.getInt("fasi.ordinamento"));
               }
               act.setFase(fase);
               
               toReturn.put(act.getCodice().toUpperCase(),act);               
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneFasi_Input", "mappa", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneFasi_Input", "mappa", ex);
        }
        
        return toReturn;
    }
    
}
