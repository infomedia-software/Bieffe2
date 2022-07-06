package gestioneDB;

import beans.Attivita;
import beans.Commessa;
import beans.Fase;
import beans.Fase_Input;
import beans.OrdineFornitore;
import beans.Planning;
import beans.PlanningCella;
import beans.Precedenza;
import beans.Risorsa;
import beans.Soggetto;
import beans.Task;
import connection.ConnectionPoolException;
import java.net.Socket;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import server.ws.WsServer;
import utility.GestioneErrori;
import utility.Utility;


public class GestionePlanning {
    private static GestionePlanning istanza;
    
    
    public static GestionePlanning getIstanza(){
        if(istanza==null)
            istanza=new GestionePlanning();
        return istanza;
    }
    
    
    public boolean is_data_in_planning(String data_da_controllare){
        boolean toReturn=true;
        String prima_data_planning=GestionePlanning.getIstanza().prima_data_planning();
        if(Utility.confrontaDate(data_da_controllare, prima_data_planning)<0)
            toReturn=false;
        return toReturn;
    }
    
    public String ultima_data_planning(){
        String toReturn=Utility.getIstanza().querySelect("SELECT MAX(DATE(inizio)) as valore FROM planning WHERE 1", "valore");
        return toReturn;
    }
    public String prima_data_planning(){
        String toReturn=Utility.getIstanza().querySelect("SELECT MIN(DATE(inizio)) as valore FROM planning WHERE 1", "valore");
        return toReturn;
    }
    
    public String get_id_cella(String id_risorsa,String inizio){                
        String toReturn=Utility.getIstanza().getValoreByCampo("planning", "id", " risorsa="+Utility.isNull(id_risorsa)+" AND substr(inizio,1,16)=substr("+Utility.isNull(inizio)+",1,16)");
        return toReturn;
    }
    
