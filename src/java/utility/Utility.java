
package utility;

import connection.ConnectionPoolException;
import gestioneDB.DBConnection;
import gestioneDB.DBConnection_External_DB;
import gestioneDB.DBUtility;
import java.awt.Color;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Random;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Utility {
    private static Utility istanza;
        
    
    //public static String url="http://app.infomediatek.it/Bieffe2";
    //public static String socket_url="ws://app.infomediatek.it/Bieffe2/websocketendpoint";           
    
    
    public static String url="http://localhost:8084/Bieffe2";           
    public static String socket_url="ws://localhost:8084/Bieffe2/websocketendpoint";       
    
    public static String nomeSoftware="Infogest Infomedia ";
    
    public static int numero_righe_pagine=50;
    
    public static String dadefinire="3001-01-01 00:00:00.0";
    
    public static Utility getIstanza(){
        if(istanza==null){
            istanza=new Utility();                            
        }
        return istanza;
    }
    
    
    public static ArrayList<String> lista_data_ore(String data){
        ArrayList<String> orari=new ArrayList<String>();
        orari.add(data+" 00:00:00.0");orari.add(data+" 00:30:00.0");
        orari.add(data+" 01:00:00.0");orari.add(data+" 01:30:00.0");
        orari.add(data+" 02:00:00.0");orari.add(data+" 02:30:00.0");
        orari.add(data+" 03:00:00.0");orari.add(data+" 03:30:00.0");
        orari.add(data+" 04:00:00.0");orari.add(data+" 04:30:00.0");
        orari.add(data+" 05:00:00.0");orari.add(data+" 05:30:00.0");
        orari.add(data+" 06:00:00.0");orari.add(data+" 06:30:00.0");
        orari.add(data+" 07:00:00.0");orari.add(data+" 07:30:00.0");
        orari.add(data+" 08:00:00.0");orari.add(data+" 08:30:00.0");
        orari.add(data+" 09:00:00.0");orari.add(data+" 09:30:00.0");
        orari.add(data+" 10:00:00.0");orari.add(data+" 10:30:00.0");
        orari.add(data+" 11:00:00.0");orari.add(data+" 11:30:00.0");
        orari.add(data+" 12:00:00.0");orari.add(data+" 12:30:00.0");
        orari.add(data+" 13:00:00.0");orari.add(data+" 13:30:00.0");
        orari.add(data+" 14:00:00.0");orari.add(data+" 14:30:00.0");
        orari.add(data+" 15:00:00.0");orari.add(data+" 15:30:00.0");
        orari.add(data+" 16:00:00.0");orari.add(data+" 16:30:00.0");
        orari.add(data+" 17:00:00.0");orari.add(data+" 17:30:00.0");
        orari.add(data+" 18:00:00.0");orari.add(data+" 18:30:00.0");
        orari.add(data+" 19:00:00.0");orari.add(data+" 19:30:00.0");
        orari.add(data+" 20:00:00.0");orari.add(data+" 20:30:00.0");
        orari.add(data+" 21:00:00.0");orari.add(data+" 21:30:00.0");
        orari.add(data+" 22:00:00.0");orari.add(data+" 22:30:00.0");
        orari.add(data+" 23:00:00.0");orari.add(data+" 23:30:00.0");            
        return orari;
    }
    
    
    
    
    public static String elimina_zero(double durata){
        String toReturn=durata+"";
        if(toReturn.endsWith(".0"))
            toReturn=(int)durata+"";
        return toReturn;
    }
    
    public  String getValoreByCampo(String tabella,String campo,String condizione){        
        String toReturn="";
        String query="SELECT "+campo+" FROM "+tabella+" WHERE "+condizione;
        System.out.println(query);
        try{
            Connection  conn=DBConnection.getConnection();
            Statement stmt=conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);    
            while(rs.next()){
                toReturn=rs.getString(tabella+"."+campo);
            }
            stmt.close();
            rs.close();
            DBConnection.releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "getValoreByCampo", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "getValoreByCampo", ex);
        }       
        //System.out.println("->"+toReturn+"<-");
        return toReturn;        
    }
    
     public  String getValoreByCampoExternalDB(String tabella,String campo,String condizione){        
        String toReturn="";
        String query="SELECT "+campo+" FROM "+tabella+" WHERE "+condizione;
        //System.out.println(query);
        try{
            Connection  conn=DBConnection_External_DB.getConnection();
            Statement stmt=conn.createStatement();
            ResultSet rs=stmt.executeQuery(query);    
            while(rs.next()){
                toReturn=rs.getString(tabella+"."+campo);
            }
            stmt.close();
            rs.close();
            DBConnection_External_DB.releaseConnection(conn);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "getValoreByCampoExternalDB", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "getValoreByCampoExternalDB", ex);
        }       
        return toReturn;        
    }
    
    
       
    public  double querySelectDouble(String query,String campo){            
        double toReturn=0;
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{                      
            conn=gestioneDB.DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);            
            while(rs.next()){                
                toReturn=rs.getDouble(campo);
            }                              
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "querySelectDouble", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "querySelectDouble", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }                    
        return toReturn;        
    }
    
    /**
     * 
     * @param query
     * @return 
     */
    public  String query(String query){
        String toReturn="";    
        Connection conn=null;
        try {    
            conn=DBConnection.getConnection();
            if(Utility.url.contains("localhost"))
                System.out.println("QUERY: >"+query+"<");
            DBUtility.executeOperation(conn, query);
            
        } catch (ConnectionPoolException | SQLException ex ) {
            GestioneErrori.errore("Utility", "query", ex);
        }finally{
            DBConnection.releaseConnection(conn);                        
        }
        return toReturn;
    }
    
    /**
     * 
     * @param conn
     * @param query
     * @return 
     */
    public String queryTransaction(Connection conn,String query){
        String toReturn="";    
        //System.out.println("queryTransaction>"+query);
        try {    
            conn.setAutoCommit(false);
            PreparedStatement stmt = conn.prepareStatement(query);            
            stmt.executeUpdate();
            stmt.close();            
            DBConnection.releaseConnection(conn);                        
        //System.out.println("fine queryTransaction>"+query);
        }catch (SQLException ex ){
            GestioneErrori.errore("Utility", "queryTransaction", ex);
        }

        return toReturn;
        
    }
    
    
    
    public static String eliminaNull(String stringa){
        if(stringa==null)
            return"";
        else
            return stringa;
    }
 
    
    public static String isNull(String pStr) {
        String tTmp;
        if (pStr == null) 
        {
                tTmp = "'null'";        
        }
        else 
        {                 
                pStr = ReplaceAllStrings(pStr, "\'", "\\'");
                //pStr = ReplaceAllStrings(pStr, "/", "//");
                pStr = ReplaceAllStrings(pStr, "\"", "\\" + "\"");
                pStr = pStr.replaceAll("(\r\n|\n)", "<br>");
                tTmp = "'" + pStr + "'";
        }
        return tTmp;
    }
    
    public static String isNull(Integer pInt) {
        String tIntString;
        if (pInt == null)
                tIntString = "null";
        else
                tIntString = pInt.toString();
        return tIntString;
    }
    
     public static String isNull(Timestamp t) {
        String tIntString;
        if (t == null)
                tIntString = "null";
        else
                tIntString = "'"+t+"'";
        return tIntString;
    }
    
    
    public static String isNull(Double pInt) {
        String tIntString;

        if (pInt == null)
                tIntString = "null";
        else
                tIntString = pInt.toString();
        return tIntString;
    }
    
    public static String isNullLike(String pStr){
        String tTmp;
        if (pStr == null) 
                tTmp = "null";
        else {
                pStr = ReplaceAllStrings(pStr, "'", "\\'");
                pStr = ReplaceAllStrings(pStr, "/", "//");
                pStr = ReplaceAllStrings(pStr, "\"", "\\" + "\"");
                pStr = pStr.replaceAll("(\r\n|\n)", "<br>");
                tTmp="'%"+pStr+"%'";
        }
        return tTmp;
    }
    
    private static String ReplaceAllStrings(String sourceStr, String searchFor, String replaceWith) {
        StringBuffer searchBuffer = new StringBuffer(sourceStr);
        StringBuffer newStringBuffer = new StringBuffer("");

        while (searchBuffer.toString().toUpperCase().indexOf(searchFor.toUpperCase()) >= 0) {
                int newIndex = searchBuffer.toString().toUpperCase().indexOf(searchFor.toUpperCase());
                newStringBuffer.append(searchBuffer.substring(0, newIndex));
                newStringBuffer.append(replaceWith);
                searchBuffer = new StringBuffer(searchBuffer.substring(newIndex+ searchFor.length(), searchBuffer.length()));
        }
        newStringBuffer.append(searchBuffer);
        return newStringBuffer.toString();
    }
    
    
    public static String annoCorrente(){
        return GregorianCalendar.getInstance().get(GregorianCalendar.getInstance().YEAR)+"";
    }
    
    public static String dataOdiernaFormatoDB(){                
        String toReturn="";
        Date data=new Date();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd"); 
        toReturn=sdf.format(data);    
        return toReturn;
        
    }
    
    public static String dataOdiernaFormatoIT(){                
        String toReturn="";
        Date data=new Date();
        SimpleDateFormat sdf=new SimpleDateFormat("dd-MM-yyyy"); 
        toReturn=sdf.format(data);    
        return toReturn;
        
    }
    
    public static String standardizzaStringaPerTextArea(String valore_campo){
        if(valore_campo==null)
            return "";
        String temp=valore_campo.replace("\\'","'");
        temp=temp.replace("//","/");
        return temp.replaceAll("<br>", "\n");
    }
    
     public static String convertiDataFormatoIT(String data){        
        if(data==null)
            return "";
        if(data.equals(""))
            return "";
        if(data.equals("3001-01-01"))
            return "da definire";
        String toReturn="";        
        String year = "";
        String month = "";
        String day = "";
        
        String[] temp=data.split("-"); 
        int temp_day=convertiStringaInInt(temp[2]);
        int temp_month=convertiStringaInInt(temp[1]);
        int temp_year = convertiStringaInInt(temp[0]);
        day = temp_day<10 ? ("0"+temp_day):(""+temp_day);
        month = temp_month<10 ? ("0"+temp_month):(""+temp_month);
        year = temp_year+"";
        toReturn=day+"/"+month+"/"+year;            
        return toReturn;
    }
    
       
    public static int convertiStringaInInt(String daConvertire){
        int toReturn=0;
        if(daConvertire==null)
            return toReturn;
        try{
            toReturn=Integer.parseInt(daConvertire);
            return toReturn;
        }catch(NumberFormatException ex){            
            return toReturn;
        }
    }
    
    
    public static Timestamp convertiStringaInTimestamp(String yourString){
        Timestamp toReturn=null;
        if(yourString.length()<16)
            yourString=yourString+":000";
        try {   
            toReturn=Timestamp.valueOf(yourString) ;
        } catch(Exception e) { 
            GestioneErrori.errore("Utility", "convertiStringaInTimestamp", e);
        }
        return toReturn;
    }
    
    public static double convertiStringaInDouble(String daConvertire){
        double toReturn=0;
        if(daConvertire==null)
            return toReturn;
        try{
            toReturn=Double.parseDouble(daConvertire);
            return toReturn;
        }catch(NumberFormatException ex){            
            return toReturn;
        }
    }
    
     public static String convertiDatetimeFormatoIT(String datetime){        
        if(datetime==null)
            return "";
        if(datetime.equals(""))
            return "";
        if(datetime.startsWith("3001-01-01"))
            return "";
        String toReturn="";
        String[] temp=datetime.split(" ");
        String parte1=convertiDataFormatoIT(temp[0]);
        toReturn=parte1+" "+temp[1].substring(0,8);
        return toReturn;
    }
     
    public static String convertiSecondiInOre(int totalSecs){
        int hours = totalSecs / 3600;
        int minutes = (totalSecs % 3600) / 60;
        int seconds = totalSecs % 60;
        String timeString = String.format("%02d:%02d", hours, minutes, seconds);
        return timeString;
    }
    
    public static String formattaOrario(int ora,int minuti){       
        String toReturn="";
        int oredaaggiungere=0;
        
        if(minuti>45){
            oredaaggiungere=(int)minuti/60;
            minuti=minuti%60;            
        }
        ora=ora+oredaaggiungere;
        if(ora==24)
            ora=0;
        
        if(ora<10)
            toReturn="0"+ora;                
        else
            toReturn=ora+"";                
        
        if(minuti==0){
            toReturn=toReturn+":00";    
        }else{
            if(minuti<10)
                toReturn=toReturn+":0"+minuti;    
            else
                toReturn=toReturn+":"+minuti;    
        }
        
        return toReturn;        
    }
    
   
   
     public static String aggiungiOre(String t,int ore,int minuti){
        String toReturn="";        
       
        Timestamp timestamp = convertiStringaInTimestamp(t);
        Timestamp temp=null;
        temp=new Timestamp(timestamp.getTime());
        long da_aggiungere=ore*60*60*1000;
        if(minuti==30)
            da_aggiungere=da_aggiungere+30*60*1000;
        temp.setTime(temp.getTime()+da_aggiungere);            
        
        toReturn=temp+"";
        toReturn=toReturn.substring(0,toReturn.lastIndexOf(".0"));
        
        return toReturn;
    }
     
     /**
      * 
      * @param t
      * @param ore_minuti
      * @return 
      */
     public static String aggiungi_ore_minuti(String t,double ore_minuti){
        String toReturn="";        
       
        Timestamp timestamp = convertiStringaInTimestamp(t);
        Timestamp temp=null;
        temp=new Timestamp(timestamp.getTime());
        
        int ore=(int)ore_minuti;
        long da_aggiungere=ore*60*60*1000;
        
        double minuti=ore_minuti-ore;

        if(minuti>0)
            da_aggiungere=da_aggiungere+30*60*1000;
        temp.setTime(temp.getTime()+da_aggiungere);            
        toReturn=temp+"";

        return toReturn;
    }
   
     
    public static String dataFutura(String data,int days){              
        String toReturn="";
        Calendar calendar = Calendar.getInstance();
        String[] temp=data.split("-");
        calendar.set(convertiStringaInInt(temp[0]), convertiStringaInInt(temp[1])-1, convertiStringaInInt(temp[2]));                
        calendar.add(Calendar.DAY_OF_YEAR, days);       
        Date tomorrow = calendar.getTime();                
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd"); 
        toReturn=sdf.format(tomorrow);       
        return toReturn;
    }    
    
     public static Timestamp aggiungiOreTimestamp(Timestamp t,double ore){        
        Timestamp temp=new Timestamp(t.getTime());
        temp.setTime(t.getTime()+((int)ore*60*60*1000));    
        return temp;
    }
    
    public static ArrayList<String> standardizzaDurata(String newvalore){
        ArrayList<String> toReturn=new ArrayList<String>();
        String ore="";
        String minuti="";
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
        toReturn.add(ore);
        toReturn.add(minuti);
        return toReturn;
    }
    
    
    public static int giornodellasettimana(String yourDate){
        SimpleDateFormat format1=new SimpleDateFormat("yyyy-MM-dd");
        int dayOfWeek=-1;        
        try {
            Date dt1= format1.parse(yourDate);                    
            Calendar c = Calendar.getInstance();
            c.setTime(dt1);
            dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        } catch (ParseException ex) {
            GestioneErrori.errore("Utility", "giornodellasettimana", ex);
        }
        return dayOfWeek;
    }
    
    
    /**
     *    date1.compareTo(date2); //date1 minore date2 otterremo come risultato un valore < 0 \n
     *    date1.compareTo(date3); //date1 uguale date3 otterremo come risultato = 0 \n
     *    date2.compareTo(date1); //date2 maggiore date1 otterremo come risultato un valore > 0    \n
     * @param data1
     * @param data2
     * @return 
     **/
    public static  int confrontaDate(String data1,String data2){
        int toReturn=0;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
            Date date1 = sdf.parse(data1); 
            Date date2 = sdf.parse(data2); 
            toReturn=date1.compareTo(date2);
        } catch (ParseException ex) {
            GestioneErrori.errore("Utility", "confrontaDate", ex);
        }
        return toReturn;
    }
    
    
    
 
    /**
     *    date1.compareTo(date2); //date1 < date2 otterremo come risultato un valore < 0 \n
     *    date1.compareTo(date3); //date1 = date2 otterremo come risultato = 0 \n
     *    date2.compareTo(date1); //date1 > date2 otterremo come risultato un valore > 0      \n
     * @param data1
     * @param data2
     * @return 
     */
    public static  int confrontaTimestamp(String data1,String data2){
        int toReturn=0;

        
        if(data1.equals("") && !data2.equals("")){
            toReturn=1;
        }        
        if(!data1.equals("") && data2.equals("")){
            toReturn=-1;
        }
            
        if(!data1.equals("") && !data2.equals("")){
            double minuti=compareTwoTimeStamps(data1, data2);
            if(minuti<0)
                toReturn=-1;
            if(minuti>0)
                toReturn=1;
        }
        return toReturn;
    }
    
    
    /**
     *    date1.compareTo(date2); //date1 < date2 otterremo come risultato un valore < 0
     *    date1.compareTo(date3); //date1 = date3 otterremo come risultato = 0
     *    date2.compareTo(date1); //date2 > date1 otterremo come risultato un valore > 0     
     * @param data1
     * @param data2
     * @return 
     */
    public static  int differenzaTimestamp(String data1,String data2){
        int toReturn=0;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:sss"); 
            Date date1 = sdf.parse(data1); 
            Date date2 = sdf.parse(data2); 
            toReturn=date1.compareTo(date2);
        } catch (ParseException ex) {
            GestioneErrori.errore("Utility", "confrontaTimestamp", ex);
        }
        return toReturn;
    }
    
    public static String giornoDellaSettimana(String giorno){
        ////System.out.println("Utility.giornoDellaSettimana>"+giorno+"<");
        String toReturn="";
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(giorno);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        calendar.setTime(date);
        int valore=calendar.get(Calendar.DAY_OF_WEEK);
        
        if(valore==7)
            toReturn="dom";
        if(valore==1)
            toReturn="lun";
        if(valore==2)
            toReturn="mar";
        if(valore==3)
            toReturn="mer";
        if(valore==4)
            toReturn="gio";
        if(valore==5)
            toReturn="ven";
        if(valore==6)
            toReturn="sab";
                    
        
        return toReturn;
    }
    
    public  String querySelect(String query,String campo){            
        String toReturn="";
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{                      
            ////System.out.print("querySelect: "+query+" ");
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){                
                toReturn=rs.getString(campo);
            }                   
            
            //System.out.println("toReturn: "+toReturn+"");
        } catch (SQLException ex) {
            GestioneErrori.errore("UCS", "querySelect", ex);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("UCS", "querySelect", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;        
    }
    
    public  String query_insert(String query){
        
        String toReturn="";
	Connection conn=null;
	Statement stmt=null;
	ResultSet keys=null;        
	try 
	{                                      
            conn=DBConnection.getConnection();
            stmt = conn.createStatement();                        
            stmt.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
            keys = stmt.getGeneratedKeys();    
            keys.next();  
            toReturn = ""+keys.getInt(1);            
            keys.close();
            stmt.close();   		            
	} catch (SQLException ex) {
		GestioneErrori.errore("Utility", "query_insert", ex);
	} catch (ConnectionPoolException ex) {
		GestioneErrori.errore("Utility", "query_insert", ex);
	}finally{           
            try {
                keys.close();
                stmt.close();                
                DBConnection.releaseConnection(conn);
            } catch (SQLException ex) {
                GestioneErrori.errore("Utility", "query_insert", ex);
            }
        }        
	return toReturn;           
    }
    
      
    public static Timestamp dataOraCorrente(){
        return new java.sql.Timestamp(Calendar.getInstance().getTime().getTime());        
    }
    
    public static String dataOraCorrente_String(){
        String toReturn=dataOdiernaFormatoDB()+" "+oraMinutiSecondiCorrente();
        return toReturn;
    }
    
    public static String oraMinutiSecondiCorrente(){
        String toReturn="";
        Calendar now = Calendar.getInstance();       
        int hour = now.get(Calendar.HOUR_OF_DAY);
        int minute = now.get(Calendar.MINUTE);
        int second = now.get(Calendar.SECOND);
        //int millis = now.get(Calendar.MILLISECOND);
        if(hour>=10)
            toReturn=hour+"";
        else
            toReturn="0"+hour;        
        if(minute>=10)
            toReturn=toReturn+":"+minute+"";
        else
            toReturn=toReturn+":"+"0"+minute;
        
         if(second>=10)
            toReturn=toReturn+":"+second+"";
        else
            toReturn=toReturn+":"+"0"+second;
        return toReturn;         
    }
    
    public static int ora_corrente(){
        Calendar now = Calendar.getInstance();       
        int hour = now.get(Calendar.HOUR_OF_DAY);            
        return hour;         
    }
    
     public static int minuti_corrente(){
        Calendar now = Calendar.getInstance();       
        int minuti = now.get(Calendar.MINUTE);            
        return minuti;         
    }
    
    /**
     * @param currentTime_string
     * @param oldTime_string
     * @return 
     */
    public static long compareTwoTimeStamps(String currentTime_string, String oldTime_string)
    {
        java.sql.Timestamp oldTime=Utility.convertiStringaInTimestamp(oldTime_string);
        java.sql.Timestamp currentTime=Utility.convertiStringaInTimestamp(currentTime_string);
        long milliseconds1 = oldTime.getTime();
        long milliseconds2 = currentTime.getTime();

        long diff = milliseconds2 - milliseconds1;
        //long diffSeconds = diff / 1000;
        long diffMinutes = diff / (60 * 1000);
        //long diffHours = diff / (60 * 60 * 1000);
        //long diffDays = diff / (24 * 60 * 60 * 1000);

        return diffMinutes;
    }
    
    /**
     * ritorna un codice html relativo ad un colore random
     * @return 
     */
    public static String randomColor(){
        Random random = new Random();
        int nextInt = random.nextInt(0xffffff + 1);       
        String colorCode = String.format("#%06x", nextInt);
        return colorCode;
    }
    
    
    public static String formatta_durata(double durata){
        String toReturn=durata+"";
        if(toReturn.endsWith(".0"))
            toReturn=(int)durata+"";
        return toReturn;
    }
    
    /**
     * Metodo che prende in input un orario decimale (es. 10.8) e ritorna il valore hh:mm:ss
     * @param takttime durata da convertire
     * @return 
     *     durata in formato hh:mm:ss
     */
    public static String converti_durata(double finalBuildTime){
        String toReturn="";
        int hours = (int) finalBuildTime;
        int minutes = (int) (finalBuildTime * 60) % 60;
        int seconds = (int) (finalBuildTime * (60*60)) % 60;
        String h=""+hours;
        String m=""+minutes;
        String s=""+seconds;
        if(hours<10)
            h="0"+h;
        if(minutes<10)
            m="0"+m;
        if(seconds<10)
            s="0"+s;
        
        toReturn=String.format("%s:%s:%s", h, m, s);
        return toReturn;
    }
    
    /***
     * Metodo che calcola la durata di un task convertendo i minuti in ore... es. 65 minuti -> 1.5 h
     */
    public static double converti_durata_task_per_attivita(int durata_task){
        double toReturn=durata_task/60;
        int parte_decimale=durata_task%60;
        if(parte_decimale>0 && parte_decimale<=30)
            toReturn=toReturn+0.5;
        if(parte_decimale>30)
            toReturn=toReturn+1;        
        return toReturn;
    }    
    
    public static String formatta_prezzo(double prezzo){        
        DecimalFormat df = new DecimalFormat("#,##0.00");
        df.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ITALY));
        return df.format(prezzo);
    }
    
    public static String formatta_prezzo_3_cifre(double prezzo){        
        DecimalFormat df = new DecimalFormat("#,##0.000");
        df.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ITALY));
        return df.format(prezzo);
    }
    
    public static String formatta_prezzo_4_cifre(double prezzo){        
        DecimalFormat df = new DecimalFormat("#,##0.0000");
        df.setDecimalFormatSymbols(new DecimalFormatSymbols(Locale.ITALY));
        return df.format(prezzo);
    }
    
    
    public ArrayList<String> lista_orari(){
        ArrayList<String> toReturn=new ArrayList<String>();
            toReturn.add("00:00");toReturn.add("00:30");
            toReturn.add("01:00");toReturn.add("01:30");
            toReturn.add("02:00");toReturn.add("02:30");
            toReturn.add("03:00");toReturn.add("03:30");
            toReturn.add("04:00");toReturn.add("04:30");
            toReturn.add("05:00");toReturn.add("05:30");
            toReturn.add("06:00");toReturn.add("06:30");
            toReturn.add("07:00");toReturn.add("07:30");
            toReturn.add("08:00");toReturn.add("08:30");
            toReturn.add("09:00");toReturn.add("09:30");
            toReturn.add("10:00");toReturn.add("10:30");
            toReturn.add("11:00");toReturn.add("11:30");
            toReturn.add("12:00");toReturn.add("12:30");
            toReturn.add("13:00");toReturn.add("13:30");
            toReturn.add("14:00");toReturn.add("14:30");
            toReturn.add("15:00");toReturn.add("15:30");
            toReturn.add("16:00");toReturn.add("16:30");
            toReturn.add("17:00");toReturn.add("17:30");
            toReturn.add("18:00");toReturn.add("18:30");
            toReturn.add("19:00");toReturn.add("19:30");
            toReturn.add("20:00");toReturn.add("20:30");
            toReturn.add("21:00");toReturn.add("21:30");
            toReturn.add("22:00");toReturn.add("22:30");
            toReturn.add("23:00");toReturn.add("23:30");            
        return toReturn;
    }
   
    public static String substring_data(String timestamp){
        String toReturn="";
        if(timestamp!=null)
            toReturn=timestamp.substring(0,10);
        return toReturn;
    }
    
    public static String substring_orario(String timestamp){
        String toReturn="";
        if(timestamp!=null)
            toReturn=timestamp.substring(11,16);
        return toReturn;
    }
    
    public static String rimuovi_ultima_occorrenza(String stringa,String caratteri){
        String toReturn=stringa;
        if(stringa.contains(caratteri))
            toReturn=stringa.substring(0,stringa.lastIndexOf(caratteri));
        return toReturn;
    }
    
    public static boolean viene_prima_date(String date1,String date2){       
        String datetime1=date1+" 00:00:00";
        String datetime2=date2+" 00:00:00";
        boolean toReturn=false;        
        java.sql.Timestamp oldTime=Utility.converti_string_timestamp(datetime1);
        java.sql.Timestamp currentTime=Utility.converti_string_timestamp(datetime2);
        long milliseconds1 = oldTime.getTime();
        long milliseconds2 = currentTime.getTime();
        long diff = milliseconds2 - milliseconds1;        
        if(diff>=0)
            toReturn=true;
        return toReturn;
    }
    
    
    public static boolean viene_prima(String datetime1,String datetime2){       
         boolean toReturn=false;
        //System.out.println("data0==>"+data_ora_0);
        //System.out.println("data1==>"+data_ora_1);
        java.sql.Timestamp oldTime=Utility.converti_string_timestamp(datetime1);
        java.sql.Timestamp currentTime=Utility.converti_string_timestamp(datetime2);
        long milliseconds1 = oldTime.getTime();
        long milliseconds2 = currentTime.getTime();
        long diff = milliseconds2 - milliseconds1;        
        if(diff>=0)
            toReturn=true;
        return toReturn;
    }
    
    public static Timestamp converti_string_timestamp(String yourString){        
        Timestamp toReturn=null;        
        
        if(yourString.length()==10)
            yourString=yourString+" 00:00:000";
        if(yourString.length()==16)
            yourString=yourString+":000";        
        try {   
            toReturn=Timestamp.valueOf(yourString) ;
        } catch(Exception e) { 
            GestioneErrori.errore("Utility", "converti_string_timestamp", e);
        }
        return toReturn;
    }
    
    
    
}
