package gestioneDB;

import beans.Consegna;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneCalendarioConsegne {
    
    private static GestioneCalendarioConsegne istanza;
    
    public static GestioneCalendarioConsegne getIstanza(){
        if(istanza==null)
            istanza=new GestioneCalendarioConsegne();
        return istanza;
    }
        
    public  ArrayList<Consegna> ricerca(String data){
        ArrayList<Consegna> toReturn=new ArrayList<Consegna>();        
        Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	try{
            String query="SELECT * "
                    + "FROM "
                        + "calendario_consegne "
                    + "WHERE "
                        + " (data_consegna="+Utility.isNull(data)+" OR  data_ritiro="+Utility.isNull(data)+") ";
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            while(rs.next()){                    
                Consegna consegna=new Consegna();
                    consegna.setId(rs.getString("id"));
                    consegna.setTipologia(rs.getString("tipologia"));
                    consegna.setTipologia(rs.getString("tipologia"));
                    consegna.setData_ritiro(rs.getString("data_ritiro"));
                    consegna.setData_consegna(rs.getString("data_consegna"));
                    consegna.setSoggetto_id(rs.getString("soggetto_id"));
                    consegna.setSoggetto_nome(rs.getString("soggetto_nome"));
                    consegna.setCommessa_descrizione(rs.getString("commessa_descrizione"));
                    consegna.setCommessa_cliente(rs.getString("commessa_cliente"));
                    consegna.setCommessa_numero(rs.getString("commessa_numero"));
                    consegna.setCommessa_note(rs.getString("commessa_note"));
                    consegna.setStampa(Utility.eliminaNull(rs.getString("stampa")));
                    consegna.setAllestimento(Utility.eliminaNull(rs.getString("allestimento")));
                    
                    consegna.setNote(rs.getString("note"));
                    String situazione=Utility.eliminaNull(rs.getString("situazione"));
                    consegna.setSituazione(situazione);
                toReturn.add(consegna);
            }  

	} catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneCalendarioConsegne", "ricerca", ex);
	} catch (SQLException ex) {
            GestioneErrori.errore("GestioneCalendarioConsegne", "ricerca", ex);
	} finally {
		DBUtility.closeQuietly(rs);
		DBUtility.closeQuietly(stmt);
		DBConnection.releaseConnection(conn);   
	}        
        
        return toReturn;
    }
}
