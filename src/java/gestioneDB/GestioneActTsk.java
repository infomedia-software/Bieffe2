package gestioneDB;

import beans.Act;
import beans.ActTsk;
import beans.Commessa;
import beans.Soggetto;
import beans.Utente;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneActTsk {

    private static GestioneActTsk istanza;
    
    public static GestioneActTsk getIstanza(){
        if(istanza==null)
            istanza=new GestioneActTsk();
        return istanza;
    }
    
    public ArrayList<ActTsk> tsk_attivi_utente(Utente utente){
        String query=" act_tsk.fine IS NULL AND act.stato='1' AND act_tsk.id_soggetto="+Utility.isNull(utente.getId());
        if(utente.is_amministratore())
            query=" act_tsk.fine IS NULL AND act.stato='1' ";
        ArrayList<ActTsk> toReturn=ricerca(query);
        return toReturn;        
    }
    
    public ActTsk get_act_tsk(String id_act_tsk){
        ActTsk toReturn=null;
        ArrayList<ActTsk> temp=GestioneActTsk.getIstanza().ricerca(" act_tsk.id="+id_act_tsk+" AND act_tsk.stato='1'");
        if(temp.size()==1)
            toReturn=temp.get(0);
        return toReturn;        
    }
    
    public ArrayList<ActTsk> ricerca(String query_input){
        ArrayList<ActTsk> toReturn=new ArrayList<ActTsk>();
                
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT act_tsk.*,act.*,commesse.id,commesse.descrizione,commesse.soggetto,commesse.colore,commesse.numero,clienti.id,clienti.alias,soggetti.id,soggetti.cognome,soggetti.nome "                
                + "FROM act_tsk "
                + "LEFT OUTER JOIN act ON act_tsk.id_act=act.id "
                + "LEFT OUTER JOIN commesse ON act.id_commessa=commesse.id "                
                + "LEFT OUTER JOIN soggetti as clienti ON commesse.soggetto=clienti.id "                
                + "LEFT OUTER JOIN soggetti ON act_tsk.id_soggetto=soggetti.id "
                + "WHERE "+query_input;        
        System.out.println(query);
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
           
            while(rs.next()){   
                ActTsk temp=new ActTsk();
                    temp.setId(rs.getString("act_tsk.id"));
                    temp.setInizio(rs.getString("act_tsk.inizio"));
                    temp.setFine(rs.getString("act_tsk.fine"));
                    temp.setNote(rs.getString("act_tsk.note"));
                    Act act=new Act();
                        act.setId(rs.getString("act.id"));
                        act.setInizio(rs.getString("act.inizio"));
                        act.setFine(rs.getString("act.fine"));
                        act.setDurata(rs.getDouble("act.durata"));
                        act.setRitardo(rs.getDouble("act.ritardo"));
                        act.setAttiva(rs.getString("act.attiva"));
                        act.setCompletata(rs.getString("act.completata"));
                        
                        act.setDescrizione(rs.getString("act.descrizione"));
                            Commessa commessa=new Commessa();
                            commessa.setId(rs.getString("commesse.id"));
                            commessa.setColore(rs.getString("commesse.colore"));
                            commessa.setNumero(rs.getString("commesse.numero"));
                            commessa.setDescrizione(rs.getString("commesse.descrizione"));
                        
                            Soggetto cliente=new Soggetto(); 
                            cliente.setId(rs.getString("clienti.id"));
                            cliente.setAlias(rs.getString("clienti.alias"));
                            commessa.setSoggetto(cliente);
                            act.setCommessa(commessa);    
                        temp.setAct(act);
                        
                        Soggetto soggetto=new Soggetto();
                        soggetto.setId(rs.getString("soggetti.id"));
                        soggetto.setCognome(rs.getString("soggetti.cognome"));
                        soggetto.setNome(rs.getString("soggetti.nome"));
                        temp.setSoggetto(soggetto);
                        
                    temp.setAct(act);
                toReturn.add(temp);
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActTsk", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }                    
        
        return toReturn;
    }
}
