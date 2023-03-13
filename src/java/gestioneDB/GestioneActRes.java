package gestioneDB;

import beans.ActCel;
import beans.ActRes;
import beans.Utente;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneActRes {

    private static GestioneActRes istanza;
    
    public static GestioneActRes getIstanza(){
        if(istanza==null)
            istanza=new GestioneActRes();
        return istanza;
    }
    
    
    
    
    public Map<String,ActRes> act_res_data(String data){
         Map<String,ActRes> toReturn=new HashMap<String,ActRes>();
            
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;        
        String query="SELECT * FROM act_pl WHERE data="+Utility.isNull(data);        
        System.out.println(query);
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){                   
                String id_act_res=rs.getString("id_act_res");                    
                ActRes temp=new ActRes();                    
                for(int i=0;i<=47;i++){
                    String valore=rs.getString("act_pl.c"+i);
                    temp.getCelle().put("c"+i, valore);
                }                
                toReturn.put(id_act_res,temp);                
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActRes", "act_res_data", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }    
        
        return toReturn;
    }
    
    
    public Map<String,Integer> act_res_data_inizio_fine( String data){        
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;        
        
        int inizio=-1;
        int fine=-1;
        
        int numero_act_res=(int)Utility.getIstanza().querySelectDouble("SELECT count(id) as numero_act_res FROM act_pl WHERE data="+Utility.isNull(data), "numero_act_res");
        
        String query="SELECT ";
            for(int i=0;i<=47;i++){
                query=query+" sum(abs(c"+i+")) as sum_c"+i+",";
            }
        query=Utility.rimuovi_ultima_occorrenza(query, ",");
        query=query+" FROM act_pl WHERE data="+Utility.isNull(data);
        
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            boolean riattavata=false;
            while(rs.next()){                   
                for(int i=0;i<=47;i++){                    
                    int temp=rs.getInt("sum_c"+i);
                    
                    if(numero_act_res!=temp && inizio==-1)
                        inizio=i;
                    
                    if(numero_act_res!=temp)
                        riattavata=true;
                    
                    if(inizio!=-1 && numero_act_res==temp && riattavata==true){
                        fine=i;
                        riattavata=false;
                    }
                }
            }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActRes", "act_res_data_inizio_fine", ex);
        } finally {           
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);                                        
            DBConnection.releaseConnection(conn);           
        }    
        
        fine=fine-1;
        
        Map<String,Integer> toReturn=new HashMap<String,Integer>();
            toReturn.put("inizio", inizio);
            toReturn.put("fine", fine);
        
        return toReturn;
    }
    
    
    public ActRes get_act_res(String id_act_res){
        ActRes toReturn=null;
        ArrayList<ActRes> temp=ricerca(" act_res.id="+id_act_res+" AND act_res.stato='1'");
        if(temp.size()==1)
            toReturn=temp.get(0);
        return toReturn;
    }
    
    
    public ArrayList<ActRes> act_res_utente(Utente utente){
        String query=" act_res.id_soggetti LIKE "+Utility.isNullLike("_"+utente.getId()+"_")+" AND act_res.stato='1' ";
        if(utente.is_amministratore())
            query=" act_res.stato='1' ";
        return ricerca(query);
    }
    
    public ArrayList<ActRes> ricerca(String query_input){
        ArrayList<ActRes> toReturn=new ArrayList<ActRes>();
            
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        if(query_input.equals(""))
            query_input=" act_res.stato='1' ";
        String query="SELECT * FROM act_res WHERE "+query_input+" ORDER BY act_res.ordinamento ASC";        
        System.out.println(query);
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){   
                ActRes temp=new ActRes();
                    temp.setId(rs.getString("act_res.id"));
                    temp.setCodice(rs.getString("act_res.codice"));
                    temp.setNome(rs.getString("act_res.nome"));
                    temp.setId_fasi(rs.getString("act_res.id_fasi"));
                    temp.setId_soggetti(rs.getString("act_res.id_soggetti"));
                    temp.setOrdinamento(rs.getInt("act_res.ordinamento"));

                    for(int i=0;i<=47;i++){
                        String valore=rs.getString("act_res.c"+i);
                        temp.getCelle().put("c"+i, valore);
                    }
                toReturn.add(temp);                
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActRes", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }    
        
        return toReturn;
    }
    
}
