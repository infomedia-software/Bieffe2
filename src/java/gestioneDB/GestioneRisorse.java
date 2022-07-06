package gestioneDB;

import beans.Fase;
import beans.Risorsa;
import beans.Soggetto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneRisorse {
    private static GestioneRisorse istanza;
    
    public static GestioneRisorse getIstanza(){
        if(istanza==null)
            istanza=new GestioneRisorse();
        return istanza;
    }
    
    /***
     * 
     * @param q
     * @return 
     */
    public ArrayList<Risorsa> ricercaRisorse(String q){
        ArrayList<Risorsa> toReturn=new ArrayList<Risorsa>();          
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        if(q.equals(""))
            q=" risorse.stato='1' ORDER BY risorse.ordinamento ASC";
        String query="SELECT * FROM risorse LEFT OUTER JOIN fasi ON risorse.fase=fasi.id "
                + "WHERE "+q;                
            
        try{
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                Risorsa r=new Risorsa();
                r.setCodice(rs.getString("risorse.codice"));
                r.setId(rs.getString("risorse.id"));                
                
                r.setInizio(rs.getString("risorse.inizio"));
                r.setFine(rs.getString("risorse.fine"));
                r.setInizio2(rs.getString("risorse.inizio2"));
                r.setFine2(rs.getString("risorse.fine2"));
                r.setInizio3(rs.getString("risorse.inizio3"));
                r.setFine3(rs.getString("risorse.fine3"));
                
                r.setNome(rs.getString("risorse.nome"));                
                r.setReparti(rs.getString("risorse.reparti"));
                r.setPlanning(rs.getString("risorse.planning"));
                String fase_string=rs.getString("risorse.fase");
                Fase fase=new Fase();
                if(fase_string.equals("")){
                    fase.setId("");
                    fase.setCodice("");
                    fase.setNome("");
                }else{
                    fase.setId(rs.getString("fasi.id"));
                    fase.setCodice(rs.getString("fasi.codice"));
                    fase.setNome(rs.getString("fasi.nome"));
                }
                r.setFase(fase);                
                r.setFasi_input(rs.getString("risorse.fasi_input"));
                r.setFasi_produzione(rs.getString("risorse.fasi_produzione"));
                r.setOrdinamento(rs.getString("risorse.ordinamento"));
                r.setNote(rs.getString("risorse.note"));
                toReturn.add(r);
            }        
            
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneRisorse", "ricercaRisorse", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        return toReturn;

    }
    
    
     /***
     * 
     * @param q
     * @return 
     */
    public Map<String,Risorsa> mappaRisorse(String q){
        Map<String,Risorsa> toReturn=new HashMap<String,Risorsa>();          
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        if(q.equals(""))
            q=" stato='1' ORDER BY ordinamento ASC";
        String query="SELECT * FROM risorse LEFT OUTER JOIN fasi ON risorse.fase=fasi.id "
                + "WHERE "+q;                
            
               
        try{
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                Risorsa r=new Risorsa();
                r.setCodice(rs.getString("risorse.codice"));
                r.setId(rs.getString("risorse.id"));                
                r.setInizio(rs.getString("risorse.inizio"));
                r.setFine(rs.getString("risorse.fine"));
                r.setNome(rs.getString("risorse.nome"));                
                r.setReparti(rs.getString("risorse.reparti"));
                r.setPlanning(rs.getString("risorse.planning"));
                Fase fase=new Fase();
                String fase_string=rs.getString("risorse.fase");
                if(fase_string.equals("")){
                    fase.setId("");
                    fase.setCodice("");
                    fase.setNome("");
                }else{
                    fase.setId(rs.getString("fasi.id"));
                    fase.setCodice(rs.getString("fasi.codice"));
                    fase.setNome(rs.getString("fasi.nome"));
                }
                r.setFase(fase);      
                r.setFasi_input(rs.getString("risorse.fasi_input"));
                r.setFasi_produzione(rs.getString("risorse.fasi_produzione"));
                r.setOrdinamento(rs.getString("risorse.ordinamento"));
                r.setNote(rs.getString("risorse.note"));
                toReturn.put(r.getId(),r);
            }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneRisorse", "mappaRisorse", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        return toReturn;

    }
    
    /**
     * 
     * @param query_risorse
     * @param data
     * @param planning_tipo
     * @return 
     */
    public SortedMap<String,Risorsa> ricerca_risorse_in_data(String query_risorse,String data,String planning_tipo){
        SortedMap<String,Risorsa> toReturn=new TreeMap<String,Risorsa>();
       
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{

        ArrayList<Risorsa> risorse=ricercaRisorse(query_risorse);
        
        conn=DBConnection.getConnection();       
            for(Risorsa risorsa:risorse){
                
            String query="SELECT risorsa,min(inizio) as start_risorsa,DATE_ADD(max(inizio), INTERVAL 30 MINUTE) as stop_risorsa FROM "+planning_tipo+" WHERE "                        
                    + "risorsa="+Utility.isNull(risorsa.getId())+" AND "
                    + "valore!='-1' AND "
                    + "inizio>="+Utility.isNull(data+" 00:00:00")+" AND "
                    + "fine<="+Utility.isNull(data+" 23:59:59")+" ";              
            //System.out.println(query);
                stmt=conn.prepareStatement(query);
                rs=stmt.executeQuery(query);

                while(rs.next()){   
                    Risorsa temp=new Risorsa();
                    
                    String inizio=Utility.eliminaNull(rs.getString("start_risorsa"));
                    String fine=Utility.eliminaNull(rs.getString("stop_risorsa"));
                        temp.setInizio(inizio);
                        temp.setFine(fine);
                        temp.setId(risorsa.getId());
                        temp.setFasi_input(risorsa.getFasi_input());
                        temp.setFase(risorsa.getFase());
                        temp.setNome(risorsa.getNome());
                    toReturn.put(risorsa.getId(), temp);
                }                   
            }
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneRisorse", "ricerca_risorse_in_data", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                        
        return toReturn;        
    }
    
}
