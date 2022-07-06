package gestioneDB;

import beans.Reparto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;



public class GestioneReparti {

    private static GestioneReparti istanza;
    
    public static GestioneReparti getIstanza(){
        if(istanza==null)
            istanza=new GestioneReparti();
        return istanza;
    }
    
    /**
     * 
     * @param q
     * @return 
     */
    
    public ArrayList<Reparto> ricerca(String q){
        ArrayList<Reparto> toReturn=new ArrayList<Reparto>();
	Connection conn=null;
	PreparedStatement stmt=null;
	ResultSet rs=null;
        if(q.equals(""))
            q=" reparti.stato='1' ORDER BY nome ASC";
	String query="SELECT * FROM reparti WHERE "
			+ ""+q;        
	try{
                // System.out.println(query);
		conn=DBConnection.getConnection();            
		stmt=conn.prepareStatement(query);
		rs=stmt.executeQuery(query);
		
		while(rs.next()){   
                    Reparto r=new Reparto();
                    r.setId(rs.getInt("reparti.id"));
                    r.setNome(rs.getString("reparti.nome"));
                    r.setNote(rs.getString("reparti.note"));
                    r.setStato(rs.getString("reparti.stato"));                      
                    toReturn.add(r);
		}                   
		
	 } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneReparti", "ricerca", ex);
	} catch (SQLException ex) {
            GestioneErrori.errore("GestioneReparti", "ricerca", ex);
	} finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                         
	return toReturn;
    }
}
