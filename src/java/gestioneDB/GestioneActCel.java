package gestioneDB;

import beans.ActCel;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneActCel {
    
    private static GestioneActCel istanza;
    public static GestioneActCel getIstanza(){
        if(istanza==null)
            istanza=new GestioneActCel();
        return istanza;
    }
    
    public ArrayList<ActCel> ricerca(String id_act_res,String data,String ora){
        ArrayList<ActCel> toReturn=new ArrayList<ActCel>();
            
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        
        String query="SELECT * FROM act_pl WHERE data>="+Utility.isNull(data)+" AND id_act_res="+Utility.isNull(id_act_res)+" ORDER BY act_pl.data ASC ";        
        System.out.println(query);
        System.out.println(ora);
        try{
            conn=DBConnection.getConnection();                                    
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
                                    
            int indice_iniziale=calcola_indice_act_cel_from_orario(ora);
            
            while(rs.next()){   
                String data_temp=rs.getString("data");
                String id_act_res_temp=rs.getString("id_act_res");
                for(int i=indice_iniziale;i<48;i++){
                    ActCel temp=new ActCel();
                    temp.setData(data_temp);
                    temp.setId_act_res(id_act_res_temp);
                    String etichetta="c"+i;
                    String valore=rs.getString(etichetta);
                    temp.setEtichetta(etichetta);
                    temp.setValore(valore);                    
                    toReturn.add(temp);
                }
                indice_iniziale=0;                
             }                   
            
        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneActCal", "ricerca", ex);
        } finally {           
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);                                        
                DBConnection.releaseConnection(conn);           
        }               
        
        return toReturn;
    }
    
    public static int calcola_indice_act_cel_from_orario(String ora){
        int toReturn=0;
        if(ora.equals(":"))toReturn=0;
        if(ora.equals("00:30"))toReturn=1;
        if(ora.equals("01:00"))toReturn=2;
        if(ora.equals("01:30"))toReturn=3;
        if(ora.equals("02:00"))toReturn=4;
        if(ora.equals("02:30"))toReturn=5;
        if(ora.equals("03:00"))toReturn=6;
        if(ora.equals("03:30"))toReturn=7;
        if(ora.equals("04:00"))toReturn=8;
        if(ora.equals("04:30"))toReturn=9;
        if(ora.equals("05:00"))toReturn=10;
        if(ora.equals("05:30"))toReturn=11;
        if(ora.equals("06:00"))toReturn=12;
        if(ora.equals("06:30"))toReturn=13;
        if(ora.equals("07:00"))toReturn=14;
        if(ora.equals("07:30"))toReturn=15;
        if(ora.equals("08:00"))toReturn=16;
        if(ora.equals("08:30"))toReturn=17;
        if(ora.equals("09:00"))toReturn=18;
        if(ora.equals("09:30"))toReturn=19;
        if(ora.equals("10:00"))toReturn=20;
        if(ora.equals("10:30"))toReturn=21;
        if(ora.equals("11:00"))toReturn=22;
        if(ora.equals("11:30"))toReturn=23;
        if(ora.equals("12:00"))toReturn=24;
        if(ora.equals("12:30"))toReturn=25;
        if(ora.equals("13:00"))toReturn=26;
        if(ora.equals("13:30"))toReturn=27;
        if(ora.equals("14:00"))toReturn=28;
        if(ora.equals("14:30"))toReturn=29;
        if(ora.equals("15:00"))toReturn=30;
        if(ora.equals("15:30"))toReturn=31;
        if(ora.equals("16:00"))toReturn=32;
        if(ora.equals("16:30"))toReturn=33;
        if(ora.equals("17:00"))toReturn=34;
        if(ora.equals("17:30"))toReturn=35;
        if(ora.equals("18:00"))toReturn=36;
        if(ora.equals("18:30"))toReturn=37;
        if(ora.equals("19:00"))toReturn=38;
        if(ora.equals("19:30"))toReturn=39;
        if(ora.equals("20:00"))toReturn=40;
        if(ora.equals("20:30"))toReturn=41;
        if(ora.equals("21:00"))toReturn=42;
        if(ora.equals("21:30"))toReturn=43;
        if(ora.equals("22:00"))toReturn=44;
        if(ora.equals("22:30"))toReturn=45;
        if(ora.equals("23:00"))toReturn=46;
        if(ora.equals("23:30"))toReturn=47;        
        return toReturn;
    }
    
    public static String calcola_orario_act_cel_from_indice(int indice){
        String toReturn=":";
        if(indice==0 || indice==48) toReturn="00:00";
        if(indice==1)toReturn="00:30";
        if(indice==2)toReturn="01:00";
        if(indice==3)toReturn="01:30";
        if(indice==4)toReturn="02:00";
        if(indice==5)toReturn="02:30";
        if(indice==6)toReturn="03:00";
        if(indice==7)toReturn="03:30";        
        if(indice==8)toReturn="04:00";
        if(indice==9)toReturn="04:30";
        if(indice==10)toReturn="05:00";
        if(indice==11)toReturn="05:30";
        if(indice==12)toReturn="06:00";
        if(indice==13)toReturn="06:30";
        if(indice==14)toReturn="07:00";
        if(indice==15)toReturn="07:30";
        if(indice==16)toReturn="08:00";
        if(indice==17)toReturn="08:30";
        if(indice==18)toReturn="09:00";
        if(indice==19)toReturn="09:30";
        if(indice==20)toReturn="10:00";
        if(indice==21)toReturn="10:30";
        if(indice==22)toReturn="11:00";
        if(indice==23)toReturn="11:30";
        if(indice==24)toReturn="12:00";
        if(indice==25)toReturn="12:30";
        if(indice==26)toReturn="13:00";
        if(indice==27)toReturn="13:30";
        if(indice==28)toReturn="14:00";
        if(indice==29)toReturn="14:30";
        if(indice==30)toReturn="15:00";
        if(indice==31)toReturn="15:30";
        if(indice==32)toReturn="16:00";
        if(indice==33)toReturn="16:30";
        if(indice==34)toReturn="17:00";
        if(indice==35)toReturn="17:30";
        if(indice==36)toReturn="18:00";
        if(indice==37)toReturn="18:30";
        if(indice==38)toReturn="19:00";
        if(indice==39)toReturn="19:30";
        if(indice==40)toReturn="20:00";
        if(indice==41)toReturn="20:30";
        if(indice==42)toReturn="21:00";
        if(indice==43)toReturn="21:30";
        if(indice==44)toReturn="22:00";
        if(indice==45)toReturn="22:30";
        if(indice==46)toReturn="23:00";
        if(indice==47)toReturn="23:30";
        
        return toReturn;
    }
    
    
}

