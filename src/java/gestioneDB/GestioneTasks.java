package gestioneDB;

import beans.Attivita;
import beans.Commessa;
import beans.PlanningCella;
import beans.Risorsa;
import beans.Soggetto;
import beans.Task;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneTasks {
    
    private static GestioneTasks istanza;
    
    public static GestioneTasks getIstanza(){
        if(istanza==null)
            istanza=new GestioneTasks();
        return istanza;
    }
    
    /**
     * 
     * @return 
     */
    public  String nuovo_task(){
        String toReturn=Utility.getIstanza().query_insert("INSERT INTO tasks(stato) VALUES('1')");
        return toReturn;
    }
    
    
    public  String nuovo_task(String id,String soggetto,String commessa,String attivita,String inizio,String risorsa,String note,String stato){
        String toReturn="";
        Utility.getIstanza().query("INSERT INTO tasks(id,soggetto,commessa,attivita,inizio,risorsa,note,stato) VALUES"
                + "");
        return toReturn;
    }
        
    
    /**
     * Metodo che restituisce un task
     * @param id_task -> task dell'id in input
     * @return 
     */
    public  Task getTask(String id_task){
        Task toReturn=null;
        ArrayList<Task> temp=ricerca(" tasks.id="+id_task);
        if(temp.size()==1)
            toReturn=temp.get(0);
        return toReturn;    
    }
    
     /**
     * 
     * @param q
     * @return 
     */
    public  static ArrayList<Task> ricerca_wo_task200(String q){
        ArrayList<Task> toReturn=new ArrayList<Task>();       
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query=" SELECT * FROM wo_task200 WHERE "+q;            
            conn=DBConnection_External_DB.getConnection();            
            if(conn!=null){
                stmt=conn.prepareStatement(query);
                rs=stmt.executeQuery(query);

                while(rs.next()){
                    Task t=new Task();
                    t.setId(rs.getString("tk_id"));
                    Risorsa r=new Risorsa();                        
                        r.setFasi_input(rs.getString("tk_code"));
                    t.setRisorsa(r);
                    t.setNote(rs.getString("tk_rqrd_quantity"));
                    t.setDurata(rs.getInt("tk_rqrd_duration"));
                    t.setStato(rs.getString("tk_status"));
                    toReturn.add(t);
                }
            }
            } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca_wo_task200", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca_wo_task200s", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection_External_DB.releaseConnection(conn);   
        }                   
        return toReturn;
    }
    
    
    /**
     * 
     * @param q
     * @return 
     */
    public  static ArrayList<Task> ricerca(String q){
        ArrayList<Task> toReturn=new ArrayList<Task>();       
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query=" SELECT * FROM tm_task_view WHERE "+q;
            //System.out.println(query);
            conn=DBConnection_External_DB.getConnection();            
            if(conn!=null){
                stmt=conn.prepareStatement(query);
                rs=stmt.executeQuery(query);

                while(rs.next()){
                    Task t=new Task();
                    t.setId(rs.getString("tm_task_id"));
                    Risorsa r=new Risorsa();                        
                        r.setFasi_input(rs.getString("tm_activity"));
                        r.setFasi_produzione(rs.getString("tm_res_code"));
                    t.setRisorsa(r);
                    t.setNote(rs.getString("tm_op_code"));
                    t.setInizio(rs.getString("tm_start"));
                    t.setFine(rs.getString("tm_end"));
                    toReturn.add(t);
                }
            }
            } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection_External_DB.releaseConnection(conn);   
        }                   
        return toReturn;
    }
    
    
    /**
     *  Metodo che verifica la corrispondenza tra l'inizio di un'attività e l'inizio del corrispondente task
     */
    public  String verifica_inizio_attivita_task(Attivita attivita){
        String toReturn="";
         
        // Task
        String inizio_task_data=attivita.getInizio_tasks();
        int inizio_task_ora=attivita.inizio_task_ora();
        int inizio_task_minuti=attivita.inizio_task_minuti();
        
        // Attività
        String inizio_attivita_data=attivita.getInizioData();
        int inizio_attivita_ora=attivita.getInizioOra();
        int inizio_attivita_minuti=attivita.getInizioMinuti();
    
        /*
        System.out.println(""
             + "task:"+attivita.getInizio_tasks()+"\n"
             + "  data:"+inizio_task_data+"\n"
             + "  ora:"+inizio_task_ora+"\n"
             + "  min:"+inizio_task_minuti+"\n"
             + "attività:"+attivita.getInizio()+"\n"
             + "  data:"+attivita.getInizioData()+"\n"
             + "  ora:"+attivita.getInizioOra()+"\n"
             + "  min:"+attivita.getInizioMinuti()+"\n");
        */
        
        if(!inizio_task_data.equals(inizio_attivita_data)){
            toReturn="errore date diverse";
        }else{        
            if(inizio_task_ora!=inizio_attivita_ora){
                toReturn="errore orari diversi";
            }else{
                if(inizio_attivita_minuti==0){
                    if(inizio_task_minuti>30)
                        toReturn="errore minuti successivi";
                }
                if(inizio_attivita_minuti==30){
                    if(inizio_task_minuti<30)
                        toReturn="errore minuti precedenti";
                }
            }
            
        }
        if(!toReturn.equals("")){
            String inizio=inizio_task_data+" "+inizio_task_ora+" ";            
            if(inizio_task_minuti<30)
                inizio=inizio_task_data+" "+inizio_task_ora+":00";
            else
                inizio=inizio_task_data+" "+inizio_task_ora+":30";            
            toReturn=Utility.getIstanza().getValoreByCampo("planning", "id", ""
                    + "planning.inizio>="+Utility.isNull(inizio)+" AND planning.risorsa="+Utility.isNull(attivita.getRisorsa().getId())+"  ORDER BY inizio ASC LIMIT 0,1");            
        }       
        
        
        
        return toReturn;
        
    }
    
    
    /**
     * Metodo che verifica se il task inizia quando inizia l'attività corrispondente
     * @param task
     * @return 
     *      id della cella in cui va posizionata l'attività
     */
    public  String verifica_inizio_task_attivita(Task task){
        
      
        
        String toReturn="";
        // Task
        String inizio_task_data=task.inizio_data();
        int inizio_task_ora=task.inizio_ora();
        int inizio_task_minuti=task.inizio_minuti();
        
        // Attività
        String inizio_attivita_data=task.getAttivita().getInizioData();
        int inizio_attivita_ora=task.getAttivita().getInizioOra();
        int inizio_attivita_minuti=task.getAttivita().getInizioMinuti();
        
        
        /*
        System.out.println(""
                + "task:"+task.getInizio()+"\n"
                + "  data:"+task.inizio_data()+"\n"
                + "  ora:"+task.inizio_ora()+"\n"
                + "  min:"+task.inizio_minuti()+"\n"
                + "attività:"+task.getAttivita().getInizio()+"\n"
                + "  data:"+task.getAttivita().getInizioData()+"\n"
                + "  ora:"+task.getAttivita().getInizioOra()+"\n"
                + "  min:"+task.getAttivita().getInizioMinuti()+"\n");
        */
        if(!inizio_task_data.equals(inizio_attivita_data)){
            toReturn="errore date diverse";
        }else{        
            if(inizio_task_ora!=inizio_attivita_ora){
                toReturn="errore orari diversi";
            }else{
                if(inizio_attivita_minuti==0){
                    if(inizio_task_minuti>30)
                        toReturn="errore minuti successivi";
                }
                if(inizio_attivita_minuti==30){
                    if(inizio_task_minuti<30)
                        toReturn="errore minuti precedenti";
                }
            }
            
        }
        //System.out.println("Errore:"+ toReturn);
        if(!toReturn.equals("")){
            String inizio=inizio_task_data+" "+inizio_task_ora+" ";            
            if(inizio_task_minuti<30)
                inizio=inizio_task_data+" "+inizio_task_ora+":00";
            else
                inizio=inizio_task_data+" "+inizio_task_ora+":30";            
            toReturn=Utility.getIstanza().getValoreByCampo("planning", "id", ""
                    + "planning.inizio>="+Utility.isNull(inizio)+" AND planning.risorsa="+Utility.isNull(task.getAttivita().getRisorsa().getId())+" AND valore!='-1' ORDER BY inizio ASC LIMIT 0,1");            
        }
        
        //System.out.println("Cella:"+ toReturn);
        return toReturn;
    }
    
    /**
     * 
     * @param tm_task_id
     * @return 
     */
    public  ArrayList<Task> sottotasks(String tm_task_id){
        
        ArrayList<Task> toReturn=new ArrayList<Task>();    
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String q=" SELECT * FROM tm_task_view WHERE tm_task_id="+Utility.isNull(tm_task_id)+" ORDER BY tm_start ASC";
            //System.out.println(q);
            conn=DBConnection_External_DB.getConnection();            
            if(conn!=null){
                stmt=conn.prepareStatement(q);
                rs=stmt.executeQuery(q);

                while(rs.next()){
                    Task t=new Task();
                    t.setInizio(rs.getString("tm_start"));                    
                    t.setFine(rs.getString("tm_end"));
                    t.setNote(rs.getString("tm_res_code"));
                        Attivita a=new Attivita();
                            a.setDurata_tasks(rs.getDouble("tm_duration"));;
                        t.setAttivita(a);                    
                    toReturn.add(t);
                }
            }
            } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneTasks", "ricerca", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection_External_DB.releaseConnection(conn);   
        }                    
        return toReturn;
    }
 
    
}