    /**
     * Carica il planning considerando la tabella > planning_old
     * @param data
     * @return 
     */
    public  Planning get_old_Planning(String data){
        
        Planning planning=new Planning();
        String datasuccessiva=Utility.dataFutura(data, 1);
        
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
         try{
            String query="SELECT * FROM planning_old "                    
                    + "WHERE planning_old.inizio>="+Utility.isNull(data+" 00:00:00")+" AND "
                    + "planning_old.fine<="+Utility.isNull(datasuccessiva+" 00:00:00")+" ORDER BY planning_old.inizio ASC";                     
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            if(rs.isBeforeFirst()){                      
                while(rs.next()){
                    
                    PlanningCella pc=new PlanningCella();
                    
                    String risorsa=rs.getString("planning_old.risorsa");
                    String valore=rs.getString("planning_old.valore");
                    String inizio=rs.getString("planning_old.inizio");
                    String fine=rs.getString("planning_old.fine");
                    
                    pc.setId(rs.getString("planning_old.id"));
                    pc.setRisorsa(risorsa);
                    pc.setValore(valore);
                    pc.setInizio(inizio);
                    pc.setFine(fine);                    
                    pc.setNote(rs.getString("planning_old.note"));
                    planning.aggiungiPlanningCella(risorsa, pc);                    
                }  
                
            }
            
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "get_old_Planning", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "get_old_Planning", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return planning;
    }
    
    
    /******************************************************************************************
     * 
     *              Metodo per il caricamento del Planning
     * 
     ******************************************************************************************/ 
    public  Planning getPlanning(String data){
       
 
        Planning planning=null;
        
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        
        try{
            
            String datasuccessiva=Utility.dataFutura(data, 1);
                   
            String query="SELECT * FROM planning "                    
                    + "WHERE planning.inizio>="+Utility.isNull(data+" 00:00:00")+" AND "
                    + "planning.fine<="+Utility.isNull(datasuccessiva+" 00:00:00")+" ORDER BY planning.inizio ASC";                     
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            Map<String,PlanningCella> celle=new HashMap<String,PlanningCella>();
            
            planning=new Planning();
            if(rs.isBeforeFirst()){          // Planning già presente                
                
                while(rs.next()){
                    
                    PlanningCella pc=new PlanningCella();
                    
                    String risorsa=rs.getString("planning.risorsa");
                    String valore=rs.getString("planning.valore");
                    String inizio=rs.getString("planning.inizio");
                    String fine=rs.getString("planning.fine");
                    
                    pc.setId(rs.getString("planning.id"));
                    pc.setRisorsa(risorsa);
                    pc.setValore(valore);
                    
                    pc.setInizio(inizio);                    
                    pc.setFine(fine);
                    pc.setNote(rs.getString("planning.note"));
                    
                    //planning.aggiungiPlanningCella(risorsa, pc);                    
                    
                    String chiave=risorsa+"_"+inizio;                    
                    celle.put(chiave, pc);
                }  
                
            }
            
            
            ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse("");
            
            ArrayList<String> orari=Utility.lista_data_ore(data);
            
            for(Risorsa risorsa:risorse){
                
                String id_risorsa=risorsa.getId();
                
                for(String orario:orari){
                   String chiave=id_risorsa+"_"+orario;
                
                   PlanningCella cella=celle.get(chiave);
                   if(cella!=null){
                       planning.aggiungiPlanningCella(id_risorsa, cella);                    
                   }else{
                       cella=new PlanningCella();
                       cella.setId(chiave);
                       cella.setRisorsa(id_risorsa);
                       cella.setInizio(orario);
                       String fine=Utility.aggiungiOre(orario, 0,30);
                       cella.setFine(fine);
                       cella.setValore("-1");
                       cella.setNote("");
                       planning.aggiungiPlanningCella(id_risorsa, cella);
                   }
               }
            }
                       
    
                        
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "getPlanning", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "getPlanning", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return planning;
    }
    
    
    
    /***
     * 
     * @param id_risorsa
     * @param ora_inizio
     * @param ora_fine
     * @return 
     */
    public  String aggiungi_risorsa_planning(String id_risorsa,String ora_inizio,String ora_fine){
        
        String data_inizio=Utility.dataOdiernaFormatoDB();
        String data_fine=Utility.eliminaNull(Utility.getIstanza().querySelect("SELECT DATE(MAX(inizio)) as ultima FROM planning WHERE 1","ultima"));
        if(data_fine.equals("")){
            data_fine=data_inizio;
        }else{
            data_fine=Utility.dataFutura(data_fine, 1);
        }
         
        String qq="INSERT INTO planning(risorsa,inizio,fine,valore) VALUES";
         
        String[] inizio_temp=ora_inizio.split(":");
        String[] fine_temp=ora_fine.split(":");
        
        int inizio_ora=Utility.convertiStringaInInt(inizio_temp[0]);        
        int fine_ora=Utility.convertiStringaInInt(fine_temp[0]);
        
        int minimo=inizio_ora*2;
        if(inizio_temp[1].equals("30"))
            minimo=minimo+1;
        int massimo=fine_ora*2;
        if(fine_temp[1].equals("30"))
            massimo=massimo+1;
        
        String data=data_inizio;
        
        data=data_inizio; 
        
        int ora=0;
        while(!data.equals(data_fine)){
                        
            int giornodellasettimana=Utility.giornodellasettimana(data);
            
            String planning_esistente=Utility.getIstanza().getValoreByCampo("planning", "id", ""
                    + "inizio>="+Utility.isNull(data+" 00:00:00")+" AND "
                    + "fine<="+Utility.isNull(data+" 23:30:00")+" AND "
                    + "risorsa="+id_risorsa);
            
            if(planning_esistente.equals("")){
                //System.out.println("Creo planning per risorsa "+id_risorsa+" in data "+data);
                for(int i=0;i<48;i++){
                    ora=i/2;
                    String valore="1";
                    if(i<minimo || i>=massimo || giornodellasettimana==1 || giornodellasettimana==7 )
                        valore="-1";

                    String inizio=data+" "+ora+":00";
                    String fine=data+" "+ora+":30";
                    if(i%2==1){
                        inizio=data+" "+ora+":30";                   
                        if(i==47)
                            fine=Utility.dataFutura(data, 1)+" "+(0)+":00";
                        else
                            fine=data+" "+(ora+1)+":00";
                        }                
                        qq=qq+"("+Utility.isNull(id_risorsa)+","
                            + Utility.isNull(inizio)+","
                            + Utility.isNull(fine)+","
                            + Utility.isNull(valore)+"),";
                    }
                }
            else{
                //System.out.println("planning GIA' PRESENTE per risorsa "+id_risorsa+" in data "+data);
            }
            data=Utility.dataFutura(data, 1);        
        }
            
         
        if(qq.endsWith(",")){
            qq=qq.substring(0,qq.length()-1);
            Utility.getIstanza().query(qq);
        }
        return "";
    }
    
    
    
    
    /*********************************************************************************
     * 
     *      Metodo per la creazione del planning
     * 
     * @param data
     * @return 
     *********************************************************************************/
    public  void creaPlanning(String data){                
        Utility.getIstanza().query("CALL creaPlanning("+Utility.isNull(data)+")");                
        Utility.getIstanza().query("INSERT INTO calendario(data,situazione,stato) VALUES("+Utility.isNull(data)+",'abilitato','1')");
    }
    
    
    

    
    /****
     * Riprogramma le risorse a partire dall'orario in input (considera solo le risorse successive ad ordinamento )          
     * @return 
     * @param idrisorsa -> id della risorsa da cui iniziare a fare la riprogrammazione
     * @param dataorainizio
     * @return 
     */
    public  String riprogrammaRisorse(String idrisorsa,String dataorainizio_input){
  
        String ordinamento="0";
        if(!idrisorsa.equals("")){
            ordinamento=Utility.getIstanza().getValoreByCampo("risorse", "ordinamento", "id="+idrisorsa);            
        }
        
        //System.out.println("reparto da considerare => "+reparto);
        String dataorainizio="";
        if(!dataorainizio_input.equals(""))
            dataorainizio=dataorainizio_input;
        ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.stato='1'  AND risorse.planning='si' AND risorse.ordinamento>="+Utility.isNull(ordinamento)+" ORDER BY risorse.ordinamento ASC");
                
        PreparedStatement stmt=null;
	ResultSet rs=null;
        
        Connection conn=null;
        try {                    
            conn=DBConnection.getConnection();
            for(Risorsa risorsa:risorse){
                
                WsServer.sendAll("aggiorna_loader:"+risorsa.getNome());                
                
                //System.out.println("aggiorna_loader:"+risorsa.getNome());
                
                String query="CALL `riprogrammaRisorsa`('', "+Utility.isNull(risorsa.getId()) +")";                                        
                if(risorsa.getId().equals(idrisorsa))                    
                  query="CALL `riprogrammaRisorsa`("+Utility.isNull(dataorainizio) +", "+Utility.isNull(risorsa.getId()) +")";                                        
                DBUtility.executeOperation(conn, query);
                
            }            
	} catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "riprogrammaRisorse", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "riprogrammaRisorse", ex);
	} finally {
		DBUtility.closeQuietly(rs);
		DBUtility.closeQuietly(stmt);
		DBConnection.releaseConnection(conn);   
	}     
            
        WsServer.sendAll("aggiorna_planning");
        
        return "";
       
    }    
    
