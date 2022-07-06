package gestioneDB;

import beans.Soggetto;
import beans.Utente;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneUtenti {
    private static GestioneUtenti istanza;
    
    public  static GestioneUtenti getIstanza(){
        if(istanza==null)
            istanza=new GestioneUtenti();
        return istanza;
    }
    /***
     * 
     * @param nomeutente
     * @param password
     * @return 
     */
    public  Utente login(String nomeutente,String password){
        Utente utente=null;
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT * FROM soggetti "
                + "WHERE "
                + "soggetti.nomeutente="+Utility.isNull(nomeutente)+" AND "
                + "soggetti.password="+Utility.isNull(password)+" AND "
                + "soggetti.stato='1' ";        
        try{
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
               utente=new Utente();
               utente.setId(rs.getString("id"));
               utente.setNomeutente(rs.getString("nomeutente"));
               utente.setPassword(rs.getString("password"));
               utente.setNome(rs.getString("nome"));
               utente.setCognome(rs.getString("cognome"));
               utente.setPrivilegi(rs.getString("privilegi"));
            }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneUtenti", "login", ex);
        } finally {                     
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);           
                DBConnection.releaseConnection(conn);
          
        }                    
        return utente;
    }
    
    /***
     * 
     * @param query_input
     * @return 
     */
    public  ArrayList<Utente> ricerca(String query_input){
        ArrayList<Utente> toReturn=new ArrayList<Utente>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT * FROM soggetti WHERE "
                + ""+query_input;        
        try{
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);            
            while(rs.next()){   
               Utente utente=new Utente();
               utente.setId(rs.getString("soggetti.id"));
               utente.setCodice(rs.getString("soggetti.codice"));
               utente.setAlias(rs.getString("soggetti.alias"));
               utente.setNome(rs.getString("soggetti.nome"));
               utente.setCognome(rs.getString("soggetti.cognome"));
               utente.setRagionesociale(rs.getString("soggetti.ragionesociale"));
               utente.setPiva(rs.getString("soggetti.piva"));
               utente.setCf(rs.getString("soggetti.cf"));
               utente.setPec(rs.getString("soggetti.pec"));
               utente.setTipologia(rs.getString("soggetti.tipologia"));
               utente.setCosto(rs.getDouble("soggetti.costo"));
               utente.setNote(rs.getString("soggetti.note"));
               utente.setStato(rs.getString("soggetti.stato"));
               
               utente.setPrivilegi(rs.getString("soggetti.privilegi"));
               utente.setNomeutente(rs.getString("soggetti.nomeutente"));
               utente.setPassword(rs.getString("soggetti.password"));
               
               toReturn.add(utente);
            }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneUtenti", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        return toReturn;
    }
    
    
}
