package gestioneDB;

import beans.Indirizzo;
import beans.Soggetto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneSoggetti {
    private static GestioneSoggetti istanza;
    
    public static GestioneSoggetti getIstanza(){
        if(istanza==null)
            istanza=new GestioneSoggetti();
        return istanza;
    }
    
    
    public  ArrayList<Soggetto> fornitori(){        
        return ricerca(" LOWER(soggetti.tipologia)='f' ORDER BY soggetti.alias ASC");
    }
    
    public  ArrayList<Soggetto> clienti(){        
        return ricerca(" LOWER(soggetti.tipologia)='c' ORDER BY soggetti.alias ASC");
    }
    
    public  ArrayList<Soggetto> ricerca(String query_input){
        ArrayList<Soggetto> toReturn=new ArrayList<Soggetto>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT * FROM soggetti WHERE "+query_input;        
        try{
            conn=DBConnection.getConnection();            
            //if(conn==null)
            //    System.out.println(" conn null");
            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                Soggetto s=new Soggetto();
                s.setId(rs.getString("soggetti.id"));
                s.setCodice(rs.getString("soggetti.codice"));
                s.setAlias(rs.getString("soggetti.alias"));
                s.setNome(rs.getString("soggetti.nome"));
                s.setCognome(rs.getString("soggetti.cognome"));
                s.setRagionesociale(rs.getString("soggetti.ragionesociale"));
                s.setPiva(rs.getString("soggetti.piva"));
                s.setCf(rs.getString("soggetti.cf"));
                for(int i=0;i<5;i++){
                    String indirizzo_temp=rs.getString("indirizzo"+i);               
                    if(!indirizzo_temp.equals("")){
                        Indirizzo indirizzo=new Indirizzo();                    
                        indirizzo.setIndirizzo(rs.getString("soggetti.indirizzo"+i));
                        indirizzo.setComune(rs.getString("soggetti.comune"+i));
                        indirizzo.setCap(rs.getString("soggetti.cap"+i));
                        indirizzo.setProvincia(rs.getString("soggetti.provincia"+i));
                        indirizzo.setNazione(rs.getString("soggetti.nazione"+i));
                        indirizzo.setTelefono(rs.getString("soggetti.telefono"+i));
                        indirizzo.setEmail(rs.getString("soggetti.email"+i));
                        s.aggiungi_indirizzo(indirizzo);
                    }
                }

                s.setPec(rs.getString("soggetti.pec"));
                s.setTipologia(rs.getString("soggetti.tipologia"));
                s.setCosto(rs.getDouble("soggetti.costo"));
                s.setNote(rs.getString("soggetti.note"));
                s.setStato(rs.getString("soggetti.stato"));
                toReturn.add(s);
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneSoggetti", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        return toReturn;
    }
    
    
      
    /**
     * 
     * @param id
     * @param tipologia
     * @return 
     */
    public  String nuovoSoggetto(String id,String tipologia){
        String stato="1";
        String query="INSERT INTO soggetti(id,tipologia,stato) "
                + "VALUES ("
                +Utility.isNull(id)+","
                +Utility.isNull(tipologia)+","
                +Utility.isNull(stato)+")";
        //System.out.println(query);
        Utility.getIstanza().query(query);   
        return id;
    }
  
    
}
