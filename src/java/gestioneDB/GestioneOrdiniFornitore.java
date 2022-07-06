package gestioneDB;

import beans.Commessa;
import beans.Indirizzo;
import beans.OrdineFornitore;
import beans.Soggetto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;

public class GestioneOrdiniFornitore {

    private static GestioneOrdiniFornitore istanza;
    
    public static GestioneOrdiniFornitore getIstanza(){
        if(istanza==null)
            istanza=new GestioneOrdiniFornitore();
        return istanza;
    }
    
    
    public  OrdineFornitore get(String id_ordine_fornitore){
        OrdineFornitore toReturn=null;
        ArrayList<OrdineFornitore> temp=GestioneOrdiniFornitore.getIstanza().ricerca(" ordini_fornitore.id="+id_ordine_fornitore+"");
        if(temp.size()>0)
            toReturn=temp.get(0);
        return toReturn;
    }
    
    public  ArrayList<OrdineFornitore> ricerca(String query_input){
        ArrayList<OrdineFornitore> toReturn=new ArrayList<OrdineFornitore>();
        Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	try{
            String query="SELECT * FROM ordini_fornitore "
                    + "LEFT OUTER JOIN commesse ON ordini_fornitore.id_commessa=commesse.id "
                    + "LEFT OUTER JOIN soggetti as clienti ON commesse.soggetto=clienti.id "
                    + "LEFT OUTER JOIN soggetti as fornitori ON ordini_fornitore.id_fornitore=fornitori.id "
                    + "WHERE "+query_input;                                 
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            while(rs.next()){                    
                OrdineFornitore temp=new OrdineFornitore();
                    
                    temp.setId(rs.getString("ordini_fornitore.id"));
                    temp.setNumero(rs.getString("ordini_fornitore.numero"));
                    temp.setAnno(rs.getString("ordini_fornitore.anno"));
                    temp.setData_ritiro(rs.getString("ordini_fornitore.data_ritiro"));
                    String commessa_string=rs.getString("ordini_fornitore.id_commessa");
                    Commessa commessa=new Commessa();
                    if(!commessa_string.equals("")){
                        commessa.setId(rs.getString("commesse.id"));
                        commessa.setNumero(rs.getString("commesse.numero"));
                        commessa.setDescrizione(rs.getString("commesse.descrizione"));                        
                        commessa.setFsc(rs.getString("commesse.fsc"));                        
                        String cliente_string=rs.getString("commesse.soggetto");
                        Soggetto cliente=new Soggetto();
                            if(!cliente_string.equals("")){
                                cliente.setAlias(rs.getString("clienti.alias"));
                                cliente.setCodice(rs.getString("clienti.codice"));
                                cliente.setId(rs.getString("clienti.id"));
                                cliente.setRagionesociale(rs.getString("clienti.ragionesociale"));
                            }else{
                                cliente.setAlias("");
                                cliente.setCodice("");
                                cliente.setId("");
                                cliente.setRagionesociale("");
                            }
                        commessa.setSoggetto(cliente);    
                        commessa.setData_consegna(rs.getString("commesse.data_consegna"));
                    }else{
                        commessa.setId("");
                        commessa.setNumero("");
                        commessa.setDescrizione("");                        
                        commessa.setFsc("");                        
                        commessa.setData_consegna("");
                        Soggetto cliente=new Soggetto();
                            cliente.setAlias("");
                            cliente.setAlias("");
                            commessa.setSoggetto(cliente);
                        commessa.setData_consegna(rs.getString(""));
                    }
                    temp.setCommessa(commessa);
                    
                    String fornitore_string =rs.getString("ordini_fornitore.id_fornitore");
                    Soggetto fornitore=new Soggetto();
                    if(!fornitore_string.equals("")){
                        fornitore.setId(rs.getString("fornitori.codice"));
                        fornitore.setRagionesociale(rs.getString("fornitori.ragionesociale"));
                        fornitore.setAlias(rs.getString("fornitori.alias"));
                    }else{
                        fornitore.setId("");
                        fornitore.setRagionesociale("");
                        fornitore.setAlias("");
                    }
                    temp.setFornitore(fornitore);
                    
                    temp.setReferente(rs.getString("ordini_fornitore.referente"));
                    
                    Indirizzo indirizzo0=new Indirizzo();                    
                        indirizzo0.setIndirizzo(rs.getString("ordini_fornitore.indirizzo0"));
                        indirizzo0.setComune(rs.getString("ordini_fornitore.comune0"));
                        indirizzo0.setCap(rs.getString("ordini_fornitore.cap0"));
                        indirizzo0.setProvincia(rs.getString("ordini_fornitore.provincia0"));
                        indirizzo0.setNazione(rs.getString("ordini_fornitore.nazione0"));
                        indirizzo0.setTelefono(rs.getString("ordini_fornitore.telefono0"));
                        indirizzo0.setEmail(rs.getString("ordini_fornitore.email0"));
                    temp.setIndirizzo0(indirizzo0);
                    
                    Indirizzo indirizzo1=new Indirizzo();
                        indirizzo1.setIndirizzo(rs.getString("ordini_fornitore.indirizzo1"));
                        indirizzo1.setComune(rs.getString("ordini_fornitore.comune1"));
                        indirizzo1.setCap(rs.getString("ordini_fornitore.cap1"));
                        indirizzo1.setProvincia(rs.getString("ordini_fornitore.provincia1"));
                        indirizzo1.setNazione(rs.getString("ordini_fornitore.nazione1"));
                        indirizzo1.setTelefono(rs.getString("ordini_fornitore.telefono1"));
                        indirizzo1.setEmail(rs.getString("ordini_fornitore.email1"));
                    temp.setIndirizzo1(indirizzo1);
                    
                    
                    temp.setData_ordine(rs.getString("ordini_fornitore.data_ordine"));
                    temp.setData_ritiro(rs.getString("ordini_fornitore.data_ritiro"));
                    temp.setData_consegna(rs.getString("ordini_fornitore.data_consegna"));
                    temp.setPrezzo(rs.getDouble("ordini_fornitore.prezzo"));
                    temp.setTipologia(rs.getString("ordini_fornitore.tipologia"));
                    temp.setNote(rs.getString("ordini_fornitore.note"));
                    temp.setSituazione(rs.getString("ordini_fornitore.situazione"));
                    temp.setStato(rs.getString("ordini_fornitore.stato"));
                    
                    temp.setDescrizione(rs.getString("ordini_fornitore.descrizione"));
                    temp.setQta(rs.getDouble("ordini_fornitore.qta"));
                    
                    temp.setDdt(rs.getString("ordini_fornitore.ddt"));
                    
                toReturn.add(temp);
            }  

	} catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneOrdiniFornitore", "ricerca", ex);
	} catch (SQLException ex) {
            GestioneErrori.errore("GestioneOrdiniFornitore", "ricerca", ex);
	} finally {
		DBUtility.closeQuietly(rs);
		DBUtility.closeQuietly(stmt);
		DBConnection.releaseConnection(conn);   
	}      
        return toReturn;
    }
    
}
