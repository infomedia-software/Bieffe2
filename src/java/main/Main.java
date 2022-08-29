package main;

import beans.Attivita;
import beans.Commessa;
import beans.Task;
import connection.ConnectionPoolException;
import gestioneDB.DBConnection;
import gestioneDB.DBConnection_External_DB;
import gestioneDB.DBUtility;
import gestioneDB.GestioneCommesse;
import gestioneDB.GestionePlanning;
import gestioneDB.GestioneSincronizzazione;
import gestioneDB.GestioneTasks;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import utility.GestioneErrori;
import utility.Utility;



public class Main {
    
    public static void main(String[] args){       
        
        //GestioneSincronizzazione.getIstanza().sincronizza_commesse("22A0985P01");
        GestionePlanning.getIstanza().creaPlanning("2022-08-27");
        GestionePlanning.getIstanza().creaPlanning("2022-08-28");
        GestionePlanning.getIstanza().creaPlanning("2022-08-29");
        GestionePlanning.getIstanza().creaPlanning("2022-08-30");
        
        /*
        String id_risorsa="13";
        String inizio="2022-06-15 07:00:00";
        double durata=2.5;
        double scostamento=-1.0;
        String temp=GestionePlanning.getIstanza().trova_prima_cella(id_risorsa, inizio, durata,scostamento);
        System.out.println(">"+temp);
        
        //System.out.print(Utility.viene_prima("2022-04-07 07:30:00.0", "2022-04-07 12:18:49"));
        
        
        
        //GestioneSincronizzazione.getIstanza().sincronizza_commesse("");
        //GestioneSincronizzazione.getIstanza().task_attivi();        
        //String toReturn=GestioneCommesse.getIstanza().verifica_fase_commessa("200662", "stampa");
        //System.out.println(toReturn);
        
        /*
        GestioneSincronizzazione.getIstanza().sincronizza_commesse("200865");
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id=11863").get(0);
        System.out.println(">>>"+attivita.getInizio()+"<<<");
        
        int seq_int=(int)attivita.getSeq();
        ArrayList<Attivita> attivita_precedenti=GestionePlanning.getIstanza().ricercaAttivita(""
                + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getNumero())+" AND attivita.stato='1' AND attivita.seq>="+seq_int+" AND attivita.seq<"+attivita.getSeq()+" AND seq!=0 ORDER BY attivita.seq DESC LIMIT 0,1");
        if(attivita_precedenti.size()>0){            
            Attivita attivita_precedente=attivita_precedenti.get(0);
            String fine_scostamento_temp=Utility.aggiungi_ore_minuti(attivita_precedente.getInizio(), attivita_precedente.getDurata()+attivita.getScostamento());            
            System.out.println("prima cella ===>>>"+fine_scostamento_temp+"<<<===");
            String fine_scostamento=Utility.getIstanza().querySelect("SELECT inizio FROM planning WHERE "
                    + "risorsa="+Utility.isNull(attivita.getRisorsa().getId())+" AND inizio>="+Utility.isNull(fine_scostamento_temp)+" AND valore!='-1' ORDER BY inizio ASC LIMIT 0,1","inizio" );
            System.out.println("prima cella disp===>>>"+fine_scostamento+"<<<===");
        }
        
        //GestioneSincronizzazione.getIstanza().sincronizza_commesse_concluse();
        
        /*
        ArrayList<Commessa> commesse=GestioneCommesse.getIstanza().ricerca(" commesse.stato='1' ORDER BY commesse.numero ASC");
        System.out.println(commesse.size());
        int i=0;
        for(Commessa commessa:commesse){
            String stato_optimus=Utility.getIstanza().getValoreByCampoExternalDB("job200", "j_status", "j_number="+commessa.getId());
            System.out.println(commessa.getId()+">"+stato_optimus);
            if(stato_optimus.equals("C") || stato_optimus.equals("X"))
                Utility.getIstanza().query("UPDATE commesse SET situazione='conclusa' WHERE id="+commessa.getId());
        }
        */
        
    }
    
