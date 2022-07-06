package gestioneDB;

import beans.Commessa;
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
import java.util.TreeMap;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneCommesse {
    
    private static GestioneCommesse istanza;
    
    public static GestioneCommesse getIstanza(){
        if(istanza==null)
            istanza=new GestioneCommesse();
        return istanza;
    }

    
    public Commessa get_commessa(String id_commessa){
        Commessa toReturn=null;
        ArrayList<Commessa> temp=ricerca(" commesse.id="+id_commessa);
        if(temp.size()==1)
            toReturn=temp.get(0);
        return toReturn;
    }
    

    /**
     * 
     * @param query_input
     * @return 
     */
    public  ArrayList<Commessa> ricerca(String query_input){
        ArrayList<Commessa> toReturn=new ArrayList<Commessa>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        String query="SELECT * FROM commesse "
                + "LEFT OUTER JOIN soggetti ON commesse.soggetto=soggetti.codice "
                + "WHERE "
                + ""+ query_input;        
        try{
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                
                Commessa c=new Commessa();
                c.setId(rs.getString("commesse.id"));
                c.setNumero(rs.getString("commesse.numero"));
                c.setAnno(rs.getString("commesse.anno"));
                c.setImporto(rs.getDouble("commesse.importo"));
                Soggetto s=new Soggetto();
                String soggetto=rs.getString("commesse.soggetto");
                if(!soggetto.equals("")){                            // Soggetto configurato
                    s.setCodice(Utility.eliminaNull(soggetto));
                    s.setId(Utility.eliminaNull(rs.getString("soggetti.id")));
                    s.setAlias(Utility.eliminaNull(rs.getString("soggetti.alias")));                                      
                }else{                                               // Soggetto non configurato
                    s.setCodice(Utility.eliminaNull(soggetto));
                    s.setId("");
                    s.setAlias("");                                                          
                }
                c.setSoggetto(s);
                c.setDescrizione(rs.getString("commesse.descrizione"));
                c.setData(rs.getString("commesse.data"));
                c.setScadenza(rs.getString("commesse.scadenza"));
                c.setRifofferta(rs.getString("commesse.rifofferta"));
                c.setRifordine(rs.getString("commesse.rifordine"));
                c.setRifordine(rs.getString("commesse.rifordine"));
                c.setImmagine(rs.getString("commesse.immagine"));
                c.setCostoorario(rs.getDouble("commesse.costoorario"));
                c.setNote(rs.getString("commesse.note"));
                c.setSituazione(rs.getString("commesse.situazione"));
                c.setStato(rs.getString("commesse.stato"));
                c.setColore(rs.getString("commesse.colore"));
                
                c.setConsegnata(rs.getString("commesse.consegnata"));
                
                c.setAllestimento(rs.getString("commesse.allestimento"));
                c.setStampa(rs.getString("commesse.stampa"));
                
                c.setDettagli(rs.getString("commesse.dettagli"));
                String data_consegna=Utility.eliminaNull(rs.getString("commesse.data_consegna"));
                if(!data_consegna.equals(""))
                    data_consegna=data_consegna.replace(" ", "T");
                c.setData_consegna(data_consegna);
                
                c.setFsc(rs.getString("commesse.fsc"));
                c.setPefc(rs.getString("commesse.pefc"));
                c.setQta(rs.getDouble("commesse.qta"));
                
                toReturn.add(c);
            }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneCommesse", "ricercaCommessa", ex);
        } finally {            
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);               
                DBConnection.releaseConnection(conn);           
        }                    
        return toReturn;
    }
    
    
    /**
     * 
     * @return 
     */
    public  String nuovaCommessa(){
        String toReturn="";         
        try {            
            Connection conn=DBConnection.getConnection();
            Statement stmt = conn.createStatement();                       
            int numero=prossimoNumeroCommessa();
            String anno=Utility.annoCorrente();
            String data=Utility.dataOdiernaFormatoDB();
            String situazione="incorso";
            String stato="1";
            String query="INSERT INTO commesse(numero,anno,data,situazione,stato) "
                    + "VALUES ("
                    +Utility.isNull(""+numero)+","
                    +Utility.isNull(anno)+","
                    +Utility.isNull(data)+","
                    +Utility.isNull(situazione)+","
                    +Utility.isNull(stato)+")";           
            //System.out.println(query);
            stmt.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
            ResultSet keys = stmt.getGeneratedKeys();    
            keys.next();  
            toReturn = ""+keys.getInt(1);            
            stmt.close();            
            DBConnection.releaseConnection(conn);            
        } catch (SQLException | ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneCommesse", "nuovaCommessa", ex);
        }   
       return toReturn;
    }
    
    public  int prossimoNumeroCommessa(){
        int toReturn=0;
          
	Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	String query="SELECT MAX(CAST(numero AS SIGNED)) as max FROM commesse "
                + "WHERE commesse.anno="+Utility.isNull(Utility.annoCorrente())+" AND commesse.stato='1'";
	try{
		//System.out.println(query);
		conn=DBConnection.getConnection();            
		stmt=conn.prepareStatement(query);
		rs=stmt.executeQuery(query);
		
		while(rs.next()){   
		   toReturn=rs.getInt("max");
		}                 
                toReturn=toReturn+1;
		
	} catch (ConnectionPoolException | SQLException ex) {
		GestioneErrori.errore("GestioneSoggetti", "ricerca", ex);
	} finally {            
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);                                        
            DBConnection.releaseConnection(conn);
            
	}                    
	return toReturn;

    }
    
    public  String verifica_fase_commessa(String commessa,String macrofase){
        String toReturn="";
        Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	try{
		String query=""
                        + "SELECT "
                            + "SUM(IF(completata = 'si', 1, 0)) AS completate, "
                            + "SUM(IF(completata = '', 1, 0)) AS non_completate,"
                            + "SUM(IF(situazione = 'in programmazione', 1, 0)) AS in_programmazione,"
                            + "SUM(IF(situazione = 'da programmare', 1, 0)) AS da_programmare "
                        + "FROM "
                            + "attivita LEFT OUTER JOIN fasi_input "
                        + "ON attivita.fase_input=fasi_input.id "
                        + "WHERE fasi_input."+macrofase+"='si' AND attivita.commessa="+Utility.isNull(commessa)+" AND attivita.situazione!=''";                                 
		conn=DBConnection.getConnection();            
		stmt=conn.prepareStatement(query);
		rs=stmt.executeQuery(query);
                int completate=0;
                int non_completate=0;
                int in_programmazione=0;
                int da_programmare=0;
		while(rs.next()){                    
		    completate=rs.getInt("completate");
                    non_completate=rs.getInt("non_completate");
                    in_programmazione=rs.getInt("in_programmazione");
                    da_programmare=rs.getInt("da_programmare");                    
		}  
                if(da_programmare>0)
                    toReturn="yellow";                
                if(da_programmare>0 && in_programmazione==0)
                    toReturn="red";
                if(da_programmare==0 && in_programmazione>0)
                    toReturn="blue";
                if(completate==in_programmazione && in_programmazione>0 && da_programmare==0)
                    toReturn="green";                
                
                /*
                System.out.println("verifica_fase_commessa =>"+macrofase+"<=\n"
                    + "commessa=>"+commessa+"\n"
                    + "completata=>"+completate+"\n"
                    + "non_completate=>"+non_completate+"\n"
                    + "in programmazione=>"+in_programmazione+"\n"
                    + "da programmare=>"+da_programmare+"\n"
                    + "to_return ===>"+toReturn+"<===\n"
                + "");
                */
	} catch (ConnectionPoolException ex) {
	GestioneErrori.errore("GestioneCommesse", "verifica_fase_commessa", ex);
	} catch (SQLException ex) {
	GestioneErrori.errore("GestioneCommesse", "verifica_fase_commessa", ex);
	} finally {
		DBUtility.closeQuietly(rs);
		DBUtility.closeQuietly(stmt);
		DBConnection.releaseConnection(conn);   
	}        
        return toReturn;
    }
    
}
