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
    ArrayList<String> date=new ArrayList<String>();
    date.add(Utility.dataOdiernaFormatoDB());
    date.add(Utility.dataFutura(Utility.dataOdiernaFormatoDB(), 1));
    date.add(Utility.dataFutura(Utility.dataOdiernaFormatoDB(), 2));
    if(date.size()==0){%>
        <html>
            <head>
                <title>Monitor | <%=Utility.nomeSoftware%> </title>
                <jsp:include page="../_importazioni.jsp"></jsp:include>
            </head>
            <body>
                
                <div id="container">
                    <h1>Nessuna data configurata</h1>
                </div>
            </body>
        </html>
    <%
    return;
    }
    
    String stampa=Utility.eliminaNull(request.getParameter("stampa"));

    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals(""))
        data=date.get(0);
    
    Planning planning=GestionePlanning.getIstanza().getPlanning(data); 
    /** ** ** ** ** ** ** ** ** ** ** ** 
     *      Risorse in planning         *
     ** ** ** ** ** ** ** ** ** ** ** **/
    
    String queryrisorse=Utility.eliminaNull(request.getParameter("queryrisorse"));
    if(queryrisorse.equals(""))
        queryrisorse=" risorse.planning='si' AND risorse.stato='1' ORDER BY risorse.ordinamento ASC";

    String reparto=Utility.eliminaNull(request.getParameter("reparto"));
    if(!reparto.equals(""))        
        queryrisorse=" (risorse.reparti LIKE '%"+reparto+",%' OR risorse.reparti LIKE '%"+reparto+"') AND "+queryrisorse;    
    
    SortedMap<String,Risorsa> risorse_in_data=GestioneRisorse.getIstanza().ricerca_risorse_in_data(queryrisorse,data,"planning");
    
    ArrayList<Risorsa> risorse =GestioneRisorse.getIstanza().ricercaRisorse(queryrisorse);
    
    double numerorisorse=(double)100/((double)(risorse.size()+1));
    
    String w="calc("+numerorisorse+"% - 1px)";
    //String wattivita="calc("+numerorisorse+"% - 4px)";
    
    int hcella=21;
    
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
         <meta http-equiv="refresh" content="300">
        <title>Planning <%=Utility.convertiDataFormatoIT(data)%> | <%=Utility.nomeSoftware%> </title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
                
        <style type="text/css">
            
            #planning{
                width: 100%;
                height: 100%;
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
        
        <script type="text/javascript">
    
            function start(websocketServerLocation){
                 ws = new WebSocket(websocketServerLocation);
                 ws.onmessage = function(evt) { 
                     var messaggio=evt.data;                    
                     if(messaggio.includes("aggiorna_planning")){ 
                        $("#overlay").show();
                        setTimeout(function(){location.reload();}, 2500);
                     }
                 };
                 ws.onclose = function(){                      
                     setTimeout(function(){start(websocketServerLocation);}, 5000);
                 };
             }

             $(function(){
                 start("<%=Utility.socket_url%>");   
             });
    
            function refreshAt(hours, minutes, seconds) {
                var now = new Date();
                var then = new Date();

                if(now.getHours() > hours ||
                   (now.getHours() == hours && now.getMinutes() > minutes) ||
                    now.getHours() == hours && now.getMinutes() == minutes && now.getSeconds() >= seconds) {
                    then.setDate(now.getDate() + 1);
                }
                then.setHours(hours);
                then.setMinutes(minutes);
                then.setSeconds(seconds);

                var timeout = (then.getTime() - now.getTime());
                setTimeout(function() {                    
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/monitor/__aggiorna_monitor.jsp",
                        data: "",
                        dataType: "html",
                        success: function(msg){
                            window.location.reload(true);
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE di aggiorna monitor in monitor.jsp");
                        }
                    });                   
                }, timeout);
            }
            

            $(function(){
                refreshAt(00,01,00);                
            });
            
            
            // ***  CONTEXT MENU  *** //
            
            $(document).bind("contextmenu", function (event) {
                event.preventDefault(); 
                
                var t=event.pageY + "px";
                var l=event.pageX + "px";                                
                
                var classe=$(event.target).attr('class');                           
                
                
  
                
                if(classe.includes("attivita")){
                    $("#menu_attivita").finish().toggle(100).css({top: t,left: l});
                    
                    var id_attivita=$(event.target).children("#id_attivita").val();                                        
                    
                    if(classe==="attivita_handle" || classe==="attivita_descrizione")
                    
                    var completata=$("#attivita_"+id_attivita).children("#completata").val();                                        
                    if(completata==="si"){
                        $("#pulsante_attivita_completata").hide();
                    }else{
                        $("#pulsante_attivita_completata").show();
                    }
                    
                    var commessaselezionata=$("#attivita_"+id_attivita).children("#idcommessa").val();
                    $("#commessaselezionata").val(commessaselezionata);
                    
                    var attivitaselezionata=$("#attivita_"+id_attivita).children("#idattivita").val();
                    
                    $("#attivitaselezionata").val(attivitaselezionata);
                                       
                    
                }
        
                
              
            });  
                   
            $(document).bind("mousedown", function (e) {
                if (!$(e.target).parents(".custom-menu").length > 0) {
                    chiudi_context_menu();
                }
            });
            
            function chiudi_context_menu(){
                $("#cellaselezionata").val("");
                $("#risorsaselezionata").val("");
                $("#attivitaselezionata").val("");                 
                $(".custom-menu").hide(100);
            }  
                                    
            function apri_commessa(){
                var commessaselezionata=$("#commessaselezionata").val();
                location.href="<%=Utility.url%>/commesse/commessa.jsp?id="+commessaselezionata;
            }
                        
            function apri_attivita(){
                var attivitaselezionata=$("#attivitaselezionata").val();                                
                location.href="<%=Utility.url%>/attivita/_attivita.jsp?id="+attivitaselezionata;
            }
            
            function stampa_monitor(){
                window.print();
            }
        
    </script>

    </head>
    <body>
          
        <jsp:include page="../_popup.jsp"></jsp:include>
        
        <div id="overlay" style="position: fixed;top: 0;right: 0;left: 0;bottom:0;background-color: rgba(0,0,0,0.5);
             z-index: 99999999;text-align: center;color:white;font-size: 20px;">
            <img src="<%=Utility.url%>/images/loader.gif" alt="Loading" style="margin-top: 50px"/>
            <div class="clear"></div>
            Caricamento del Monitor in corso...
        </div>
 
     
        <!-- Attività-->
        <ul class='custom-menu' id="menu_attivita">  
            <li onclick="apriattivita()">
                <img src="<%=Utility.url%>/images/document.png" class="custom-menu-icon"> 
                Dettagli
            </li>    
        </ul>
        
        <div>
                                
            <%
                // Linea Temporale
                if(data.equals(Utility.dataOdiernaFormatoDB())){
                    int ora_corrente=Utility.ora_corrente();
                    int minuti_corrente=Utility.minuti_corrente();
                    int intestazione=123;
                    
                    int margin_celle_non_disponibili=2*(hcella+1)*inizio_ora;
                    if(inizio_minuti>=30)
                        margin_celle_non_disponibili=margin_celle_non_disponibili+(hcella+1);
                    
                    int margin_top=(ora_corrente*2)*(hcella+1);
                    if(minuti_corrente>=30)
                        margin_top=margin_top+(hcella+1);                    
                    margin_top=margin_top-margin_celle_non_disponibili+intestazione;                                        
                %>
                    <div class="no_print" style="width: 100%;height: 2px;background-color:red;position: fixed;z-index: 9999998;top:0px;margin-top:<%=margin_top%>px;" title="<%=margin_top%>">&nbsp;</div>
            <%}%>

            
            <div class='box no_print'>
                <div style="font-size: 24px;font-weight: bold;line-height: 40px">
                    <%=Utility.giornoDellaSettimana(data).toUpperCase()%> <%=Utility.convertiDataFormatoIT(data)%> <%if(!reparto.equals("")){%><%=GestioneReparti.getIstanza().ricerca(" reparti.id="+reparto).get(0).getNome()%><%}%>
                    <span style="font-size: 11px;font-style: italic;">
                        ultimo aggiornamento <%=Utility.convertiDatetimeFormatoIT(Utility.dataOraCorrente_String())%>
                    </span>
                    <div class="float-right">
                        <a href="<%=Utility.url%>" class="pulsante"><img src="<%=Utility.url%>/images/home.png">Home</a>
                        <button class="pulsante print" onclick="stampa_monitor()"><img src="<%=Utility.url%>/images/print.png">Stampa</button>
                        <button class="pulsante print" onclick="mostrapopup('<%=Utility.url%>/monitor/_stampa_monitor_risorse.jsp?data=<%=data%>')"><img src="<%=Utility.url%>/images/print.png">Stampa Risorse</button>
                        
                        <%for(String data_monitor:date){%>
                            <button class="pulsante color_eee" <%if(data_monitor.equals(data)){%> style="background-color:#F5B041 !important;color:white !important;" <%}%> onclick="location.href='<%=Utility.url%>/monitor/monitor.jsp?data=<%=data_monitor%>&reparto=<%=reparto%>'" class='<%if(data.equals(data_monitor)){%>monitor<%}%> float-left' style="margin-right: 5px; ">
                                <%=Utility.convertiDataFormatoIT(data_monitor)%>
                            </button>
                        <%}%>
                    </div>
               </div>
                <div style='display: none'>
                    <button onclick="window.open('<%=Utility.url%>/monitor/_stampa_monitor.jsp?data=<%=data%>','_blank')" >Stampa</button>
                </div>
            </div>  

                               
            <div class="height10"></div>
                
            <div id="planning" style="background-color: white;">
                <div id="planning_inner">                    
                
                    
                    <input type="hidden" id="dataprec" value="<%=Utility.dataFutura(data, -1)%>">
                    <input type="hidden" id="datasucc" value="<%=Utility.dataFutura(data, +1)%>">               
                        
                        
                    <!-- DEBUG -->
                    <div class="float-right"  style='position: fixed;bottom: 0px;right: 0;display: none;'>
                        Data 
                        <input type="text" value="<%=data%>">
                        <br>
                        Cella Selezionata
                        <input type="text" id="cellaselezionata" value="">
                        <br>
                        Attività Selezionata                        
                        <input type="text" id="attivitaselezionata" value="">
                        <br>
                        Commessa Selezionata                        
                        <input type="text" id="commessaselezionata" value="">
                        <br>
                        Risorsa selezionata
                        <input type="text" id="risorsaselezionata" value="">
                        <br>
                        Reparto selezionato
                        <input type="text" id="reparto" value="<%=reparto%>">
                        <br>
                        Da Incollare                        
                        <input type="text" id="daincollare" value="<%=daincollare%>">
                        <br>
                        Da Incollare Fase
                        <input type="text" id="daincollare_fase" value="<%=daincollare_fase%>">
                        <br>
                        Numero Risorse
                        <input type="text" id="numerorisorse" value="<%=risorse.size()%>">
                    </div>
                
                    <div class="clear"></div>
                
                    <!-- MARGIN TOP-->
                    <div style='position: fixed;top:65px;left:60px;'></div>
                    
                    <!-- ELENCO ORA -->
                    <div class="risorsa">
                        <div style="height: 40px;display: block;"></div>
                        <%
                        int indiceore=0;
                        for(int i=0;i<=48;i++){%>                                              
                            <%if(i>=numerocelleinizio && i<numerocellefine){%>
                                <div class="cella" style="line-height:<%=hcella%>px;text-align: center;border-bottom:1px solid lightgray;background-color: #eee;font-size: 10px;width: 100%;">
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
                                "ORDER BY attivita.inizio ASC");
                                        
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
                                    if(inizio_minuti>0)
                                        margintop=margintop-(hcella+1);
                                    if(attivita_inizio_minuti>0)
                                        margintop=margintop+(hcella+1);      
                                    if(!attivita.getInizioData().equals(data)){                     // Non inizia nel giorno corrente                                        
                                        inizio_giorno_prec=true;
                                        margintop=(hcella+1)*(risorsa_inizio_ora-inizio_ora)*2;
                                        if(inizio_minuti>0)
                                            margintop=margintop-(hcella+1);
                                        if(risorsa_inizio_minuti>0){
                                            margintop=margintop+(hcella+1);
                                        }
                                    }                                    
                                    
                                   
                                    
                                    String modificabile="";
                                    if(Utility.confrontaTimestamp(Utility.dataOraCorrente_String(), attivita.getInizio())>0){
                                        modificabile="no";
                                    }
                                      
                                    String title="ID: "+attivita.getId()+"&#10;"
                                            + "Commessa:"+attivita.getCommessa().getNumero()+"&#10;"
                                            + attivita.getCommessa().getSoggetto().getAlias()+"&#10;&#10;"
                                            + attivita.getDescrizione().replaceAll("<br>", "&#10;")+"&#10;";
                                    if(!attivita.getCommessa().getData_consegna().contains("0001"))
                                        title=title+"Data di Consegna: "+Utility.convertiDatetimeFormatoIT(attivita.getCommessa().getData_consegna()).substring(0,10)+"&#10;";
                                    title=title+attivita.getCommessa().getNote()+"&#10;";                                                                
                                    title=title+ Utility.convertiDatetimeFormatoIT(attivita.getInizio())+"&#10;"
                                            + Utility.convertiDatetimeFormatoIT(attivita.getFine())+"&#10;";                                    
                                    
                                    if(attivita.getDurata()>0)
                                        title=title+"Durata: "+Utility.formatta_durata(attivita.getDurata())+" h&#10;&#10;";
                                    if(!attivita.getNote().equals(""))
                                        title=title+"Note: "+attivita.getNote()+"&#10;";
                                    if(attivita.getRitardo()>0)
                                        title=title+"Ritardo: "+Utility.formatta_durata(attivita.getRitardo())+" &#10;";
                                    title=title+"Sequenza: "+attivita.getSeq()+"&#10;";
                                    if(attivita.getScostamento()>0)
                                        title=title+"Scostamento:"+ Utility.formatta_durata(attivita.getScostamento())+" h&#10;";                                    
                                    title=title+"&#10;Dettagli:"+attivita.getCommessa().getDettagli().replace("<br>", "&#10;")+"&#10;";
                                    title=title+"Task:" +Utility.eliminaNull(attivita.getTask());


                                    String data_consegna=Utility.eliminaNull(attivita.getCommessa().getData_consegna());
                                    if(!data_consegna.equals(""))
                                        data_consegna=data_consegna.substring(0,10);
                                %>
                                
                            
                                
                                <div title="<%=title%>" class="attivita <%if(attivita.getCompletata().equals("si")){%>attivita_completata<%}%>" 
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
                                    <input type="hidden" id="id_task" value="<%=attivita.getTask()%>">
                                    <input type="hidden" id="durata<%=attivita.getId()%>" value="<%=attivita.getDurata()%>">
                                    <input type="hidden" id="valore" value="<%=attivita.getId()%>">                                                                                    
                                    <input type="hidden" id="modificabile" value="<%=modificabile%>">
                                    <input type="hidden" id="completata" value="<%=attivita.getCompletata()%>">
                                    <input type="hidden" id="fasi_cat" value="<%=attivita.getFase_input().getId()%>">                                                                               
                                 
                                    <div class="durata" style="position: absolute">
                                        <%=Utility.formatta_durata(durata)%>
                                    </div>
                                    <%if(attivita.getAttiva().equals("si") ||  attivita.is_attiva_infogest()){%>
                                        <div class="attivo blink" style="position: absolute;right: 0px;">
                                            <img src='<%=Utility.url%>/images/v.png'>
                                        </div>
                                    <%}%>
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
                                                <%=attivita.getCommessa().getNumero()%><br>
                                            <%}%>                                                                        
                                            <%=attivita.getCommessa().getSoggetto().getAlias()%>                                            
                                            <br>                                            
                                            <%=attivita.getDescrizione()%>                      
                                            <br>                                            
                                            <%=Utility.convertiDataFormatoIT(data_consegna)%>
                                            <br>             
                                            <%if(!attivita.getNote().equals("")){%>
                                                <br><br>                                                                                        
                                                <%=attivita.getNote()%>             
                                            <%}%>
                                        </div>
                                        <div style="display: none;background-color: white;width: fit-content;width: calc(100% - 10px);margin:2.5px;padding: 2.5px;font-weight: bold;margin: auto;font-size: 11px">
                                            OPTIMUS 
                                            <%=Utility.eliminaNull(attivita.getFase_input().getCodice())%> <%=Utility.eliminaNull(attivita.getTask())%>
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
                                            <%if(i==lineatemporale && false){%>     // linea rossa nella cellas
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
            
        <script type="text/javascript">
            <%if(stampa.equals("si")){%>
                $(function(){
                    window.print();
                });
            <%}%>
        </script>
                
    </body>
</html>
