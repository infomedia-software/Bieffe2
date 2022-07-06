
package gestioneDB;

import beans.Planning;
import beans.PlanningCella;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneMonitor {
    
    private static GestioneMonitor istanza;
    
    public static GestioneMonitor getIstanza(){
        if(istanza==null){
            istanza=new GestioneMonitor();
        }
        return istanza;
    }

    /****
     * 
     * @param data
     * @return 
     */
    public  Planning monitor(String data){
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        
        Planning planning=null;
        
        try{
            String datasuccessiva=Utility.dataFutura(data, 1);
            String query="SELECT * FROM monitor "                    
                    + "WHERE monitor.inizio>="+Utility.isNull(data+" 00:00:00")+" AND "
                    + "monitor.fine<="+Utility.isNull(datasuccessiva+" 00:00:00")+" ORDER BY monitor.inizio ASC";        
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            planning=new Planning();
            if(rs.isBeforeFirst()){          // Planning già presente                
                
                while(rs.next()){
                    
                    PlanningCella pc=new PlanningCella();
                    
                    String risorsa=rs.getString("monitor.risorsa");
                    String valore=rs.getString("monitor.valore");
                    String inizio=rs.getString("monitor.inizio");
                    String fine=rs.getString("monitor.fine");
                    
                    pc.setId(rs.getString("monitor.id"));
                    pc.setRisorsa(risorsa);
                    pc.setValore(valore);
                    pc.setInizio(inizio);
                    pc.setFine(fine);
                    
                    
                    planning.aggiungiPlanningCella(risorsa, pc);                    
                }  
                
            }
                        
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneMonitor", "monitor", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneMonitor", "monitor", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }
        return planning;
    }
    
    
    /**
     * Metodo che restituisce le date memorizzate nel monitor
     * @return 
     */
    public  ArrayList<String> date_monitor(){       
	ArrayList<String> toReturn=new ArrayList<String>();
	Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
	String query="SELECT DISTINCT(DATE(inizio)) as data FROM monitor ORDER BY inizio ASC";        
	try{
		System.out.println(query);
		conn=DBConnection.getConnection();            
		stmt=conn.prepareStatement(query);
		rs=stmt.executeQuery(query);
		
		while(rs.next()){   
		   toReturn.add(rs.getString("data"));
		}                   
		
	 } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneAttributi", "date_monitor", ex);
	} catch (SQLException ex) {
            GestioneErrori.errore("GestioneAttributi", "date_monitor", ex);
	} finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                         
	return toReturn;
    }
    
    public  String aggiorna_monitor(ArrayList<String> date){
        String toReturn="";
        
        return toReturn;
    }
    
}
