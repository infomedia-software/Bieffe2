<%@page import="gestioneDB.GestioneMonitor"%>
<%@page import="java.util.SortedMap"%>
<%@page import="java.util.TreeMap"%>
<%@page import="beans.Reparto"%>
<%@page import="gestioneDB.GestioneReparti"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.Utente"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.PlanningCella"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Planning"%>
<%@page import="gestioneDB.DBConnection"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    Utente utente=(Utente)session.getAttribute("utente");      
    ArrayList<String> date=GestioneMonitor.getIstanza().date_monitor();

    if(date.size()==0){%>
        <html>
            <head>
                <title>Monitor | <%=Utility.nomeSoftware%> </title>
                <jsp:include page="../_importazioni.jsp"></jsp:include>
            </head>
            <body>
                <jsp:include page="../_menu.jsp"></jsp:include>
                <div id="container">
                    <h1>Nessuna data configurata</h1>
                </div>
            </body>
        </html>
    <%
    return;
    }
    
    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals("")){
        data=date.get(0);
    }
    
    Planning planning=GestioneMonitor.getIstanza().monitor(data); 
 
    /** ** ** ** ** ** ** ** ** ** ** ** 
     *      Risorse in planning
     ** ** ** ** ** ** ** ** ** ** ** **/
    String queryrisorse=" risorse.planning='si' AND risorse.stato='1' ORDER BY risorse.ordinamento ASC";
    String reparto=Utility.eliminaNull(request.getParameter("reparto"));
    if(!reparto.equals(""))        
        queryrisorse=" (risorse.reparti LIKE '%"+reparto+",%' OR risorse.reparti LIKE '%"+reparto+"') AND "+queryrisorse;    
    SortedMap<String,Risorsa> risorse_in_data=GestioneRisorse.getIstanza().ricerca_risorse_in_data(queryrisorse,data);
    
    ArrayList<Risorsa> risorse =GestioneRisorse.getIstanza().ricercaRisorse(queryrisorse);
    
    double numerorisorse=(double)100/((double)(risorse.size()+1));
    
    String w="calc("+numerorisorse+"% - 1px)";
    //String wattivita="calc("+numerorisorse+"% - 4px)";
    
    int hcella=18;
    
    String daincollare=Utility.getIstanza().getValoreByCampo("attivita", "id", " stato='taglia'");
    String daincollare_fase="";
    if(!daincollare.equals("")){
        daincollare_fase=Utility.getIstanza().getValoreByCampo("attivita", "fase_input", " id="+daincollare);
    }
    
    String primoiniziodisponibile=Utility.getIstanza().querySelect("SELECT TIME(inizio) as primoinizio "
            + "FROM planning WHERE valore!='-1' AND "
            + "DATE(inizio)="+Utility.isNull(data)+" "
            + "ORDER BY fine ASC LIMIT 0,1", "primoinizio");
   
    int inizio_ora=0;
    int inizio_minuti=0;
    int numerocelleinizio=0;
    
    if(!primoiniziodisponibile.equals("")){
        String[] primoiniziodisponibile_array=primoiniziodisponibile.split(":");
        inizio_ora=Utility.convertiStringaInInt(primoiniziodisponibile_array[0]);
        inizio_minuti=Utility.convertiStringaInInt(primoiniziodisponibile_array[1]);
        numerocelleinizio=inizio_ora*2;
        if(inizio_minuti>0)
            numerocelleinizio=numerocelleinizio+1;
    }
    
    
    int fine_ora=0;
    int fine_minuti=0;
    int numerocellefine=0;
    
    String ultimafinedisponibile=Utility.getIstanza().querySelect("SELECT TIME(fine) as ultimafine "
            + "FROM planning WHERE "
            + "valore!='-1' AND DATE(fine)="+Utility.isNull(data)+" ORDER BY fine DESC LIMIT 0,1", "ultimafine");
    if(!ultimafinedisponibile.equals("")){        
        String[] ultimafinedisponibile_array=ultimafinedisponibile.split(":");
        fine_ora=Utility.convertiStringaInInt(ultimafinedisponibile_array[0]);
        fine_minuti=Utility.convertiStringaInInt(ultimafinedisponibile_array[1]);
        numerocellefine=fine_ora*2;
        if(fine_minuti>0)
            numerocellefine=numerocellefine+1;
    }

    String giorno_precedente="";
    if(Utility.confrontaDate(data,Utility.dataOdiernaFormatoDB())<0){
        giorno_precedente="si";
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Planning <%=Utility.convertiDataFormatoIT(data)%> | <%=Utility.nomeSoftware%> </title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
                
        <style type="text/css">
            
            body{
                margin: 0;
                padding:0;
                font-size: 11px;
            }
            #planning{
                width: 100%;
                height: 100%;
                overflow: hidden;
            }
                
            .risorsa{
                width: <%=w%>;
                height: 100%;
                border-right:1px solid #eee;
                float: left;                    
            }
            .intestazione{
                height: 40px;
                line-height: 13px;
                font-size: 11px;
                border-bottom:1px solid lightgray;
                background-color:#768799;
                color:white !important;
                text-align: center;
                position: fixed;
                width: <%=w%>;                
                z-index: 999;
                cursor: default;
                display: block;
                font-size: 10px;
                
            }         
            .attivita{         
                width:<%=w%>;                
                text-align: center;
                font-size: 11px;                   
                -webkit-border-radius: 1px;
                -moz-border-radius: 1px;
                border-radius: 1px;
                z-index: 2;
                position: absolute;
            }
            
            .attivita_handle{
                width: 100%;
                display: block;
                height: <%=hcella%>px;
                font-size: 11px;                                
                font-weight: 300;
                text-align: center;
                background-color:rgba(0,0,0,0.2);
                cursor: default;     
                color: white;     
                line-height: 22px;
            }

            .attivita_descrizione{
                font-size: 9px;
                margin: 5px;
                padding: 1px;
                background-color: white;
                color:black;
                width: calc(100% - 12px);
                font-weight: bold;
                cursor: default;
                overflow: hidden;
            }


            .cella, .cella_no_droppable{
                width:calc(<%=w%> - 1px);           
                background-color:transparent;
                height: <%=hcella%>px;
                line-height: <%=hcella%>px;
                cursor: default;
                text-align: center;                                
                border:none;
                border-bottom:1px solid lightgray;                                
                border-right:1px solid lightgray;                                
                
            }  
            
            .no-droppable{
                background-color:rgba(0,0,0,0.2) !important;
            }
            
        </style>
         
        <script type='text/javascript'>
            $(function(){
                window.print();
            });
        </script>
        
    </head>
    <body>
        
        <div id="container" style='margin-top: 0px'>
                                 
            <div id="planning" >
                <div id="planning_inner">
                    
                    <input type="hidden" id="dataprec" value="<%=Utility.dataFutura(data, -1)%>">
                    <input type="hidden" id="datasucc" value="<%=Utility.dataFutura(data, +1)%>">               
                        
            
                    <!-- ELENCO ORA -->
                    <div class="risorsa">
                        <div style="height: 40px;display: block;"></div>
                        <%
                        int indiceore=0;
                        for(int i=0;i<=48;i++){%>                                              
                            <%if(i>=numerocelleinizio && i<numerocellefine){%>
                                <div class="cella" style="line-height:<%=hcella%>px;text-align: center;border-bottom:1px solid lightgray;background-color: #eee;font-size: 8px;width: 100%;">
                                    <%if(i%2==0){%>
                                        <%=Utility.formattaOrario(indiceore, 0)%> - <%=Utility.formattaOrario(indiceore, 30)%>  
                                    <%}else{%>
                                        <%=Utility.formattaOrario(indiceore, 30)%> - <%=Utility.formattaOrario(indiceore+1, 0)%>  
                                    <%}%>
                                </div>
                            <%}
                            if(i%2!=0)
                                indiceore++;
                            %>
                        <%}%>
                    </div>


                    <!-- PLANNING -->
                    <%
                
                    boolean dataabilitata=false;    
                    boolean dataoccupata=false; 
                    
                    
                    
                    Map<String,ArrayList<Attivita>> mappa_attivita=GestionePlanning.getIstanza().mappa_attivita(
                            "(attivita.fine>='"+data+ " 00:00:00' AND attivita.inizio<='"+data+ " 23:59:59') AND "+                                
                                " attivita.stato='1' "+ 
                                "ORDER BY inizio ASC");
                                        
                    Calendar now = Calendar.getInstance();       
                    
                    for(Risorsa risorsa:risorse){
                        risorsa=risorse_in_data.get(risorsa.getId());
                        boolean risorsaoccupata=false;
                        boolean risorsaabilitata=false;
                        
                        
                        int risorsa_inizio_ora=0;
                        int risorsa_inizio_minuti=0;
                        if(!risorsa.getInizio().equals("")){
                            risorsa_inizio_ora=Utility.convertiStringaInInt(risorsa.getInizio().substring(11,13));                        
                            risorsa_inizio_minuti=Utility.convertiStringaInInt(risorsa.getFine().substring(14,16));
                        }
                        
                        
                        ArrayList<Attivita> listattivita=mappa_attivita.get(risorsa.getId());
                        if(listattivita==null)
                            listattivita=new ArrayList<Attivita>();
                    %>
                        
                        <div class="risorsa">
                            
                            <div class="intestazione" style="overflow: hidden;font-weight: bold;">
                                <input type="hidden" id="idrisorsa" value="<%=risorsa.getId()%>">                                
                                <input type="hidden" id="ordinamento" value="<%=risorsa.getOrdinamento()%>">                                
                                <%=risorsa.getFase().getNome()%>                                
                                <br>
                                <%=risorsa.getNome()%>                                                                
                            </div>
                            
                            <div style="height: 40px;"></div> <!-- div per sostituire intestazione fixed-->

                            <!----------------------------------------------------------------------------------------
                            
                                                            Elenco Attività
                            
                            ----------------------------------------------------------------------------------------->
                            <%                                

                            for(Attivita attivita:listattivita){
                                    boolean inizio_giorno_prec=false;
                                    double durata=attivita.getDurata();
                                    String colore=attivita.getCommessa().getColore();                                    
                                    
                                    
                                    risorsaoccupata=true;
                                    risorsaabilitata=true;
                                    dataabilitata=true;
                                    dataoccupata=true;       
                                    
                                    int celleoccupate=0;                                    
                                    if(!risorsa.getInizio().equals("") && !risorsa.getFine().equals(""))
                                        celleoccupate=attivita.contaCelleOccupate(data,risorsa.getInizio(),risorsa.getFine());
                                    
                                    
                                    int attivita_inizio_ora=attivita.getInizioOra();
                                    int attivita_inizio_minuti=attivita.getInizioMinuti();
                                    
                                    int margintop=(hcella+1)*(attivita_inizio_ora-inizio_ora)*2;
                                    if(attivita_inizio_minuti>0)
                                        margintop=margintop+(hcella+1);      
                                    if(!attivita.getInizioData().equals(data)){                     // Non inizia nel giorno corrente                                        
                                        inizio_giorno_prec=true;
                                        margintop=(hcella+1)*(risorsa_inizio_ora-inizio_ora)*2;
                                        if(risorsa_inizio_minuti>0){
                                            margintop=margintop+(hcella+1);
                                        }
                                    }                                    
                                    
                                   
                                    
                                    String modificabile="";
                                    if(Utility.confrontaTimestamp(Utility.dataOraCorrente_String(), attivita.getInizio())>0){
                                        modificabile="no";
                                    }
                                          
                                %>
                                
                            
                                
                                <div title="[ID: <%=attivita.getId()%>]<%=attivita.getCommessa().getNumero()%> 
<%=attivita.getCommessa().getSoggetto().getAlias()%>
<%=attivita.getDescrizione()%>
<%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%>
<%=Utility.convertiDatetimeFormatoIT(attivita.getFine())%>
Note:
<%=attivita.getNote().replaceAll("<br>", " ")%>

<%if(attivita.getDurata()>0){%>Durata: <%=Utility.formatta_durata(attivita.getDurata())%>h<%}%>
<%if(attivita.getRitardo()>0){%>Ritardo: <%=Utility.formatta_durata(attivita.getRitardo())%>h<%}%>
Sequenza: <%=attivita.getSeq()%>
" class="attivita <%if(attivita.getCompletata().equals("si")){%>attivita_completata<%}%>" 
                                id="attivita_<%=attivita.getId()%>"style="                                     
                                     background-color:<%=colore%>;                                     
                                     color:white !important;
                                     max-height:<%=celleoccupate*(hcella+1)%>px;
                                     min-height:<%=celleoccupate*(hcella+1)%>px;
                                     height:<%=celleoccupate*(hcella+1)%>px;
                                     margin-top:<%=margintop%>px;
                                     overflow: hidden !important;"
                                >
                                    <input type="hidden" id="id_attivita" value="<%=attivita.getId()%>">                                    
                                    <input type="hidden" id="idattivita" value="<%=attivita.getId()%>">
                                    <input type="hidden" id="idcommessa" value="<%=attivita.getCommessa().getId()%>">
                                    <input type="hidden" id="durata<%=attivita.getId()%>" value="<%=attivita.getDurata()%>">
                                    <input type="hidden" id="valore" value="<%=attivita.getId()%>">                                                                                    
                                    <input type="hidden" id="modificabile" value="<%=modificabile%>">
                                    <input type="hidden" id="completata" value="<%=attivita.getCompletata()%>">
                                    <input type="hidden" id="fasi_cat" value="<%=attivita.getFase_input().getId()%>">                                                                               
                                 
                                    
                                    <div class="durata" style="position: absolute">
                                        <%=Utility.formatta_durata(durata)%>
                                    </div>
                                    <%if(attivita.getCompletata().equals("si")){%>
                                        <div style="background-color:green;width: 20px;height: 20px;-webkit-border-radius: 18px;-moz-border-radius: 18px;border-radius: 18px;right: 0px;position: absolute">
                                            <img src="<%=Utility.url%>/images/v2.png" style="width: 18px;margin: 1px">                                        
                                        </div>
                                    <%}%>
                                        <%if(!giorno_precedente.equals("si")){
                                            if(inizio_giorno_prec==false){%>
                                                <div class="attivita_handle">                                                                                                           
                                                    <input type="hidden" id="id_attivita" value="<%=attivita.getId()%>">                                                                                    
                                                    <%=attivita.getCommessa().getNumero()%>                                    
                                                    <div class="clear"></div>
                                                </div>
                                            <%}%>
                                        <%}%>
                                        <div class='attivita_descrizione'>                                            
                                            <input type="hidden" id="id_attivita" value="<%=attivita.getId()%>">                                                                                    
                                            <%if(inizio_giorno_prec==true || giorno_precedente.equals("si")){%>
                                                <%=attivita.getCommessa().getNumero()%>
                                                <br>
                                            <%}%>                                                                                                                                                    
                                            <%=attivita.getCommessa().getSoggetto().getAlias()%>                                            
                                            <br>                                            
                                            <%=attivita.getDescrizione()%>                                            
                                        </div>  
                                        <%if(attivita.getRitardo()>0){%>
                                            <div class="ritardo">                                            
                                                <%=Utility.formatta_durata(attivita.getRitardo())%>
                                            </div>
                                        <%}%>
                                    
                                        <%if(Utility.compareTwoTimeStamps(attivita.getInizio(), attivita.getFine())>=0 || attivita.getInizio().equals(Utility.dadefinire) ||  attivita.getFine().equals(Utility.dadefinire)){%>
                                            <div style='color:red'>ERRORE!!!</div>
                                        <%}%>
                                </div>
                            <%
                            }
                        

                            int i=0;
                            
                            int lineatemporale=0;
                            if(Utility.confrontaDate(Utility.dataOdiernaFormatoDB(), data)==0){
                                int hour = now.get(Calendar.HOUR_OF_DAY);
                                lineatemporale=hour*2;
                                int minute = now.get(Calendar.MINUTE);
                                if(minute>30)
                                    lineatemporale++;
                            }
                            if(Utility.confrontaDate(Utility.dataOdiernaFormatoDB(), data)>0){
                                lineatemporale=50;
                            }   
                                                        
                            if(planning.celle(risorsa.getId()).size()>0){
                            
                                while(i<48){
                                    PlanningCella cella=planning.celle(risorsa.getId()).get(i);

                                    String valore=cella.getValore();

                                    String color="transparent";                
                                    risorsaabilitata=true;
                                    dataabilitata=true;
                                    if(cella.getValore().equals("-1"))
                                        color="rgba(158,180,204,1)";                                                                                                                           
                                    if(Utility.confrontaDate(Utility.dataOdiernaFormatoDB(),data)>0)
                                        valore="-2";
                                   //if(i<=lineatemporale)
                                   //    valore="-2";          
                                    
                                    

                                    if(i>=numerocelleinizio && i<numerocellefine){
                                        int margintop=(i-numerocelleinizio)*(hcella+1);
                                    %>
                                        <div class="
                                            cella
                                            <%=risorsa.getFasi_input().replaceAll(","," ")%>"
                                            style="
                                            <%if(valore.equals("-1")){out.print("z-index:3 !important;");}%>                                        
                                            <%if(valore.equals("-2")){out.print("z-index:1 !important;");}%>                                        
                                            background-color:<%=color%>;
                                            <%if(cella.getFineOra()==0){%>
                                                border-bottom:1px solid <%=color%>;
                                            <%}%>;                                    
                                            <%if(i==lineatemporale){%>
                                                border-bottom:1px solid red;
                                            <%}%>;                      
                                            position: absolute;
                                            margin-top:<%=margintop%>px
                                            ">        
                                            <input type="hidden" id="idcella" value="<%=cella.getId()%>" style="width: 40px;float: right;">                                                                        
                                            <input type="hidden" id="valore" value="<%=valore%>" style="width: 20px;float: right;">                                     
                                             
                                        </div>                                     
                                <%
                                    }
                                    i=i+1;                                
                                }
                            }
                            i=0;
                          %>
                          
                          <input type="hidden" id="risorsaoccupata<%=risorsa.getId()%>" value="<%=risorsaoccupata%>" readonly="true" tabindex="-1">
                          <input type="hidden" id="risorsaabilitata<%=risorsa.getId()%>" value="<%=risorsaabilitata%>" readonly="true" tabindex="-1">
                         
                    </div>
                    <%}%>
                    <div class="clear"></div>
                    <input type="hidden" id="dataabilitata" value="<%=dataabilitata%>">                    
                    <input type="hidden" id="dataoccupata" value="<%=dataoccupata%>">                    
                </div>
                
                
               
                
            </div>
                
            
            
            
            
            
                
        </div>
        
                
                
    </body>
</html>