    public  String nuovaattivita(String idcella,String commessa,String fase,String cdl,String descrizione,String ore,String minuti,String bloccata,String note){
        String toReturn="";
        
        Connection conn=null;
        Statement stmt=null;
        ResultSet keys=null;
            
        PlanningCella pc=ricercaPlanningCelle(" planning.id="+idcella+" LIMIT 0,1").get(0);

        String risorsa=pc.getRisorsa();
        String inizio=pc.getInizio();        
        
        int ore_int=Utility.convertiStringaInInt(ore);
        int minuti_int=Utility.convertiStringaInInt(minuti);
        
        String fine=Utility.aggiungiOre(pc.getInizio(), ore_int,minuti_int);
        
        try {
            String query_insertattivita="INSERT INTO attivita(commessa,fase,risorsa,cdl,descrizione,inizio,fine,ore,minuti,bloccata,note) VALUES("
                    + Utility.isNull(commessa)+","
                    + Utility.isNull(fase)+","
                    + Utility.isNull(risorsa)+","
                    + Utility.isNull(cdl)+","
                    + Utility.isNull(descrizione)+","
                    + Utility.isNull(inizio)+","
                    + Utility.isNull(fine)+","
                    + ore+","
                    + minuti+","
                    + Utility.isNull(bloccata)+","
                    + Utility.isNull(note)+")";
            //System.out.println(query_insertattivita);
            conn=DBConnection.getConnection();
            stmt = conn.createStatement();
            stmt.executeUpdate(query_insertattivita, Statement.RETURN_GENERATED_KEYS);
            keys = stmt.getGeneratedKeys();
            keys.next();
            String idattivitacreata = ""+keys.getInt(1); 
            
            //toReturn=modificaPlanning(idattivitacreata, idcella);
            
            if(toReturn.toLowerCase().contains("errore"))                                   // Verifica se l'attività creata va ad inficiare su attività bloccate
                Utility.getIstanza().query("DELETE FROM attivita WHERE id="+idattivitacreata);
                             
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "nuovaattivita", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "nuovaattivita", ex);
        }finally{
            DBUtility.closeQuietly(keys);
            DBUtility.closeQuietly(stmt);            
            DBConnection.releaseConnection(conn);                        
        }
   