    /*
    public static synchronized String imposta_programmata_da_programmare(){
        
        ArrayList<Commessa> commesse=GestioneCommesse.getIstanza().ricerca(" commesse.stato='1' ORDER BY commesse.numero ASC");
        for(Commessa commessa:commesse){                
            String id_commessa=commessa.getId();
            
            System.out.println(commessa.getId()+") "+ commessa.getDescrizione()+" => "+commessa.getSituazione()+" <br>");                
            
            String attivita_programmate=Utility.getIstanza().getValoreByCampo("attivita", "id", " "
                + "attivita.commessa="+Utility.isNull(id_commessa) +" AND "
                + "attivita.stato='1' AND "
                + "attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" ");
            String query="";
            if(!attivita_programmate.equals("")){
                query="UPDATE commesse SET situazione='programmata' WHERE id="+Utility.isNull(id_commessa);
                System.out.println(query);                
            }else{
                query="UPDATE commesse SET situazione='daprogrammare' WHERE id="+Utility.isNull(id_commessa);
                System.out.println(query);
            }
            Utility.getIstanza().query(query);
        }
        return "";
    }
    
    
    /***
     * Metodo da utilizzare la prima volta per associare i task alle attività     
     * @return 
     */
    /*
    public static synchronized String associa_task(){
        String prima_data_planning=Utility.getIstanza().querySelect("SELECT DATE(min(inizio)) as prima_data_planning FROM planning WHERE 1 ORDER BY inizio DESC LIMIT 0,1", "prima_data_planning");
                
        ArrayList<Attivita> attivita_senza_task=GestionePlanning.getIstanza().ricercaAttivita(" "
                + "attivita.task='' AND attivita.stato='1' AND attivita.inizio>="+Utility.isNull(prima_data_planning)+" ORDER BY attivita.commessa ASC");
        
        System.out.println(attivita_senza_task.size());
        
        for(Attivita attivita:attivita_senza_task){
            System.out.println(attivita.getCommessa().getNumero()+" "+attivita.getInizio()+" "+attivita.getFase_input().getCodice());
            Task task=GestioneSincronizzazione.getIstanza().trova_task_da_attivita(attivita.getCommessa().getNumero(),attivita.getFase_input().getCodice());
            if(!task.getId().equals("")){
                Utility.getIstanza().query("UPDATE attivita SET task="+Utility.isNull(task.getId())+" WHERE id="+attivita.getId());
            }
        }
        
        
        
        ArrayList<Attivita> lista_attivita=GestionePlanning.getIstanza().ricercaAttivita(" "
            + " DATE(attivita.inizio)>="+Utility.isNull(prima_data_planning)+"  "
            //+ " AND DATE(attivita.inizio)!="+Utility.isNull("3001-01-01")+" AND  DATE(attivita.inizio_tasks)!="+Utility.isNull("3001-01-01")+"    "            
            + "ORDER BY attivita.commessa ASC,attivita.seq ASC");
        System.out.println(lista_attivita.size());
        int numero_task_trovato=0;
        
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        
        attivita_senza_task=new ArrayList<Attivita>();
        
        try{
        
        conn=DBConnection_External_DB.getConnection();            
        
        for(Attivita attivita:lista_attivita){
            
            System.out.println("ID:"+attivita.getId()+"\nCommessa:"+attivita.getCommessa().getNumero()+"\nFase:"+attivita.getFase_input().getCodice());
            
            Task task=GestioneSincronizzazione.getIstanza().trova_task_da_attivita(attivita.getCommessa().getNumero(),attivita.getFase_input().getCodice());
            if(!task.getId().equals("")){
                numero_task_trovato++;
                
                String query_inizio_task=""
                    + "SELECT "
                        + "tm_task_view.tm_start,tm_duration "
                    + "FROM "
                        + "tm_task_view,(SELECT tm_task_id,tm_end,tm_start FROM tm_task_view WHERE tm_task_id!="+Utility.isNull(task.getId())+" ORDER BY tm_end DESC LIMIT 0,1) AS task_precedenti "
                    + "WHERE "
                        + "tm_task_view.tm_task_id="+Utility.isNull(task.getId())+" "
                    + "ORDER BY tm_task_view.tm_start ASC ";
                System.out.println(query_inizio_task);
         
                stmt=conn.prepareStatement(query_inizio_task);
                rs=stmt.executeQuery(query_inizio_task);

                String tm_start="";

                
                int durata_sottotask=0;                        
                while(rs.next()){
                    if(tm_start.equals(""))
                        tm_start=rs.getString("tm_start");
                    durata_sottotask=durata_sottotask+rs.getInt("tm_duration");
                }

                if(tm_start.equals(""))
                    tm_start="3001-01-01 00:00:00";
                task.setInizio(tm_start);

                if(durata_sottotask>0 ){
                    int durata_complessiva=durata_sottotask;
                    task.setDurata(durata_complessiva);                            
                }
                        
                Utility.getIstanza().query("UPDATE attivita SET task="+Utility.isNull(task.getId())+","
                        + "inizio_tasks="+Utility.isNull(task.getInizio())+","
                        + "durata_tasks="+Utility.isNull(task.getDurata())+" WHERE id="+attivita.getId());
           }else{
                attivita_senza_task.add(attivita);
                System.out.println("*** TASK NON TROVATO ***");
            }
            System.out.println("\n");
        }
            } catch (ConnectionPoolException ex) {
                GestioneErrori.errore("GestioneTasks", "task_attivi", ex);
            } catch (SQLException ex) {
                GestioneErrori.errore("GestioneTasks", "task_attivi", ex);
            } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection_External_DB.releaseConnection(conn);   
        }            
        
        System.out.println("*** Attività Senza Task ***");
        for(Attivita attivita:attivita_senza_task){
            System.out.println(attivita.getId()+" "+attivita.getCommessa().getNumero()+" "+attivita.getFase_input().getCodice());
        }
        
        
        System.out.println("Numero Attività: "+lista_attivita.size()+"\nNumero task sincronizzati: "+numero_task_trovato);
        return "";
    }
    */
}
