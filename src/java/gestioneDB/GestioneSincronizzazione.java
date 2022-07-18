package gestioneDB;

import beans.Attivita;
import beans.Commessa;
import beans.Fase;
import beans.Fase_Input;
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
import server.ws.WsServer;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneSincronizzazione {

    private static GestioneSincronizzazione istanza;
            
    public static GestioneSincronizzazione getIstanza(){
        if(istanza==null)
            istanza=new GestioneSincronizzazione();
        return istanza;
    }
    
    
    /***
     * Metodo per sincronizzare le attività di una commessa
     * @param id_commessa
     * @return 
     */
    public synchronized String sincronizza_attivita(String id_commessa){
        //System.out.println(" *** SINCRONIZZA ATTIVITA' COMMESSA "+id_commessa+" *** ");
        String toReturn="";

        int numero_attivita=0;
        
        Connection conn=null;
        Statement stmt=null;
        ResultSet rs=null;

        Map<String,Fase_Input> fasi_input=GestioneFasi_Input.getIstanza().mappa("");
        
        String numero_commessa=Utility.getIstanza().getValoreByCampo("commesse", "numero", "id="+Utility.isNull(id_commessa));
        
        try{
            conn=DBConnection_External_DB.getConnection();   
            stmt=conn.createStatement();
            String query_attivita="SELECT * FROM DistBase "
                    + "WHERE commPrev="+Utility.isNull(numero_commessa)+" AND "
                    + "OreTot>0 AND "
                    + "TipoDoc='C' ";         
            //System.out.println(query_attivita);
            rs=stmt.executeQuery(query_attivita);            
            String queryinsertattivita="INSERT IGNORE INTO attivita(fase_input,commessa,inizio,fine,descrizione,ore,minuti,situazione,seq_input)"
                    + "VALUES";
            boolean almeno1attivita=false;
            while(rs.next()){         
                
                    String descrizione=rs.getString("descrizione");
                    //System.out.println(descrizione+">>>"+descrizione);
                    String situazione="";
                    double seq_double=0;                   

                    double oreTot=rs.getDouble("oreTot");

                    int ore=(int)oreTot;
                    double minuti_temp=oreTot-ore;

                    int minuti=0;
                    if(minuti_temp>0.55){
                        minuti=0;
                        ore++;
                    }else{
                        minuti=30;
                    }

                    String fase_input_string=rs.getString("FaseArt");                     
                    
                    
                    Fase_Input fase_input=fasi_input.get(fase_input_string.toUpperCase());

                    String attivita_gia_sincronizzata=Utility.getIstanza().getValoreByCampo("attivita", "id", ""
                            + "commessa="+Utility.isNull(id_commessa)+" AND fase_input="+Utility.isNull(fase_input.getId())+" AND ore="+ore+" AND minuti="+minuti+" AND stato='1'");
                    //System.out.println("attivita_gia_sincronizzata>>>"+attivita_gia_sincronizzata+"<<<");
                    //System.out.println("fase_input>>>"+fase_input+"<<<");
                    if(fase_input!=null && attivita_gia_sincronizzata.equals("")){

                        Fase fase=fase_input.getFase();
                        if(!fase.getId().equals("")){
                            queryinsertattivita=queryinsertattivita
                                +"("+                                                
                                    Utility.isNull(fase_input.getId())+","+
                                    Utility.isNull(id_commessa)+","+
                                    Utility.isNull("3001-01-01 00:00:00")+","+
                                    Utility.isNull("3001-01-01 00:00:00")+","+
                                    Utility.isNull(descrizione)+","+
                                    Utility.isNull(ore)+","+
                                    Utility.isNull(minuti)+","+
                                    Utility.isNull(situazione)+","+
                                    Utility.isNull(seq_double)+                                            
                                "),";
                            almeno1attivita=true;
                            numero_attivita++;
                        }
                        else{                                
                        }
                    }
                }                   
                if(almeno1attivita==true){
                    queryinsertattivita=queryinsertattivita.substring(0,queryinsertattivita.length()-1);
                    ////System.out.println(queryinsertattivita);
                    Utility.getIstanza().query(queryinsertattivita);
                    
                    
                }else{
                    ////System.out.println("Nessuna attività trovata da inserire");
                    
                }
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_commesse", ex);
        } finally {            
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);               
                DBConnection_External_DB.releaseConnection(conn);           
        }   
        
            
        return numero_attivita+"";
    }
    
    
    /**
     * 
     * @param condizione
     * @return 
     */
    public synchronized String sincronizza_commesse(String numero_commessa){
        
        //System.out.println("\n *** SINCRONIZZA COMMESSE BIEFFE >>> "+Utility.dataOraCorrente_String()+" <<< ***");
        
        int numero_commesse_sincronizzate=0;
        String toReturn="";
        
        Connection conn=null;
        Statement stmt=null;
        ResultSet rs=null;

        
        ArrayList<Commessa> commesse=new ArrayList<Commessa>();
        
        try{
            conn=DBConnection_External_DB.getConnection();            
            stmt=conn.createStatement();
            
            String commessa_da_importare="";
            
            if(numero_commessa.equals("")){
            
                
                // Approvazione TIPO 1
                String query="SELECT dbo.Commesse.codice,dbo.Commesse.dataComm,dbo.Commesse.lavoro,dbo.Commesse.descr,dbo.Commesse.codcli,Data3,dbo.Ore.centro,"
                        + "dbo.Commesse.noteout,dbo.Commesse.qta FROM dbo.Commesse "
                    + "LEFT OUTER JOIN dbo.Ore ON dbo.Commesse.codice=dbo.Ore.commessa "
                    + "WHERE dbo.Ore.centro='LAV.APPROV.' AND cen='1010' AND Data3 is NULL ORDER BY dataComm asc";           
                //System.out.println(query);
                rs=stmt.executeQuery(query);
                while(rs.next()){             
                    Commessa c=new Commessa();                    
                        String numero=rs.getString("codice");
                        c.setNumero(numero);

                        commessa_da_importare=commessa_da_importare+numero+",";

                        String lavoro=rs.getString("lavoro");
                        lavoro=lavoro.substring(1); // Tolgo il primo carattere poichè è un #,@ etc 
                            c.setDescrizione(lavoro);
                        c.setNote(rs.getString("descr"));
                        c.setData(rs.getString("dataComm"));
                        c.setDettagli(rs.getString("noteout"));
                        c.setQta(rs.getDouble("qta"));
                        Soggetto cliente=new Soggetto();
                            cliente.setId(rs.getString("codcli"));
                            c.setSoggetto(cliente);                    
                    commesse.add(c);                                                
                }

                //System.out.println("commessa da importare >>> "+commessa_da_importare+" <<<");

                //System.out.println("Commessa da importare >>> "+commesse.size()+" <<<");


                // Approvazione TIPO 2
                query="SELECT dbo.Commesse.codice,dbo.Commesse.dataComm,dbo.Commesse.lavoro,dbo.Commesse.descr,dbo.Commesse.codcli,Data3,CodiceFase,dbo.Commesse.noteout,dbo.Commesse.qta "
                        + "FROM dbo.Commesse "
                        + "LEFT OUTER JOIN dbo.Altro ON dbo.Commesse.codice=dbo.Altro.rifCommessa "
                        + "WHERE dbo.Altro.CodiceFase='00143' AND Data3 IS NULL ORDER BY dataComm DESC";           
                //System.out.println(query);
                rs=stmt.executeQuery(query);
                while(rs.next()){                             
                        String numero=rs.getString("codice");                    
                        if(!commessa_da_importare.contains(","+numero+",") && !commessa_da_importare.startsWith(numero+",")){
                            Commessa c=new Commessa();                  
                                c.setNumero(numero);
                                String lavoro=rs.getString("lavoro");
                                lavoro=lavoro.substring(1); // Tolgo il primo carattere poichè è un #,@ etc 
                                    c.setDescrizione(lavoro);
                                c.setNote(rs.getString("descr"));
                                c.setData(rs.getString("dataComm"));                                                    
                                c.setDettagli(rs.getString("noteout"));
                                c.setQta(rs.getDouble("qta"));
                                Soggetto cliente=new Soggetto();
                                    cliente.setId(rs.getString("codcli"));
                                    c.setSoggetto(cliente);                    
                            commesse.add(c);     
                        }
                }
                
                //System.out.println("Commessa da importare 2 >>> "+commesse.size()+" <<<");
                
            }else{
                
                // Sincronizzazione singola commessa
                
                String query="select top 1 * from dbo.Commesse "
                    + "where codice LIKE "+Utility.isNullLike(numero_commessa)+" ";
                //System.out.println(">"+query+"<");
                rs=stmt.executeQuery(query);
                while(rs.next()){             
                    Commessa c=new Commessa();                    
                        String numero=rs.getString("codice");
                        c.setNumero(numero);

                        commessa_da_importare=commessa_da_importare+numero+",";

                        String lavoro=rs.getString("lavoro");
                        lavoro=lavoro.substring(1); // Tolgo il primo carattere poichè è un #,@ etc 
                            c.setDescrizione(lavoro);
                        c.setNote(rs.getString("descr"));
                        c.setData(rs.getString("dataComm"));                    
                        c.setDettagli(rs.getString("noteout"));
                        c.setQta(rs.getDouble("qta"));
                        Soggetto cliente=new Soggetto();
                            cliente.setId(rs.getString("codcli"));
                            c.setSoggetto(cliente);                    
                    commesse.add(c);                                                
                }
                
                
                
            }
            
            
        double qta_attivita=0;
        double ore_attivita=0;

        //System.out.println("commesse da importare => "+commesse.size()+"<");
        
        if(commesse.size()>0){
            
            Map<String,Fase_Input> fasi_input=GestioneFasi_Input.getIstanza().mappa("");
            
            for(Commessa commessa:commesse){
                
                boolean sincronizza_commessa=false;                
                
                String id_commessa=Utility.getIstanza().getValoreByCampo("commesse", "id", "numero="+Utility.isNull(commessa.getNumero())+" and stato='1' ");
                
                //System.out.println("          commessa "+commessa.getNumero()+" già importata >"+id_commessa+"<");
                
                if(id_commessa.equals(""))
                {
                    sincronizza_commessa=true;
                }
                else
                {                    
                    String commessa_gia_programmata=Utility.getIstanza().getValoreByCampo("attivita", "id", "  "
                            + "commessa="+Utility.isNull(id_commessa)+" AND "
                            + "situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
                            + "stato='1'");
                    
                    //System.out.println(commessa_gia_programmata);
                    
                    Utility.getIstanza().query("UPDATE commesse SET "
                            + "descrizione="+Utility.isNull(commessa.getDescrizione())+","
                            + "note="+Utility.isNull(commessa.getNote())+","
                            + "dettagli="+Utility.isNull(commessa.getDettagli())+""
                        + " WHERE id="+id_commessa);

                    if(!commessa_gia_programmata.equals("")){
                        sincronizza_commessa=false;
                    }else{
                        sincronizza_commessa=true;
                      
                        
                        /*
                        double ore_attivita_old=Utility.getIstanza().querySelectDouble("SELECT ore_attivita FROM commesse WHERE id="+id_commessa, "ore_attivita");
                        double qta_attivita_old=Utility.getIstanza().querySelectDouble("SELECT qta_attivita FROM commesse WHERE id="+id_commessa, "qta_attivita");
                        
                        String query_attivita="SELECT "
                                + "sum(qta) as qta_attivita,"
                                + "sum(OreTot) as ore_attivita FROM DistBase "
                                + "WHERE commPrev="+Utility.isNull(commessa.getNumero())+" AND OreTot>0 AND TipoDoc='C' ";
                        rs=stmt.executeQuery(query_attivita);    
                       
                        while(rs.next()){
                            qta_attivita=Utility.arrotondaDouble(rs.getDouble("qta_attivita"), 4);
                            ore_attivita=Utility.arrotondaDouble(rs.getDouble("ore_attivita"), 4);
                        }   
                        
                        if(ore_attivita_old!=ore_attivita || qta_attivita_old!=qta_attivita){
                            sincronizza_commessa=true;
                            //System.out.println(" \nCommessa "+commessa.getNumero()+" da aggiornare!\n");
                            Utility.getIstanza().query("DELETE FROM commesse WHERE id="+id_commessa);
                            Utility.getIstanza().query("DELETE FROM attivita WHERE commessa="+Utility.isNull(id_commessa)+" ");
                            id_commessa="";               
                            
                        }
                        */
                }
                                    
                }
                //System.out.println("sincronizza_commessa "+commessa.getNumero()+" >>> "+sincronizza_commessa);
                    
                if(sincronizza_commessa){
                                        
                    String id_commessa_creata=id_commessa;
                    if(id_commessa.equals("")){
                        String colore=Utility.randomColor();
                        String queryinsertcommesse="INSERT IGNORE INTO commesse(numero,descrizione,note,soggetto,colore,data,qta_attivita,ore_attivita,dettagli,qta,stato) VALUES("+
                                Utility.isNull(commessa.getNumero())+","+
                                Utility.isNull(commessa.getDescrizione())+","+
                                Utility.isNull(commessa.getNote())+","+
                                Utility.isNull(commessa.getSoggetto().getId())+","+
                                Utility.isNull(colore)+","+
                                Utility.isNull(commessa.getData())+","+
                                Utility.isNull(qta_attivita)+","+
                                Utility.isNull(ore_attivita)+","+
                                Utility.isNull(commessa.getDettagli())+","+
                                commessa.getQta()+","+
                                Utility.isNull("1")
                            +")";            
                        id_commessa_creata=Utility.getIstanza().query_insert(queryinsertcommesse);
                    }
                    
                    commessa.setId(id_commessa_creata);
                    
                    
                    String query_attivita="SELECT * FROM DistBase "
                            + "WHERE commPrev="+Utility.isNull(commessa.getNumero())+" AND "
                            + "OreTot>0 AND "
                            + "TipoDoc='C' ";              
                    rs=stmt.executeQuery(query_attivita);    
                    
                    
                    
                    String queryinsertattivita="INSERT IGNORE INTO attivita(fase_input,commessa,inizio,fine,descrizione,ore,minuti,situazione,seq_input)"
                            + "VALUES";
                    boolean almeno1attivita=false;
                    while(rs.next()){                                             
                            String descrizione=rs.getString("descrizione");
                            String situazione="";
                            double seq_double=0;                   

                            double oreTot=rs.getDouble("oreTot");

                            int ore=(int)oreTot;
                            double minuti_temp=oreTot-ore;

                            int minuti=0;
                            if(minuti_temp>0.55){
                                minuti=0;
                                ore++;
                            }else{
                                minuti=30;
                            }

                            String fase_input_string=rs.getString("FaseArt");                            
                            ////System.out.println(fase_input_string);
                            Fase_Input fase_input=fasi_input.get(fase_input_string.toUpperCase());
                            
                            if(fase_input!=null){

                                Fase fase=fase_input.getFase();
                                if(!fase.getId().equals("")){
                                    queryinsertattivita=queryinsertattivita
                                        +"("+                                                
                                            Utility.isNull(fase_input.getId())+","+
                                            Utility.isNull(commessa.getId())+","+
                                            Utility.isNull("3001-01-01 00:00:00")+","+
                                            Utility.isNull("3001-01-01 00:00:00")+","+
                                            Utility.isNull(descrizione)+","+
                                            Utility.isNull(ore)+","+
                                            Utility.isNull(minuti)+","+
                                            Utility.isNull(situazione)+","+
                                            Utility.isNull(seq_double)+                                            
                                        "),";
                                    almeno1attivita=true;

                                }
                                else{                                
                                }
                            }
                        }                   
                        if(almeno1attivita==true){
                            queryinsertattivita=queryinsertattivita.substring(0,queryinsertattivita.length()-1);
                            ////System.out.println(queryinsertattivita);
                            Utility.getIstanza().query(queryinsertattivita);
                            numero_commesse_sincronizzate++;
                        }else{
                            //System.out.println("Nessuna attività trovata da inserire");
                            Utility.getIstanza().query("UPDATE commesse SET situazione='conclusa' WHERE id="+commessa.getId());                                
                        }
                    }
               
            }
            
        }
         
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_commesse", ex);
        } finally {            
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);               
                DBConnection_External_DB.releaseConnection(conn);           
        }   
        if(toReturn.equals(""))
            toReturn="Sono state sincronizzate: "+numero_commesse_sincronizzate+" commesse";
        return toReturn;
    }
    
    
    
    
    /**
     * Metodo per sincronizzare e leggere le ACT di Optimus
     * @return 
     */
    public synchronized String sincronizza_fasi_input(){
        String toReturn="";
        
        ArrayList<Fase_Input> lista=new ArrayList<Fase_Input>();
        try{
            Connection conn=DBConnection_External_DB.getConnection();
            String query="SELECT * FROM Fasi ";
            //System.out.println(query);
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){      
               Fase_Input act=new Fase_Input();
               act.setCodice(rs.getString("codice"));
               act.setNome(rs.getString("descrizione"));

               lista.add(act);
            }                       
            rs.close();
            stmt.close();
            DBConnection_External_DB.releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_fasi_input", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_fasi_input", ex);
        }
        
        String query="INSERT INTO fasi_input(codice,nome) VALUES";
        for(Fase_Input act:lista){
            query=query+"("+                
                Utility.isNull(act.getCodice())+","+
                Utility.isNull(act.getNome())+"),";
        }
        if(query.length()>0){
            query=query.substring(0,query.length()-1);                 
            Utility.getIstanza().query(query);
        }
        
        
        return toReturn;
    }
    

    /**
     * Metodo per la sincronizzazione dei clienti
     * @param condizione
     * @return 
     */
    public synchronized String sincronizza_clienti(String condizione){
        //System.out.println("sincronizza_clienti "+condizione);
        String toReturn="";
        Connection conn=null;
        Statement stmt=null;
        ResultSet rs=null;
        
        try{            
            String query="SELECT * FROM clienti ";        
            if(!condizione.equals("")){
               query=query+" WHERE " +condizione; 
            }
            
            
            conn=DBConnection_External_DB.getConnection();            
            stmt = conn.createStatement();            
            rs=stmt.executeQuery(query);
            
            ArrayList<Soggetto> clienti=new ArrayList<Soggetto>();
            
            while(rs.next()){                       
                Soggetto cliente=new Soggetto();
                cliente.setCodice(rs.getString("codice"));
                cliente.setAlias(rs.getString("descrizione"));
                clienti.add(cliente);                    
            }                   
            
            String queryinsert="INSERT IGNORE INTO soggetti(id,codice,alias,tipologia,stato) VALUES";
            for(Soggetto cliente:clienti){
                queryinsert=queryinsert+
                        "("+
                            Utility.isNull(cliente.getCodice())+","+
                            Utility.isNull(cliente.getCodice())+","+
                            Utility.isNull(cliente.getAlias())+","+
                            Utility.isNull("C")+","+
                            Utility.isNull("1")
                        +"),";
            }            
            if(queryinsert.length()>0){
                queryinsert=queryinsert.substring(0,queryinsert.length()-1);                
                Thread.sleep(1000);                
                Utility.getIstanza().query(queryinsert);                
            }                            
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_clienti", ex);
        } catch (InterruptedException ex) {
              GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_clienti", ex);
        } finally {            
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);               
                DBConnection_External_DB.releaseConnection(conn);           
        }   
        return toReturn;
    }

 
    
    /**
     * Metodo per sincronizzare le commesse concluse
     * @return 
     */
    public synchronized String sincronizza_commesse_concluse(){
        //System.out.println("*** Sincronizza commessa concluse ***");
        String toReturn="";
                                   
        Connection conn=null;
        Statement stmt=null;
        ResultSet rs=null;

        try{
            conn=DBConnection_External_DB.getConnection();            
            stmt=conn.createStatement();
            String query="commesse.stato='1' AND commesse.situazione='incorso'";;
            ArrayList<Commessa> commesse=GestioneCommesse.getIstanza().ricerca(query);

            for(Commessa commessa:commesse){
                String numero=commessa.getNumero();
                 
                query="select Commesse.lavoro,Commesse.descr,Commesse.dataComm,Commesse.codcli,Commesse.codice,Commesse.Data3  from dbo.Commesse "
                    + "where Commesse.codice='"+numero+"'";                
                rs=stmt.executeQuery(query);                
                boolean commessa_in_corso=false;
                while(rs.next()){      
                     commessa_in_corso=true;
                     
                 }
                if(commessa_in_corso==false){
                    //System.out.println("   "+commessa.getNumero());
                    Utility.getIstanza().query("UPDATE commesse SET situazione='conclusa' WHERE id="+commessa.getId());
                }
                
            }
            
            
            // Elimina le commesse importate prive di attività
            // Utility.getIstanza().query("UPDATE commesse LEFT JOIN attivita ON commesse.id=attivita.commessa SET commesse.stato='-1' WHERE attivita.id IS NULL");
            
        }catch (SQLException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_commesse_concluse", ex);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneSincronizzazione", "sincronizza_commesse_concluse", ex);
        } finally {            
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);               
                DBConnection_External_DB.releaseConnection(conn);           
        }   

        return toReturn;
    }
  
    
}