        return toReturn;
    }
    
    /**
     * 
     * @param q
     * @return 
     */
    public  ArrayList<PlanningCella> ricercaPlanningCelle(String q){
        ArrayList<PlanningCella> toReturn=new ArrayList<PlanningCella>();
        
        
        
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
             String query="SELECT * FROM "
                    + "planning LEFT OUTER JOIN attivita ON planning.valore=attivita.id "
                    + "WHERE "+q;       
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);

            while(rs.next()){
                PlanningCella pc=new PlanningCella();
                    
                String risorsa=rs.getString("planning.risorsa");
                String valore=rs.getString("planning.valore");
                String inizio=rs.getString("planning.inizio");
                String fine=rs.getString("planning.fine");

                pc.setId(rs.getString("planning.id"));
                pc.setRisorsa(risorsa);
                pc.setValore(valore);
                pc.setInizio(inizio);
                pc.setFine(fine);
                pc.setNote(rs.getString("planning.note"));

                toReturn.add(pc);
            }            
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaPlanningCelle", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaPlanningCelle", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }  
        
        return toReturn;
    }
    
    
    public Attivita get_attivita(String id_attivita){
        Attivita toReturn=null;
        ArrayList<Attivita> temp=ricercaAttivita(" attivita.id="+id_attivita);
        if(temp.size()==1){
            toReturn=temp.get(0);
        }
        return toReturn;
    }
    
    
    
    public Attivita ricerca_attivita(String q){
        Attivita toReturn=null;
        ArrayList<Attivita> temp=ricercaAttivita(q);
        if(temp.size()==1){
            toReturn=temp.get(0);
        }
        return toReturn;
    }
    
    /**
     * 
     * @param q
     * @return 
     */
    public  ArrayList<Attivita> ricercaAttivita(String q){
        ArrayList<Attivita> toReturn=new ArrayList<Attivita>();
         
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
                
        Map<String,Risorsa> risorse=GestioneRisorse.getIstanza().mappaRisorse(" risorse.stato='1' ");
        
        try{
             String query=""
                     + "SELECT *,"
                        + "fasi.id,fasi.ordinamento,"
                        + "fornitori.id,fornitori.alias,"
                        + "ordini_fornitore.id,ordini_fornitore.situazione,ordini_fornitore.numero,ordini_fornitore.anno "
                     + "FROM attivita "
                        + " LEFT OUTER JOIN commesse ON attivita.commessa=commesse.id "
                        + " LEFT OUTER JOIN fasi_input ON attivita.fase_input=fasi_input.id "
                        + " LEFT OUTER JOIN fasi ON fasi_input.fase=fasi.id "
                        + " LEFT OUTER JOIN soggetti as clienti ON commesse.soggetto=clienti.id "
                        + " LEFT OUTER JOIN soggetti as fornitori ON attivita.fornitore_preventivo=fornitori.id "
                        + " LEFT OUTER JOIN ordini_fornitore ON attivita.attesa_fornitore=ordini_fornitore.id "
                    + " WHERE "+q;       
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);

            while(rs.next()){
                Attivita attivita=new Attivita(); 
                attivita.setId(rs.getString("attivita.id"));
                attivita.setCarta(rs.getString("attivita.carta"));
                
                // Commessa
                String commessa_string=Utility.eliminaNull(rs.getString("attivita.commessa"));
                Commessa commessa=new Commessa();
                if(commessa_string.equals("")){
                    commessa.setId(""); 
                    commessa.setNumero("");
                    commessa.setDescrizione("");
                    commessa.setColore("");
                    commessa.setData_consegna("");
                    commessa.setDettagli("");
                    commessa.setNote("");
                    commessa.setQta(0);
                    Soggetto cliente=new Soggetto();
                        cliente.setId("");
                        cliente.setAlias("");
                        cliente.setNome("");
                        cliente.setCodice("");
                        commessa.setSoggetto(cliente);
                }else{
                    commessa.setId(Utility.eliminaNull(rs.getString("commesse.id")));
                    commessa.setNumero(Utility.eliminaNull(rs.getString("commesse.numero")));
                    commessa.setDescrizione(Utility.eliminaNull(rs.getString("commesse.descrizione")));
                    commessa.setColore(Utility.eliminaNull(rs.getString("commesse.colore")));
                    commessa.setData_consegna(rs.getString("commesse.data_consegna"));
                    commessa.setDettagli(rs.getString("commesse.dettagli"));
                    commessa.setNote(rs.getString("commesse.note"));
                    commessa.setQta(rs.getDouble("commesse.qta"));
                    Soggetto cliente=new Soggetto();
                        cliente.setId(rs.getString("clienti.id"));
                        cliente.setAlias(rs.getString("clienti.alias"));
                        cliente.setNome(rs.getString("clienti.nome"));
                        cliente.setCodice(rs.getString("clienti.codice"));
                        commessa.setSoggetto(cliente);
                }
                attivita.setCommessa(commessa);
                    

                // Risorsa
                String risorsa_string=Utility.eliminaNull(rs.getString("attivita.risorsa"));
                Risorsa risorsa=new Risorsa();                
                if(risorsa_string.equals("") || risorse.get(risorsa_string)==null){
                    risorsa.setId("");
                    risorsa.setCodice("");             
                    risorsa.setNome("");                    
                    risorsa.setOrdinamento("0");                    
                    risorsa.setFasi_produzione("");
                }else{
                    risorsa.setId(risorse.get(risorsa_string).getId());
                    risorsa.setCodice(risorse.get(risorsa_string).getCodice());   
                    risorsa.setNome(risorse.get(risorsa_string).getNome());                   
                    risorsa.setOrdinamento(risorse.get(risorsa_string).getOrdinamento());                   
                    risorsa.setFasi_produzione(risorse.get(risorsa_string).getFasi_produzione());
                }
                attivita.setRisorsa(risorsa);
                
                attivita.setInizio(rs.getString("attivita.inizio"));
                attivita.setFine(rs.getString("attivita.fine"));
                attivita.setDescrizione(rs.getString("attivita.descrizione"));
                attivita.setOre(rs.getInt("attivita.ore"));
                attivita.setMinuti(rs.getInt("attivita.minuti"));
                attivita.setBloccata(rs.getString("attivita.bloccata"));
                String note=Utility.eliminaNull(rs.getString("attivita.note"));
                
                attivita.setNote(note);
                attivita.setSituazione(rs.getString("attivita.situazione"));
                attivita.setErrore(rs.getString("attivita.errore"));
                
                
                // Fase Input
                String fase_input_string=rs.getString("fase_input");
                Fase_Input fase_input=new Fase_Input();
                if(!fase_input_string.equals("")){
                    fase_input.setId(rs.getString("fasi_input.id"));
                    fase_input.setCodice(rs.getString("fasi_input.codice"));
                    fase_input.setCategoria(rs.getString("fasi_input.categoria"));
                    fase_input.setNome(rs.getString("fasi_input.nome"));               
                    fase_input.setEsterna(rs.getString("fasi_input.esterna"));               
                    fase_input.setStampa(rs.getString("fasi_input.stampa"));  
                    fase_input.setAllestimento(rs.getString("fasi_input.allestimento"));  
                }else{
                    fase_input.setId("");
                    fase_input.setCodice("");
                    fase_input.setCategoria("");
                    fase_input.setNome("");
                    fase_input.setEsterna("");               
                    fase_input.setStampa("");  
                    fase_input.setAllestimento("");  
                }                                                
                    String fase_string=Utility.eliminaNull(rs.getString("fasi.id"));
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
                    fase_input.setFase(fase);
                attivita.setFase_input(fase_input);
                
                attivita.setCompletata(rs.getString("attivita.completata"));
                attivita.setAttiva(rs.getString("attivita.attiva"));
                attivita.setAttiva_infogest(rs.getString("attivita.attiva_infogest"));
                attivita.setRitardo(rs.getDouble("attivita.ritardo"));
                attivita.setScostamento(rs.getDouble("attivita.scostamento"));
                
                attivita.setSeq(rs.getDouble("attivita.seq"));
                attivita.setSeq_input(rs.getDouble("attivita.seq_input"));
                
                
                // Durata ed inizio dei task collegati all'attività
                attivita.setDurata_tasks(rs.getDouble("attivita.durata_tasks"));
                attivita.setInizio_tasks(rs.getString("attivita.inizio_tasks"));
                
                attivita.setLibero1(rs.getString("libero1"));
                attivita.setLibero2(rs.getString("libero2"));
                attivita.setLibero3(rs.getString("libero3"));
                attivita.setLibero4(rs.getString("libero4"));
                attivita.setLibero5(rs.getString("libero5"));
                attivita.setLibero6(rs.getString("libero6"));
                attivita.setLibero7(rs.getString("libero7"));
                
                attivita.setTask(rs.getString("attivita.task"));
                
                attivita.setId_ordine_fornitore(rs.getString("attivita.id_ordine_fornitore"));;
                attivita.setDescrizione_ordine_fornitore(rs.getString("attivita.descrizione_ordine_fornitore"));;
                attivita.setNote_ordine_fornitore(rs.getString("attivita.note_ordine_fornitore"));;
                attivita.setSpecifiche_tecniche(rs.getString("attivita.specifiche_tecniche"));;
                attivita.setComposizione(rs.getString("attivita.composizione"));
                
                String attesa_fornitore=Utility.eliminaNull(rs.getString("attivita.attesa_fornitore"));
                attivita.setAttesa_fornitore(attesa_fornitore);
                OrdineFornitore ordine_fornitore=new OrdineFornitore();
                if(!attesa_fornitore.equals("")){
                    ordine_fornitore.setId(rs.getString("ordini_fornitore.id"));
                    ordine_fornitore.setNumero(rs.getString("ordini_fornitore.numero"));
                    ordine_fornitore.setAnno(rs.getString("ordini_fornitore.anno"));
                    ordine_fornitore.setSituazione(rs.getString("ordini_fornitore.situazione"));
                    ordine_fornitore.setData_consegna(rs.getString("ordini_fornitore.data_consegna"));
                }else{
                    ordine_fornitore.setId("");
                    ordine_fornitore.setNumero("");
                    ordine_fornitore.setAnno("");
                    ordine_fornitore.setSituazione("");
                    ordine_fornitore.setData_consegna("");
                }
                attivita.setOrdine_fornitore(ordine_fornitore);
                
                attivita.setQta_ordine_fornitore(rs.getDouble("attivita.qta_ordine_fornitore"));
                attivita.setPrezzo_ordine_fornitore(rs.getDouble("attivita.prezzo_ordine_fornitore"));
                
                String fornitore_preventivo=rs.getString("fornitore_preventivo");
                Soggetto fornitore=new Soggetto();
                if(fornitore_preventivo.equals("")){
                    fornitore.setId("");
                    fornitore.setAlias("");
                }else{
                    fornitore.setId(rs.getString("fornitori.id"));
                    fornitore.setAlias(rs.getString("fornitori.alias"));
                }
                attivita.setFornitore_preventivo(fornitore);
                attivita.setDescrizione_ordine_fornitore(rs.getString("attivita.descrizione_ordine_fornitore"));;
                
                attivita.setStato(rs.getString("attivita.stato"));
                
                toReturn.add(attivita);
            }            
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaAttivita", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaAttivita", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }       
        return toReturn;
    }
   
    
    /***
     * Metodo che ritorna una mappa in cui la chiave è la risorsa e il valore è l'ArrayList di attività
     * @param q
     *      data
     * @return 
     *      mappa in cui la chiave è la risorsa e il valore è l'ArrayList di attività
     */
    public  Map<String,ArrayList<Attivita>> mappa_attivita(String q){
        Map<String,ArrayList<Attivita>> toReturn=new HashMap<String,ArrayList<Attivita>>();
         
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
                
        Map<String,Risorsa> risorse=GestioneRisorse.getIstanza().mappaRisorse(" risorse.stato='1' ");
        
        try{
             String query=""
                     + "SELECT *,"
                        + "fasi.id,fasi.ordinamento,"
                        + "soggetti.id,soggetti.alias,soggetti.codice,soggetti.nome "
                     + "FROM attivita "
                    + " LEFT OUTER JOIN commesse ON attivita.commessa=commesse.id "
                    + " LEFT OUTER JOIN soggetti ON commesse.soggetto=soggetti.id "
                    + " LEFT OUTER JOIN fasi_input ON attivita.fase_input=fasi_input.id "
                    + " LEFT OUTER JOIN fasi ON fasi_input.fase=fasi.id "
                    + " LEFT OUTER JOIN ordini_fornitore ON attivita.attesa_fornitore=ordini_fornitore.id "
                    + " WHERE "+q;       
            
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);

            while(rs.next()){
                Attivita attivita=new Attivita(); 
                attivita.setId(rs.getString("attivita.id"));
                
                
                // Commessa
                String commessa_string=Utility.eliminaNull(rs.getString("attivita.commessa"));
                Commessa commessa=new Commessa();
                if(commessa_string.equals("")){
                    commessa.setId(""); 
                    commessa.setNumero("");
                    commessa.setDescrizione("");
                    commessa.setColore("");
                    commessa.setDettagli("");
                    commessa.setNote("");
                    commessa.setQta(0);
                    Soggetto cliente=new Soggetto();
                        cliente.setId("");
                        cliente.setAlias("");
                        cliente.setNome("");
                        cliente.setCodice("");
                        commessa.setSoggetto(cliente);
                        
                }else{
                    commessa.setId(Utility.eliminaNull(rs.getString("commesse.id")));
                    commessa.setNumero(Utility.eliminaNull(rs.getString("commesse.numero")));
                    commessa.setDescrizione(Utility.eliminaNull(rs.getString("commesse.descrizione")));
                    commessa.setColore(Utility.eliminaNull(rs.getString("commesse.colore")));
                    commessa.setDettagli(Utility.eliminaNull(rs.getString("commesse.dettagli")));
                    commessa.setNote(Utility.eliminaNull(rs.getString("commesse.note")));
                    commessa.setData_consegna(Utility.eliminaNull(rs.getString("commesse.data_consegna")));
                    commessa.setQta(rs.getDouble("commesse.qta"));
                    Soggetto cliente=new Soggetto();
                        cliente.setId(rs.getString("soggetti.id"));
                        cliente.setAlias(rs.getString("soggetti.alias"));
                        cliente.setNome(rs.getString("soggetti.nome"));
                        cliente.setCodice(rs.getString("soggetti.codice"));
                        commessa.setSoggetto(cliente);
                }
                attivita.setCommessa(commessa);
                    

                // Risorsa
                String risorsa_string=Utility.eliminaNull(rs.getString("attivita.risorsa"));
                Risorsa risorsa=new Risorsa();                
                if(risorsa_string.equals("") || risorse.get(risorsa_string)==null){
                    risorsa.setId("");
                    risorsa.setCodice("");             
                    risorsa.setNome("");                    
                    risorsa.setOrdinamento("0");                    
                }else{
                    risorsa.setId(risorse.get(risorsa_string).getId());
                    risorsa.setCodice(risorse.get(risorsa_string).getCodice());   
                    risorsa.setNome(risorse.get(risorsa_string).getNome());                   
                    risorsa.setOrdinamento(risorse.get(risorsa_string).getOrdinamento());                   
                }
                attivita.setRisorsa(risorsa);
                
                attivita.setInizio(rs.getString("attivita.inizio"));
                attivita.setFine(rs.getString("attivita.fine"));
                attivita.setDescrizione(rs.getString("attivita.descrizione"));
                attivita.setOre(rs.getInt("attivita.ore"));
                attivita.setMinuti(rs.getInt("attivita.minuti"));
                attivita.setBloccata(rs.getString("attivita.bloccata"));
                attivita.setNote(Utility.eliminaNull(rs.getString("attivita.note")));
                attivita.setSituazione(rs.getString("attivita.situazione"));
                attivita.setErrore(rs.getString("attivita.errore"));
                
                  // Fase Input
                String fase_input_string=rs.getString("fase_input");
                Fase_Input fase_input=new Fase_Input();
                if(!fase_input_string.equals("")){
                    fase_input.setId(rs.getString("fasi_input.id"));
                    fase_input.setCodice(rs.getString("fasi_input.codice"));
                    fase_input.setNome(rs.getString("fasi_input.nome"));               
                }else{
                    fase_input.setId("");
                    fase_input.setCodice("");
                    fase_input.setNome("");
                    
                }                                                
                    String fase_string=rs.getString("fasi.id");
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
                    fase_input.setFase(fase);
                attivita.setFase_input(fase_input);
                
                attivita.setCompletata(rs.getString("attivita.completata"));
                attivita.setAttiva(rs.getString("attivita.attiva"));
                attivita.setAttiva_infogest(rs.getString("attivita.attiva_infogest"));
                attivita.setRitardo(rs.getDouble("attivita.ritardo"));
                attivita.setScostamento(rs.getDouble("attivita.scostamento"));
                
                attivita.setSeq(rs.getDouble("attivita.seq"));
                attivita.setSeq_input(rs.getDouble("attivita.seq_input"));
                
                attivita.setLibero1(rs.getString("libero1"));
                attivita.setLibero2(rs.getString("libero2"));
                attivita.setLibero3(rs.getString("libero3"));
                attivita.setLibero4(rs.getString("libero4"));
                attivita.setLibero5(rs.getString("libero5"));
                attivita.setLibero6(rs.getString("libero6"));
                attivita.setLibero7(rs.getString("libero7"));
                
                String attesa_fornitore=Utility.eliminaNull(rs.getString("attivita.attesa_fornitore"));
                attivita.setAttesa_fornitore(attesa_fornitore);
                OrdineFornitore ordine_fornitore=new OrdineFornitore();
                if(!attesa_fornitore.equals("")){
                    ordine_fornitore.setId(rs.getString("ordini_fornitore.id"));
                    ordine_fornitore.setNumero(rs.getString("ordini_fornitore.numero"));
                    ordine_fornitore.setAnno(rs.getString("ordini_fornitore.anno"));
                    ordine_fornitore.setSituazione(rs.getString("ordini_fornitore.situazione"));
                    ordine_fornitore.setData_consegna(rs.getString("ordini_fornitore.data_consegna"));
                }else{
                    ordine_fornitore.setId("");
                    ordine_fornitore.setNumero("");
                    ordine_fornitore.setAnno("");
                    ordine_fornitore.setSituazione("");
                    ordine_fornitore.setData_consegna("");
                }
                attivita.setOrdine_fornitore(ordine_fornitore);
                
                
                // Durata ed inizio dei task collegati all'attività
                attivita.setDurata_tasks(rs.getDouble("attivita.durata_tasks"));
                attivita.setInizio_tasks(rs.getString("attivita.inizio_tasks"));
                
                // Aggiunge alla mappa l'attività                
                String id_risorsa=attivita.getRisorsa().getId();
                if(toReturn.get(id_risorsa)==null){
                    toReturn.put(id_risorsa, new ArrayList<Attivita>());
                }
                
                attivita.setTask(rs.getString("attivita.task"));
                
                toReturn.get(id_risorsa).add(attivita);
                                
            }            
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "mappa_attivita", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "mappa_attivita", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }       
        return toReturn;
    }
   
    
    
    /**
     * Metodo per modificare la durata di un'attività
     * @param idattivita
     * @param newvalore
     * @return 
     */
    public  String modificaDurataAttivita(String idattivita,String newvalore){
        String toReturn="";
        String ore="";
        String minuti="";
        
        Attivita attivita=ricercaAttivita(" attivita.id="+idattivita).get(0);
        
        if(newvalore.contains(".")){
            String[] durata=newvalore.split("\\.");
            ore=durata[0];
            minuti=durata[1];
            if(minuti.equals("5") || minuti.equals("50"))
                minuti="30";
        }else{
            ore=newvalore;
            minuti="0";
        }
        String q="UPDATE attivita "
                + " SET ore="+Utility.isNull(ore)+",minuti="+Utility.isNull(minuti)+" "
                + " WHERE id="+idattivita;
        Utility.getIstanza().query(q);   
                
        
        //toReturn=GestionePlanning.getIstanza().riprogrammaPlanning(attivita, null)Planning(idattivita, attivita.getRisorsa().getId(), attivita.getInizio());
        
        if(toReturn.toLowerCase().contains("errore")){
                String qq="UPDATE attivita "
                + " SET "
                + "ore="+Utility.isNull(attivita.getOre())+","
                + "minuti="+Utility.isNull(attivita.getMinuti())+" "
                + " WHERE id="+idattivita;
                Utility.getIstanza().query(qq);   
        }
        
        return toReturn;
    }
    
    
    
    /*******************************************************************
     * 
     * 
     * GESTIONE DELLE PRECEDENZE
     * 
     * 
     ***************************************************************************************************/
    
    
    /**
     * Aggiorna le attività che rispettano la precedenza
     * imposta il campo attivita.errore=PRECEDENZAKO
     * @param q
     * @return 
     */
    public  String verificaPrecedenze(String q){
        String toReturn="";
        
        String query2="UPDATE attivita"
            + " SET errore = "+Utility.isNull("")+""
            + " WHERE stato='1'";
        Utility.getIstanza().query(query2);
        
        
        String query="UPDATE attivita"
            + " SET errore = "+Utility.isNull("PRECEDENZAKO")+""
            + " WHERE id IN "
                + " (SELECT AAA.attivita_id"
                + " FROM("
                + " select "
                + " a1.id as attivita_id,"
                + " a1.descrizione as attivita_descrizione,"
                + " a1.inizio as attivita_inizio,"
                + " a1.fine as attivita_fine,"
                + " a2.id as precedente_id,"
                + " a2.descrizione as precedente_descrizione,"
                + " a2.inizio as precedente_inizio,"
                + " a2.fine as precedente_fine,"
                + " p.scostamento as scostamento,"
                + " (a2.fine + INTERVAL p.scostamento*60 MINUTE) as daconsiderare"
                + " FROM precedenze as p"
                + " INNER JOIN attivita as a1 ON p.attivita=a1.id"
                + " INNER JOIN attivita as a2 ON p.precedente=a2.id"
                + " AND a1.inizio<(a2.fine + INTERVAL p.scostamento*60 MINUTE)) AS AAA"
            + ");";
        Utility.getIstanza().query(query);
        
        
     
        
        return toReturn;
    }
    
    /**
     * 
     * @param q
     * @return 
     */
    public  ArrayList<Precedenza> ricercaPrecedenti(String q){
         ArrayList<Precedenza> toReturn=new ArrayList<Precedenza>();
         
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
                
        Map<String,Risorsa> risorse=GestioneRisorse.getIstanza().mappaRisorse(" risorse.stato='1' ");
        
        try{
             String query="SELECT * FROM attivita "
                    + " LEFT OUTER JOIN precedenze ON attivita.id=precedenze.precedente"
                    + " WHERE "+q;       
            //System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);

            while(rs.next()){
                
                Precedenza p=new Precedenza();
                
                Attivita precedente=new Attivita(); 
                    precedente.setId(rs.getString("attivita.id"));                
                    String risorsa_string=Utility.eliminaNull(rs.getString("attivita.risorsa"));
                    Risorsa risorsa=new Risorsa();                
                    if(risorsa_string.equals("") || risorse.get(risorsa_string)==null){
                        risorsa.setId("");
                        risorsa.setNome("");                    
                    }else{
                        risorsa.setId(risorse.get(risorsa_string).getId());
                        risorsa.setNome(risorse.get(risorsa_string).getNome());                   
                    }
                    precedente.setRisorsa(risorsa);

                    precedente.setInizio(rs.getString("attivita.inizio"));
                    precedente.setFine(rs.getString("attivita.fine"));
                    precedente.setDescrizione(rs.getString("attivita.descrizione"));
                    precedente.setBloccata(rs.getString("attivita.bloccata"));
                p.setId(rs.getInt("precedenze.id"));
                p.setPrecedente(precedente);
                p.setScostamento(rs.getDouble("precedenze.scostamento"));
                p.setNote(rs.getString("precedenze.note"));
                p.setStato(rs.getString("precedenze.stato"));
                toReturn.add(p);
            }            
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaPrecedenti", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestionePlanning", "ricercaPrecedenti", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }       
        return toReturn;
    }
    
    
    public  PlanningCella trova_cella(String inizio,String fine,String risorsa){
        PlanningCella toReturn=null;
        String query="";
  
        if(inizio.equals("") && fine.equals(""))
            query=" planning.inizio>="+Utility.isNull(Utility.dataOraCorrente_String())+" AND planning.risorsa="+Utility.isNull(risorsa)+" ORDER BY planning.inizio ASC LIMIT 0,1 ";
        else
            query=" planning.inizio<="+Utility.isNull(inizio)+" AND planning.fine>="+Utility.isNull(fine)+" AND planning.risorsa="+Utility.isNull(risorsa)+" ORDER BY planning.inizio ASC LIMIT 0,1 ";
        ArrayList<PlanningCella> lista=ricercaPlanningCelle(query);
        if(lista.size()>0)
            toReturn=lista.get(0);
        return toReturn;
            
    }
    
    public  PlanningCella trova_cella_disponibile(String inizio,String fine,String risorsa){
        PlanningCella toReturn=null;
        String query="";
  
        if(inizio.equals("") && fine.equals(""))
            query=" planning.inizio>="+Utility.isNull(Utility.dataOraCorrente_String())+" AND planning.risorsa="+Utility.isNull(risorsa)+" AND planning.valore!='-1' ORDER BY planning.inizio ASC LIMIT 0,1 ";
        else
            query=" planning.inizio<="+Utility.isNull(inizio)+" AND planning.fine>="+Utility.isNull(fine)+" AND planning.risorsa="+Utility.isNull(risorsa)+" AND planning.valore!='-1' ORDER BY planning.inizio ASC LIMIT 0,1 ";
        ArrayList<PlanningCella> lista=ricercaPlanningCelle(query);
        if(lista.size()>0)
            toReturn=lista.get(0);
        return toReturn;
            
    }
    
    
    public  String aggiorna_planning_old(){
        
        String toReturn="";
               
        
        String oggi=Utility.dataOdiernaFormatoDB()+" 00:00:00";
        String ieri=Utility.dataFutura(Utility.dataOdiernaFormatoDB(), -1);
        
        ArrayList<Attivita> attivita_cavallo=ricercaAttivita(" attivita.inizio<="+Utility.isNull(oggi)+" AND attivita.fine>"+Utility.isNull(oggi) +" ORDER BY attivita.inizio ASC");
        
        String inizio_svuota_planning="";
        if(attivita_cavallo.size()>0){      // Ci sono attività a cavallo -> deve prende inizio attività a cavallo che inizia prima
            inizio_svuota_planning=Utility.dataFutura(attivita_cavallo.get(0).getInizioData(), -1)+" 23:30:30";
            
        }else{
            inizio_svuota_planning=ieri+" 23:30:30";
        }
        
                
        // Copio in planning_old
        // non lo facciamo più perchè abbiamo eliminato planning old
        // Utility.getIstanza().query("INSERT into planning_old SELECT * FROM planning WHERE inizio<="+Utility.isNull(inizio_svuota_planning));
        
        // Svuolta planning
        Utility.getIstanza().query("DELETE FROM planning WHERE inizio<="+Utility.isNull(inizio_svuota_planning));
        
        
        
        return toReturn;
        
    }

    public  Map<String,Attivita> fine_attivita_commessa(String data){
        Map<String,Attivita> toReturn=new HashMap<String,Attivita>();        
        Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	try{
            String query="SELECT commessa,max(attivita.fine) as max_fine,commesse.data_consegna "
                    + "FROM attivita LEFT OUTER JOIN commesse ON commesse.id=attivita.commessa "
                    + "WHERE attivita.situazione='in programmazione' AND attivita.fine!='3001-01-01 00:00:00' AND attivita.stato='1'  "
                    + "GROUP BY attivita.commessa ";                                 
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            while(rs.next()){                    
                String commessa=rs.getString("commessa");
                String fine=rs.getString("max_fine");
                Attivita attivita=new Attivita();
                attivita.setFine(fine);
                toReturn.put(commessa, attivita);
            }  
	} catch (ConnectionPoolException ex) {
	GestioneErrori.errore("GestionePlanning", "fine_attivita_commessa", ex);
	} catch (SQLException ex) {
	GestioneErrori.errore("GestionePlanning", "fine_attivita_commessa", ex);
	} finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);   
	}        
        return toReturn;
    }
    
    public Attivita prima_attivita_risorsa(String id_risorsa,String inizio){
        Attivita attivita=null;
            ArrayList<Attivita> temp=GestionePlanning.getIstanza().ricercaAttivita(" "
                + "attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
                + "( attivita.inizio>="+Utility.isNull(inizio)+" OR (inizio<="+Utility.isNull(inizio)+" AND fine>="+Utility.isNull(inizio)+" ) )"                 
                + "AND attivita.risorsa="+Utility.isNull(id_risorsa)+" AND attivita.stato='1' ORDER BY attivita.inizio ASC ");            
            if(temp.size()>0)
                attivita=temp.get(0);            
        return attivita;
    }
 
    public String inizio_min(String id_attivita){
        String inizio_minimo="";
                
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita).get(0);
        
        String id_risorsa=attivita.getRisorsa().getId();
    
        Attivita attivita_precedente=GestionePlanning.getIstanza().ricerca_attivita(" "
            + "attivita.id!="+id_attivita+" AND "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "(attivita.seq+0.01)="+attivita.getSeq()+" AND attivita.stato='1' "
            + "AND attivita.situazione!='' "
            + "ORDER BY attivita.FINE LIMIT 0,1");              
        if(attivita_precedente!=null){
            
            String attivita_precedente_fine=attivita_precedente.getFine();        
            if(attivita.getScostamento()<0){            
                 attivita_precedente_fine=GestionePlanning.getIstanza().trova_prima_cella(id_risorsa, attivita_precedente.getInizio(), attivita_precedente.getDurata(), attivita.getScostamento());
            }
            if(attivita.getScostamento()>0){            
                attivita_precedente_fine=GestionePlanning.getIstanza().trova_prima_cella(id_risorsa, attivita_precedente_fine, 0, attivita.getScostamento());
            }    
            if(attivita.getScostamento()==0){            
                attivita_precedente_fine=GestionePlanning.getIstanza().trova_prima_cella(id_risorsa, attivita_precedente_fine, 0, 0);
            }
            inizio_minimo=attivita_precedente_fine;
        }
        
        return inizio_minimo;
    }
    
    public String trova_prima_cella(String id_risorsa,String inizio,double durata,double scostamento){
        durata=durata+scostamento;
        if(durata<=0)
            durata=0;
        String toReturn=trova_prima_cella(id_risorsa,inizio,durata);
        return toReturn;
    }
    
    
    public String trova_prima_cella(String id_risorsa,String inizio,double durata){
        String toReturn="";        
        int numero_celle=Math.abs((int)(durata*2));
        
        /*
            System.out.println("*** trova_prima_cella ***");
            System.out.println(" id_risorsa=>"+id_risorsa);
            System.out.println(" inizio=>"+inizio);
            System.out.println(" durata=>"+durata);
            System.out.println(" *** *** ");
        */
        numero_celle=numero_celle+1;
        toReturn=Utility.getIstanza().querySelect(""
                + "SELECT inizio "
                + "FROM planning "
                + "WHERE planning.risorsa="+Utility.isNull(id_risorsa)+" AND planning.inizio>="+Utility.isNull(inizio)+" ORDER BY planning.inizio ASC LIMIT 0,"+numero_celle+"", "inizio");        
        System.out.println(" toReturn=>"+toReturn);
        return toReturn;
    }
    
}
