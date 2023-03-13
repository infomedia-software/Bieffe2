package gestioneDB;

import beans.Act;
import beans.ActRes;
import beans.Attivita;
import beans.Commessa;
import beans.Fase;
import beans.Risorsa;
import beans.Soggetto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneAct {

    private static GestioneAct istanza;
    
    public static GestioneAct getIstanza(){
        if(istanza==null)
            istanza=new GestioneAct();
        return istanza;
    }
    
    
    public Act get_act(String id_act){
        Act toReturn=null;
        ArrayList<Act> temp=ricerca(" act.id="+id_act+" AND act.stato='1'");
        if(temp.size()==1){
            toReturn=temp.get(0);
        }
        return toReturn;
    }
    
    public Map<String,ArrayList<Act>> act_data(String data){
        Map<String,ArrayList<Act>> toReturn=new HashMap<String,ArrayList<Act>>();
        
        ArrayList<ActRes> act_res_list=GestioneActRes.getIstanza().ricerca("");
        for(ActRes act_res:act_res_list){
            ArrayList<Act> temp=ricerca(" "
            + "act.id_act_res="+Utility.isNull(act_res.getId())+" AND "
            + "act.stato='1' AND "
            + " ( DATE(act.inizio)="+Utility.isNull(data)+" OR DATE(act.fine)="+Utility.isNull(data)+" OR (DATE(act.inizio)<="+Utility.isNull(data)+" AND  DATE(act.fine)>="+Utility.isNull(data)+") ) "
            + " ORDER BY act.inizio ASC");
            toReturn.put(act_res.getId(),temp); 
        }
        return toReturn;
    }
    
    public ArrayList<Act> ricerca(String query_input){
        ArrayList<Act> toReturn=new ArrayList<Act>();
        
        
        if(!query_input.equals("")){
            Connection conn=null;
            PreparedStatement stmt=null;
            ResultSet rs=null;

            try{
                conn=DBConnection.getConnection();            
                if(query_input.equals(""))
                    query_input=" act_res.stato='1' ORDER BY act_res.id ASC";
                
                String query="SELECT * FROM act "
                        + "LEFT OUTER JOIN commesse ON act.id_commessa=commesse.id "
                        + "LEFT OUTER JOIN soggetti ON commesse.soggetto=soggetti.id "
                        + "LEFT OUTER JOIN act_res ON act.id_act_res=act_res.id "
                        + "WHERE "+query_input;
                System.out.println(query);
                stmt=conn.prepareStatement(query);
                rs=stmt.executeQuery(query);

                while(rs.next()){
                    Act temp=new Act();
                    
                        temp.setId(rs.getString("act.id"));
                        String commessa_stringa=rs.getString("commesse.id");
                        Commessa commessa=new Commessa();
                        if(commessa_stringa.equals("")){
                            commessa.setId("");
                            commessa.setDescrizione("");
                            commessa.setNumero("");
                            commessa.setColore("");
                            Soggetto cliente=new Soggetto();
                                cliente.setId("");
                                cliente.setAlias("");                                
                            commessa.setSoggetto(cliente);
                        }else{
                            commessa.setId(rs.getString("commesse.id"));
                            commessa.setNumero(rs.getString("commesse.numero"));
                            commessa.setDescrizione(rs.getString("commesse.descrizione"));
                            commessa.setColore(rs.getString("commesse.colore"));
                            Soggetto cliente=new Soggetto();
                                cliente.setId(rs.getString("soggetti.id"));
                                cliente.setAlias(rs.getString("soggetti.alias"));                                
                            commessa.setSoggetto(cliente);
                        }
                        temp.setCommessa(commessa);
                        
                        String id_act_res=rs.getString("act.id_act_res");                        
                        ActRes act_res=new ActRes();
                        if(id_act_res.equals("")){
                            act_res.setId("");
                            act_res.setCodice("");
                            act_res.setNome("");                            
                        }else{
                            act_res.setId(rs.getString("act_res.id"));
                            act_res.setCodice(rs.getString("act_res.codice"));
                            act_res.setNome(rs.getString("act_res.nome"));                            
                        }
                        temp.setAct_res(act_res);
                        
                        
                        Fase fase=new Fase();
                            fase.setId(rs.getString("act.id_fase"));
                        temp.setFase(fase);
                                                
                        temp.setDescrizione(rs.getString("act.descrizione"));
                        temp.setInizio(rs.getString("act.inizio"));
                        temp.setFine(rs.getString("act.fine"));
                        temp.setDurata(rs.getDouble("act.durata"));
                        temp.setRitardo(rs.getDouble("act.ritardo"));
                        temp.setProgrammata(rs.getString("act.programmata"));                        
                        temp.setAttiva(rs.getString("act.attiva"));
                        temp.setCompletata(rs.getString("act.completata"));
                        temp.setNote(rs.getString("act.note"));
                        temp.setLibero1(rs.getString("act.libero1"));
                        temp.setLibero2(rs.getString("act.libero2"));
                        temp.setLibero3(rs.getString("act.libero3"));
                        temp.setLibero4(rs.getString("act.libero4"));
                        temp.setLibero5(rs.getString("act.libero5"));
                        temp.setLibero6(rs.getString("act.libero6"));
                        temp.setLibero7(rs.getString("act.libero7"));
                        temp.setLibero8(rs.getString("act.libero8"));
                        temp.setLibero9(rs.getString("act.libero9"));
                        temp.setLibero10(rs.getString("act.libero10"));
                        temp.setData_creazione(rs.getString("act.data_creazione"));
                        temp.setData_modifica(rs.getString("act.data_modifica"));
                        temp.setStato(rs.getString("act.stato"));
                        
                    toReturn.add(temp);
                }            

            } catch (ConnectionPoolException ex) {
                GestioneErrori.errore("GestioneAct", "ricerca", ex);
            } catch (SQLException ex) {
                GestioneErrori.errore("GestioneAct", "ricerca", ex);
            } finally {
                    DBUtility.closeQuietly(rs);
                    DBUtility.closeQuietly(stmt);
                    DBConnection.releaseConnection(conn);   
            }       
           
        }
        return toReturn;
    }
    
}
