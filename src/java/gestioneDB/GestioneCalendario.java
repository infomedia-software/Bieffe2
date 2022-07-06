
package gestioneDB;

import beans.Allegato;
import beans.DataCalendario;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneCalendario {

    private static GestioneCalendario istanza;
    
    public static GestioneCalendario getIstanza(){
        if(istanza==null)
            istanza=new GestioneCalendario();
        return istanza;
    }

    public boolean is_data_creata(String data_input){
        boolean toReturn=false;
        String temp=Utility.getIstanza().querySelect(" SELECT data FROM calendario WHERE data="+Utility.isNull(data_input), "data");        
        if(!temp.equals(""))
            toReturn=true;        
        return toReturn;
    }
    
    public String prima_data_succ(String data_input){
        String toReturn="";
        toReturn=Utility.getIstanza().querySelect(" SELECT min(data) as temp FROM calendario WHERE situazione='abilitato' AND data>"+Utility.isNull(data_input), "temp");
        return toReturn;
    }
    
    public String prima_data_prec(String data_input){
        String toReturn=Utility.getIstanza().querySelect(" SELECT max(data) as temp FROM calendario WHERE situazione='abilitato' AND data<"+Utility.isNull(data_input), "temp");
        return toReturn;
    }
    
    public DataCalendario get_data_calendario(String data){
        DataCalendario toReturn=null;
        ArrayList<DataCalendario> temp=ricerca(" calendario.data="+Utility.isNull(data));
        if(temp.size()==1){
            toReturn=temp.get(0);
        }            
        return toReturn;
    }
    
    public ArrayList<DataCalendario> ricerca(String query_input){
        ArrayList<DataCalendario> toReturn=new ArrayList<DataCalendario>();
         try {                        
            Connection conn=DBConnection.getConnection();
            String query="SELECT * FROM calendario WHERE "+query_input;           
            Statement stmt = conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);        
            while(rs.next()){                      
                DataCalendario temp=new DataCalendario();                    
                    temp.setData(rs.getString("data"));
                    temp.setNote(rs.getString("note"));
                    temp.setSituazione(rs.getString("situazione"));
                    temp.setStato(rs.getString("stato"));
                toReturn.add(temp);
            }                       
            rs.close();
            stmt.close();
            DBConnection.releaseConnection(conn);
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneCalendario", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneCalendario", "ricerca", ex);
        }        
        return toReturn;
    }
    
    
}
