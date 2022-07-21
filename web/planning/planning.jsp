<%@page import="gestioneDB.GestioneOpzioni"%>
<%@page import="beans.OrdineFornitore"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
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
    
    
    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals(""))
        data=Utility.dataOdiernaFormatoDB();           
             
    if(!GestionePlanning.getIstanza().is_data_in_planning(data)){
        response.sendRedirect(Utility.url+"/planning/planning_old.jsp?data="+data);
        return;
    }
    
    String prima_data_planning=GestionePlanning.getIstanza().prima_data_planning();
    String ultima_data_planning=Utility.dataFutura(prima_data_planning, 60);
    int differenza_date=Utility.differenzaTimestamp(data+" 00:00:00",ultima_data_planning+" 00:00:00");
    
    if(differenza_date>0){
        response.sendRedirect(Utility.url+"/errore.jsp?messaggio=Impossibile procedere alla creazione del planning per la data specificata. <br>Data selezionata superiore all'ultima data del planning.");
        return;
    }
    
    String ULTIMO_AGGIORNA_PLANNING_OLD=Utility.getIstanza().getValoreByCampo("OPZIONI", "valori", " etichetta='ULTIMO_AGGIORNA_PLANNING_OLD'");
    if(!ULTIMO_AGGIORNA_PLANNING_OLD.equals(Utility.dataOdiernaFormatoDB()) || ULTIMO_AGGIORNA_PLANNING_OLD.equals("") ){
        response.sendRedirect(Utility.url+"/planning/aggiorna_planning_old.jsp");
    }
    
    // Reparto & Risorse
    String reparto=Utility.eliminaNull(request.getParameter("reparto"));    
    if(reparto.equals(""))  // se reparto è vuoto => carica il reparto standard
        reparto="2";
    String queryrisorse=" risorse.planning='si' AND risorse.stato='1' ORDER BY risorse.ordinamento ASC";
    if(!reparto.equals(""))        
        queryrisorse=" (risorse.reparti LIKE '%"+reparto+",%' OR risorse.reparti LIKE '%"+reparto+"') AND "+queryrisorse;    
        
    ArrayList<Risorsa> risorse =GestioneRisorse.getIstanza().ricercaRisorse(queryrisorse);    
    double numerorisorse=(double)100/((double)(risorse.size()+1));
    String w="calc("+numerorisorse+"% - 1px)";
    int hcella=21;
    
    String data_prec="";
    String data_succ="";
    
    // Planning
    Planning planning=null;
    SortedMap<String,Risorsa> risorse_in_data=null;
    String primoiniziodisponibile="";
    String ultimafinedisponibile="";
    
                                                                                                   // leggere da planning    
    planning=GestionePlanning.getIstanza().getPlanning(data);
    
    
    risorse_in_data=GestioneRisorse.getIstanza().ricerca_risorse_in_data(queryrisorse,data,"planning");
    primoiniziodisponibile=Utility.getIstanza().querySelect("SELECT TIME(inizio) as primoinizio "
        + "FROM planning WHERE valore!='-1' AND "
        + "DATE(inizio)="+Utility.isNull(data)+" "
        + "ORDER BY fine ASC LIMIT 0,1", "primoinizio");
    ultimafinedisponibile=Utility.getIstanza().querySelect("SELECT TIME(inizio) + INTERVAL 30 MINUTE as ultimafine "
        + "FROM planning WHERE "
        + "valore!='-1' AND DATE(inizio)="+Utility.isNull(data)+" ORDER BY fine DESC LIMIT 0,1", "ultimafine");

    data_prec=Utility.getIstanza().querySelect(" SELECT DATE(inizio) as data_prec FROM planning WHERE valore!='-1' AND DATE(inizio)<"+Utility.isNull(data)+" ORDER BY inizio DESC LIMIT 0,1", "data_prec");
    if(data_prec.equals(""))
        data_prec=Utility.dataFutura(data, -1);
    data_succ=Utility.getIstanza().querySelect(" SELECT DATE(inizio) as data_succ FROM planning WHERE valore!='-1' AND DATE(inizio)>"+Utility.isNull(data)+" ORDER BY inizio ASC LIMIT 0,1", "data_succ");
   
  
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
    if(!ultimafinedisponibile.equals("")){                
        if(ultimafinedisponibile.equals("00:00:00"))
            ultimafinedisponibile="24:00:00";                
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
    

    
    // Attività da Incollare
    String daincollare=Utility.getIstanza().getValoreByCampo("attivita", "id", " stato='taglia'");
    String daincollare_fase="";
    if(!daincollare.equals("")){
        daincollare_fase=Utility.getIstanza().getValoreByCampo("attivita", "fase_input", " id="+daincollare);
    }
    
    
    Map<String,Attivita> fine_attivita_commessa=GestionePlanning.getIstanza().fine_attivita_commessa("");    

    String PLANNING_CELLA_OPZIONE_1_COLORE=GestioneOpzioni.getIstanza().getOpzione("PLANNING_CELLA_OPZIONE_1_COLORE");
    String PLANNING_CELLA_OPZIONE_2_COLORE=GestioneOpzioni.getIstanza().getOpzione("PLANNING_CELLA_OPZIONE_2_COLORE");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Planning <%=Utility.convertiDataFormatoIT(data)%> | <%=Utility.nomeSoftware%> </title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
                
        <style type="text/css">
                
            .risorsa{
                width: <%=w%>;
                height: 100%;
                border-right:1px solid #eee;
                float: left;           
                -webkit-border-radius: 3px;
                -moz-border-radius: 3px;
                border-radius: 3px;
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
                cursor: move;     
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
            
            .debug{
                display: none;
            }
            
        </style>
        
        <script type="text/javascript">
         
         
         function start(websocketServerLocation){
            ws = new WebSocket(websocketServerLocation);
            ws.onmessage = function(evt) { 
                var messaggio=evt.data;                    
                if(messaggio.includes("aggiorna_planning")){ 
                    aggiornaplanning();
                }
            };
            ws.onclose = function(){                      
                setTimeout(function(){start(websocketServerLocation);}, 5000);
            };
        }

        $(function(){
            start("<%=Utility.socket_url%>");   
        });
         
        window.addEventListener('load',function(){
            $("#overlay").hide();
        });
       

    

        function seleziona_reparto(){
            mostraloader("Caricamento reparto in corso...");
            var reparto=$("#reparto_select").val();
            var data=$("#data").val();
            location.href='<%=Utility.url%>/planning/planning.jsp?data='+data+"&reparto="+reparto;
        }
           

             
        var cella_w="";
        $(function(){
            cella_w=$(".risorsa").width();                                            
            $("body").keydown(function(e) {                
                
                if(e.keyCode === 37) { // left
                    
                    mostraloader("Caricamento Planning in corso...");
                    modificadata("-1");
                }
                
                if(e.keyCode === 39) { // right
                    mostraloader("Caricamento Planning in corso...");
                    modificadata("+1");
                }
                if(e.keyCode === 121) { // debug
                    mostra_debug();
                }
            });
        });
            

        $(document).on('mouseenter', '.attivita', function (event) {   
            $(this).draggable({                        
                opacity: 0.6,   
                grid: [cella_w+1,<%=hcella+1%>],
                handle: ".attivita_handle",                                        
                stack: ".cella",                          
                zIndex: 1,
                revert: function(is_valid_drop){                        
                    if(is_valid_drop===false){
                        aggiornaplanning();
                    }

                },
                start: function(event, ui) { 
                    $(".cella").css("z-index","100");
                    var fasi_cat=$(this).find("#fasi_cat").val();                         
                    $("."+fasi_cat).addClass("droppable");                      // Rende droppable celle stessa fase
                    $(".cella:not(."+fasi_cat+")").addClass("no-droppable");     // Rende non droppable celle fasi differenti
                }                       
            });
        });

        $(document).on('mouseenter', '.droppable', function (event) {                         
            $(this).droppable({
                tolerance: "pointer",                        
                drop: function( event, ui ) {                    
                    var idattivita=ui.draggable.find("#idattivita").val();
                    var idcella=$(this).find("#idcella").val();                        
                    var valore=$(this).find("#valore").val();                        
                    //alert("ID ATTIVITA'>"+idattivita+"<\nID CELLA>"+idcella+"<\nVALORE>"+valore+"<");                        
                    mostraloader("Aggiornamento del Planning in corso...");                        
                    if(valore!=="-1" && valore!=='-2' && (valore==="1" || valore===idattivita)){
                        $.ajax({
                            type: "POST",
                            url: "<%=Utility.url%>/planning/__modificaplanning.jsp",
                            data: "idattivita="+idattivita+"&idcella="+idcella,
                            dataType: "html",
                            success: function(msg){
                                if(msg!=="")
                                    alert(msg);
                                aggiornaplanning();
                                chiudi_context_menu();
                            },
                            error: function(){
                                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE droppable()");
                            }
                        });
                    }else{
                        alert("Impossibile effettuare l'operazione sulla cella selezionata.");
                        aggiornaplanning();
                    }
                }
            });
        });
         
            
            function aggiorna_pagina(){
                aggiornaplanning();
            }
            
            function aggiornaplanning(){                
                mostraloader("Aggiornamento del Planning in corso...");
                var data=$("#data").val();                
                var reparto=$("#reparto").val();        
                $("#planning").load("planning.jsp?data="+data+"&reparto="+encodeURIComponent(String(reparto))+" #planning_inner",function(){
                    nascondiloader();                           
                    function_nascondipopup();
                    chiudi_context_menu();
                });                
            }
          
            
            // ***  CONTEXT MENU  *** //
            
            $(document).bind("contextmenu", function (event) {
                event.preventDefault(); 
                
                var t=event.pageY + "px";
                var l=event.pageX + "px";                                
                
                var classe=$(event.target).attr('class');                           
                
                if(classe==="intestazione"){
                    $("#menu_risorsa").finish().toggle(100).css({top: t,left: l});                    
                    
                    var risorsaselezionata=$(event.target).children("#idrisorsa").val();
                    $("#risorsaselezionata").val(risorsaselezionata);
                    
                    var ordinamento=parseInt($(event.target).children("#ordinamento").val());
                    var numerorisorse=parseInt($("#numerorisorse").val());
                    
                    $("#spostadx").hide();
                    $("#spostasx").hide();
                    if(ordinamento===0)
                        $("#spostasx").hide();
                    if(ordinamento===(numerorisorse-1))
                        $("#spostadx").hide();
                    
                }
                
                  
  
                
                if(classe.includes("attivita")){
                    $("#menu_attivita").finish().toggle(100).css({top: t,left: l});
                    
                    var id_attivita=$(event.target).children("#id_attivita").val();                                        
                    
                    var durata=parseFloat($("#durata"+id_attivita).val());                    
                    if(durata>0.5){
                        $(".pulsante_sposta_attivita").show();
                    }else{
                        $(".pulsante_sposta_attivita").hide();
                    }
                    if(durata<=1){
                        $(".pulsante_meno_1").hide();
                    }else{
                        $(".pulsante_meno_1").show();
                    }
                    
                    var completata=$("#attivita_"+id_attivita).children("#completata").val();  
                    if(completata==="si"){
                        $("#pulsante_attivita_completata").hide();
                        $("#pulsante_attivita_non_completata").show();
                    }else{
                        $("#pulsante_attivita_completata").show();
                        $("#pulsante_attivita_non_completata").hide();
                    }
                    
                    var bloccata=$("#attivita_"+id_attivita).children("#bloccata").val();                                        
                    if(bloccata==="si"){
                        $("#pulsante_blocca_attivita").hide();
                        $("#pulsante_sblocca_attivita").show();
                    }else{
                        $("#pulsante_blocca_attivita").show();
                        $("#pulsante_sblocca_attivita").hide();
                    }
                    
                    var commessaselezionata=$("#attivita_"+id_attivita).children("#idcommessa").val();
                    $("#commessaselezionata").val(commessaselezionata);
                    
                    var attivitaselezionata=$("#attivita_"+id_attivita).children("#idattivita").val();
                    
                    $("#attivitaselezionata").val(attivitaselezionata);

                    
                }
                if(classe.includes("cella") && classe.includes("attivita")===false){
                    var daincollare=$("#daincollare").val();
                    var daincollare_fase=$("#daincollare_fase").val();
                    
                    var cellaselezionata=$(event.target).children("#idcella").val();
                    $("#cellaselezionata").val(cellaselezionata);
                    var valore=$(event.target).children("#valore").val();                    
                    
                    
                    if(valore==="-1" || valore==="-2"){
                        $("#menu_cella").finish().toggle(100).css({top: t,left: l});
                        $(".abilitadisabilita").hide();
                        $("#abilita").show();
                    }
                    if(valore==="1"){
                        $("#menu_cella").finish().toggle(100).css({top: t,left: l});
                        $(".abilitadisabilita").hide();
                        $("#disabilita").show();                        
                        if(daincollare===""){
                            $("#incolla").hide();
                        }else{                            
                            if($(event.target).hasClass(daincollare_fase)){
                                $("#incolla").show();                                                
                            }else{
                                $("#incolla").hide();                                                
                            }
                        }                                                   
                    }
                  
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
            
            function abilitadisabilitadata(newvalore){
                var data_input=$("#data").val();
                if(confirm('Desideri procedere?')){
                     $.ajax({
                        type: "POST",
                        url: "__modificadata.jsp",
                        data: "data="+data_input+"&newvalore="+newvalore+"&campodamodificare=valore",
                        dataType: "html",
                        success: function(msg){
                            aggiornaplanning();
                            $("#cellaselezionata").val("");
                            chiudi_context_menu();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                        }
                    });	
                }
            }

            function nuovaattivita(){
                var cella=$("#cellaselezionata").val();
                mostrapopup("_nuovaattivita.jsp?cella="+cella,"Aggiungi Attività a Planning");                
            }
            
            
            function apricommessa(){
                var commessaselezionata=$("#commessaselezionata").val();
                window.open("<%=Utility.url%>/commesse/commessa.jsp?id="+commessaselezionata,"_blank");
            }
            
            
            function apriattivita(){
                var attivitaselezionata=$("#attivitaselezionata").val();                
                location.href="<%=Utility.url%>/attivita/_attivita.jsp?id="+attivitaselezionata;
            }
            
            function taglia(){
                var attivitaselezionata=$("#attivitaselezionata").val();                
                function_taglia(attivitaselezionata);
            }
            
          
            function da_programmare(){
                var attivitaselezionata=$("#attivitaselezionata").val();                
                function_da_programmare(attivitaselezionata);
            }
               
            function incolla(){
                var cellaselezionata=$("#cellaselezionata").val();
                var daincollare=$("#daincollare").val();                
                mostraloader("Aggiornamento Planning...");                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/planning/__incolla.jsp",
                    data: "idcella="+cellaselezionata+"&idattivita="+daincollare,
                    dataType: "html",
                    success: function(msg){
                        if(msg.includes("ERRORE")){
                            alert(msg);
                            nascondiloader();
                        }else{
                            aggiornaplanning();
                        }                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE incolla");
                    }
                });		
            }
            
            function attivita_completata(new_valore){
                var attivitaselezionata=$("#attivitaselezionata").val();
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                    data: "newvalore="+encodeURIComponent(String(new_valore))+"&campodamodificare=completata&idattivita="+attivitaselezionata,
                    dataType: "html",
                    success: function(msg){  
                        aggiornaplanning();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attivita_completata()" );
                    }
                });
            }
                
            function riprogramma_attivita_dopo_linea_temporale(){
                if(confirm("Riprogrammare l'attività spostandola dopo la linea temporale?")){
                    mostraloader("Riprogrammazione dopo la linea temporale in corso...");
                    var attivitaselezionata=$("#attivitaselezionata").val();                
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/planning/__riprogramma_attivita.jsp",
                        data: "id_attivita="+attivitaselezionata,
                        dataType: "html",
                        success: function(msg){  
                            aggiornaplanning();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE riprogramma_attivita()" );
                        }
                    });
                }
            }
            
            function mostra_programma_attivita(){                
                var attivitaselezionata=$("#attivitaselezionata").val();                               
                mostrapopup("<%=Utility.url%>/attivita/_programma_attivita.jsp?id_attivita="+attivitaselezionata);
                
            }
           
                
            function apririsorsa(){               
                var risorsaselezionata=$("#risorsaselezionata").val();
                window.open('<%=Utility.url%>/risorse/risorsa.jsp?id='+risorsaselezionata,'_blank');
            }
            
            
         
            
            function abilitadisabilitapiucelle(newvalore){                
                var cellaselezionata=$("#cellaselezionata").val(); 
                var temp=prompt("Numero celle a partire dalla selezionata?");
                if(!validazione_durata(temp)){
                    alert("Inserisci un numero");
                    return;
                }
                    
                if(temp!="" && temp!=null){ 
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/planning/__abilitadisabilitapiucelle.jsp",
                        data: "idcella="+cellaselezionata+"&newvalore="+newvalore+"&numerocelle="+temp,
                        dataType: "html",
                        success: function(msg){
                            aggiornaplanning();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE disabilitarisorsa");
                        }
                    });
                }
            }
            
                        
         
            function ordinamentorisorsa(spostamento){
                var risorsaselezionata=$("#risorsaselezionata").val();                                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/risorse/__ordinamentorisorsa.jsp",
                    data: "risorsa="+risorsaselezionata+"&spostamento="+spostamento,
                    dataType: "html",
                    success: function(msg){
                        aggiornaplanning();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE ordinamentorisorsa");
                    }
                });
               
            }
            
            function sposta_attivita(){
                var id_attivita=$("#attivitaselezionata").val();
                mostraloader("Operazione in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/planning/__modificaplanning.jsp",
                    data: "idattivita="+id_attivita,
                    dataType: "html",
                    success: function(msg){
                        if(msg!=="")
                            alert(msg);
                        aggiornaplanning();
                        chiudi_context_menu();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE droppable()");
                    }
                });
            }
            
            function modificadurata(valore){                
               var attivitaselezionata=$("#attivitaselezionata").val();
               mostrapopup("<%=Utility.url%>/attivita/_modifica_durata_attivita.jsp?id_attivita="+attivitaselezionata);
            }
            
            function imposta_ritardo(id_attivita,new_ritardo){
                mostraloader("Modifica del ritardo in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                    data: "newvalore="+encodeURIComponent(String(new_ritardo))+"&campodamodificare=ritardo&idattivita="+id_attivita,
                    dataType: "html",
                    success: function(msg){
                        if(msg!==""){
                            alert(msg);
                            nascondiloader();
                            return;
                        }
                        aggiornaplanning();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE imposta_ritardo()" );
                    }
                });
            }
          
            
            function modificasituazione(situazione){
                var attivitaselezionata=$("#attivitaselezionata").val();
                if(situazione==='completata'){
                    var newvalore="completata";
                    var campodamodificare="situazione";
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/planning/__modificaattivita.jsp",
                        data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&idattivita="+attivitaselezionata,
                        dataType: "html",
                        success: function(msg){
                            aggiornaplanning();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificaattivita()" );
                        }
                    });
                }
            }
            
            
            var mostra_attivita_completate="si";
            function mostra_nascondi_attivita_completate(){
                if(mostra_attivita_completate==="no"){                    
                    mostra_attivita_completate="si";
                    $(".attivita_completata").show();                    
                    $("#pulsante_mostra_nascondi_attivita_completate").removeClass("eee");
                    $("#pulsante_mostra_nascondi_attivita_completate").addClass("green");
                }else{
                    mostra_attivita_completate="no";
                    $(".attivita_completata").hide();
                    $("#pulsante_mostra_nascondi_attivita_completate").removeClass("green");
                    $("#pulsante_mostra_nascondi_attivita_completate").addClass("eee");
                }
            }
       
            function modifica_giorno(operazione){
                var data=$("#data").val();
                if(confirm("Procedere con "+operazione+" del "+data+"?")){
                    mostraloader("Operazione in corso...");
                    $.ajax({
                        type: "POST",
                        url: "__modifica_giorno.jsp?operazione="+operazione,
                        data: "data="+data,
                        dataType: "html",
                        success: function(msg){
                             location.href='<%=Utility.url%>/planning/planning.jsp?data='+data;
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_giorno()");
                        }
                    });
                }                    
            }
       
       function mostra_modifica_orari_risorsa(){
            var data=$("#data").val();
            var risorsa=$("#risorsaselezionata").val();                
            mostrapopup('<%=Utility.url%>/planning/_modifica_orari_risorsa.jsp?data='+data+'&risorsa='+risorsa);
        }
      
         
        function mostra_debug(){
            $(".debug").slideToggle();
        }
        
           
        function attivita_blocca_sblocca(blocca_sblocca){
            var attivitaselezionata=$("#attivitaselezionata").val();                
            var new_valore="";
            if(blocca_sblocca=="blocca"){
                new_valore="si";
            }                            
            mostraloader("Operazione di "+blocca_sblocca+" in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                data: "campodamodificare=bloccata&newvalore="+encodeURIComponent(String(new_valore))+"&idattivita="+attivitaselezionata,
                dataType: "html",
                success: function(msg){
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attivita_blocca_sblocca");
                }
            });	
        }
       
       function attivita_su_risorsa(){
            var risorsa=$("#risorsaselezionata").val(); 
            var query=" attivita.risorsa='"+risorsa+"' AND attivita.situazione='<%=Attivita.INPROGRAMMAZIONE%>' AND attivita.stato='1' AND (inizio>='<%=Utility.dataOraCorrente_String()%>' OR (inizio<='<%=Utility.dataOraCorrente_String()%>' AND fine>='<%=Utility.dataOraCorrente_String()%>' ))";
            window.open("<%=Utility.url%>/attivita/lista_attivita.jsp?query="+encodeURIComponent(String(query))+"&risorsa="+encodeURIComponent(String(risorsa)),"_blank");
       }
            
            
        function aggiorna_planning_old(){
            mostraloader("Aggiornamento Planning Old in corso");
            $.ajax({
                type: "POST",
                url: "__aggiorna_planning_old.jsp",
                data: "",
                dataType: "html",
                success: function(msg){
                    alert("Aggiornamento Planning Old effettuato correttamente");
                    nascondiloader();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE aggiorna_planning_old");
                }
            });
		
        }
           
           
        function sposta_giu(){
            mostraloader("Aggiornamento in corso...");
            var attivitaselezionata=$("#attivitaselezionata").val();            
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__sposta_giu.jsp",
                data: "id_attivita="+attivitaselezionata,
                dataType: "html",
                success: function(msg){
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                }
            });
        }
           
        function attivita_commessa(){
            var attivita_selezionata=$("#attivitaselezionata").val();            
            var commessa_selezionata=$("#commessaselezionata").val();            
            location.href='<%=Utility.url%>/attivita/attivita_commessa.jsp?id_commessa='+commessa_selezionata+"&id_attivita="+attivita_selezionata;
        }
        
        function mostra_modifica_cella(){
            var cella_selezionata=$("#cellaselezionata").val();            
            mostrapopup('<%=Utility.url%>/planning/_modifica_cella.jsp?id_cella='+cella_selezionata);
        }
           
        function abilita_disabilita_cella(new_valore){
            var cella_selezionata=$("#cellaselezionata").val();                        
            mostraloader("Aggiornamento in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__modifica_cella.jsp",
                data: "new_valore="+new_valore+"&id_cella="+cella_selezionata,
                dataType: "html",
                success: function(msg){
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                }
            });
        }
        
       function non_programmare(){
            var attivita_selezionata=$("#attivitaselezionata").val();            
            function_non_programmare(attivita_selezionata);
       }
           
    </script>

    </head>
    <body>
        
        <jsp:include page="../_loader.jsp"></jsp:include>
        <jsp:include page="../_popup.jsp"></jsp:include>
             
        <div id="overlay" style="position: fixed;top: 0;right: 0;left: 0;bottom:0;background-color: rgba(0,0,0,0.5);z-index: 10000;text-align: center;">
            <img src="<%=Utility.url%>/images/loader.gif" alt="Loading" />
            Loading...
        </div>
       
            
          
        <div id="planning"  style='background-color: white;'>
            <div id="planning_inner">
            
        
         <%if(!utente.getPrivilegi().equals("operaio")){%>
       
            <!-- Risorsa-->
            <ul class='custom-menu' id="menu_risorsa">                  
                <li onclick="mostra_modifica_orari_risorsa()" class="disabilitarisorsa">
                    <img src="<%=Utility.url%>/images/clock.png" class="custom-menu-icon">
                    Imposta Orari
                </li>                      
                <li onclick="apririsorsa()">
                    <img src="<%=Utility.url%>/images/risorsa.png" class="custom-menu-icon">
                    Risorsa
                </li>                     
                <li onclick="attivita_su_risorsa()">
                    <img src="<%=Utility.url%>/images/risorsa.png" class="custom-menu-icon">
                    Attività su Risorsa
                </li>                
                              
            </ul>

            <!-- Attività-->
            <ul class='custom-menu' id="menu_attivita">  
                <li onclick="apriattivita()">
                    <img src="<%=Utility.url%>/images/document.png" class="custom-menu-icon"> 
                    Dettagli
                </li>     
                <li onclick="apricommessa()">
                    <img src="<%=Utility.url%>/images/document.png" class="custom-menu-icon"> 
                    Commessa
                </li>     
                <li onclick="attivita_commessa()" class="pulsante_modifica_attivita">
                    <img src="<%=Utility.url%>/images/list.png" class="custom-menu-icon">
                    Attività Commessa
                </li>  
                
                <div class="separatore"></div>
             
                    <li onclick="taglia()" <%if(!daincollare.equals("")){%>style="display:none"<%}%> >
                        <img src="<%=Utility.url%>/images/cut.png" class="custom-menu-icon">
                        Taglia
                    </li>                      
                    <li onclick="mostra_programma_attivita()" >
                        <img src="<%=Utility.url%>/images/planning.png" class="custom-menu-icon">
                        Riprogramma 
                    </li>                                              
                    <li onclick="riprogramma_attivita_dopo_linea_temporale()" >
                        <img src="<%=Utility.url%>/images/planning.png" class="custom-menu-icon">
                        Riprogramma dopo linea temporale
                    </li> 
                    <div class="separatore"></div>
                    <li onclick="modificadurata('')" class="pulsante_modifica_attivita">
                        <img src="<%=Utility.url%>/images/clock.png" class="custom-menu-icon">
                        Imposta Durata
                    </li>                         
                    <%if(false){%>
                        <li onclick="modificadurata('+1')" class="pulsante_modifica_attivita ">
                            <img src="<%=Utility.url%>/images/add.png" class="custom-menu-icon">
                            +1 ora
                        </li>                                         
                        <li onclick="modificadurata('-1')" class="pulsante_modifica_attivita pulsante_meno_1">
                            <img src="<%=Utility.url%>/images/minus.png" class="custom-menu-icon">
                            -1 ora
                        </li>    
                    <%}%>
                    <div class="separatore"></div>
                    <li onclick="sposta_attivita()" class="pulsante_sposta_attivita">
                        <img src="<%=Utility.url%>/images/down.png" class="custom-menu-icon">
                        Sposta giù di 30 minuti
                    </li>    
                    <li onclick="sposta_giu()">
                        <img src="<%=Utility.url%>/images/down.png" class="custom-menu-icon ">
                        Libera Cella
                    </li>
                    <div class="separatore"></div>                   
              
                
           
                     <%if(!giorno_precedente.equals("si")){%>
                        <li onclick="da_programmare()" class="pulsante_modifica_attivita">
                            <img src="<%=Utility.url%>/images/planning.png" class="custom-menu-icon" >
                            Da Programmare
                        </li>     
                    <%}%>
              
           
                    <li onclick="attivita_blocca_sblocca('blocca')" style="display: none" id="pulsante_blocca_attivita_NO">
                        <img src="<%=Utility.url%>/images/lock.png" class="custom-menu-icon">
                        Blocca
                    </li>
                    <li onclick="attivita_blocca_sblocca('sblocca')" style="display: none" id="pulsante_sblocca_attivita_NO" >
                        <img src="<%=Utility.url%>/images/unlock.png" class="custom-menu-icon">
                        Sblocca
                    </li>
              
                <li onclick="attivita_completata('si')"  id="pulsante_attivita_completata" style="display: none">
                    <img src="<%=Utility.url%>/images/v2.png" class="custom-menu-icon ">
                    Completata
                </li>
                <li onclick="attivita_completata('')"  id="pulsante_attivita_non_completata" style="display: none">
                    <img src="<%=Utility.url%>/images/v2.png" class="custom-menu-icon ">
                    Non Completata
                </li>
                <div class="separatore"></div>                   
                <li onclick="non_programmare()">
                    <img src="<%=Utility.url%>/images/delete.png" class="custom-menu-icon ">
                    Non Programmare
                </li>
                <div class="separatore"></div>
               
                
            </ul>

            <!--Cella-->
            <ul class='custom-menu' id="menu_cella">                                
                <li onclick="incolla()" id="incolla" class="displaynone">
                    <span class="custom-menu-icon"><img src="<%=Utility.url%>/images/paste.png"></span>Incolla
                </li>                     
                <li onclick="mostra_modifica_cella()" class="displaynone">
                    <img src="<%=Utility.url%>/images/edit.png" class="custom-menu-icon" >
                    Modifica
                </li>                                        
                <li onclick="abilita_disabilita_cella('1')" class="abilitadisabilita" id="abilita" >
                    <img src="<%=Utility.url%>/images/play.png" class="custom-menu-icon" >
                    Abilita Orario
                </li>        
                <li onclick="abilita_disabilita_cella('-1')" class="abilitadisabilita" id="disabilita" >
                    <img src="<%=Utility.url%>/images/disabilita.png" class="custom-menu-icon" >
                    Disabilita Orario
                </li>                  

             </ul>
        <%}%>
        
        <%if(utente.getPrivilegi().equals("operaio")){%>
            <!-- Attività-->
            <ul class='custom-menu' id="menu_attivita">  
                <li onclick="apriattivita()">
                    <img src="<%=Utility.url%>/images/document.png" class="custom-menu-icon"> 
                    Dettagli
                </li>    
            </ul>
        <%}%>
            

                 

                <div style="background-color: #2C3B50;width: calc(100% - 10px);padding: 5px;">                    
                    <a href="<%=Utility.url%>"><img src="<%=Utility.url%>/images/infomedia cerchio.png" style="height: 35px;float: left;margin-right: 10px"></a>

                    <button class="pulsantesmall" onclick="modificadata('-1')"><img src="<%=Utility.url%>/images/left.png"></button>                
                        <input type="date" id="data" class="date float-left" value="<%=data%>" onchange="modificadata('')"  onkeydown="event.preventDefault()">
                    <button class="pulsantesmall float-left" onclick="modificadata('+1')"><img src="<%=Utility.url%>/images/right.png"></button>

                    <a href="<%=Utility.url%>/attivita/attivita_da_programmare.jsp" class="pulsante planning" >
                        <img src="<%=Utility.url%>/images/planning.png">
                        Da Programmare
                    </a>

                   
                    


                    <button class="pulsante green " onclick="mostra_nascondi_attivita_completate()" id="pulsante_mostra_nascondi_attivita_completate"><img src="<%=Utility.url%>/images/v2.png">Attività Completate</button>                           


                    <select id="reparto_select" onchange="seleziona_reparto()" class="select float-left" style="height: 35px">
                        <%for(Reparto r:GestioneReparti.getIstanza().ricerca("")){%>
                            <option value="<%=r.getId()%>" <%if(reparto.equals(r.getId()+"")){%>selected="true"<%}%> ><%=r.getNome()%></option>
                        <%}%>                    
                    </select>


                    <%if(!daincollare.equals("")){%>
                        <div class="da_incollare" >
                            <%
                                Attivita da_incollare=GestionePlanning.getIstanza().get_attivita(daincollare);
                                if(da_incollare!=null){%>
                                <a href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=da_incollare.getId()%>">
                                    <table>
                                        <tr>
                                            <td style="vertical-align: top">
                                                <div class="ball float-left" style="background-color:<%=da_incollare.getCommessa().getColore()%>"></div>
                                            </td>
                                            <td style="font-size: 9px;line-height: 10px">                                     
                                                <%=da_incollare.getCommessa().getNumero()%> <%=da_incollare.getCommessa().getSoggetto().getAlias()%> <%=da_incollare.getFase_input().getNome()%> 
                                                <br>
                                                <%=da_incollare.getDescrizione()%> - <%=Utility.elimina_zero(da_incollare.getDurata())%> h
                                            </td>                                       
                                        </tr>
                                    </table>
                                </a>
                                <%}
                            %>
                        </div>
                    <%}%>

                    <%if(giorno_precedente.equals("")){%>
                        <%if(inizio_ora==0 && inizio_minuti==0){%>                
                            <button class="pulsante float-right" onclick="modifica_giorno('abilita');">Abilita Giorno</button>                
                        <%}else{%>
                            <button class="pulsante float-right" onclick="modifica_giorno('disabilita');">Disabilita Giorno</button>                
                        <%}%>
                    <%}%>
                    <div class="clear"></div>
                </div>
                  
                <div class="height10"></div>
                    
                    <!-- DEBUG -->
                    <div class="float-right debug"  style='position: fixed;bottom: 0px;right: 0;display: none;z-index: 10000;background-color: #eee;padding: 10px;'>
                        Data Prec
                        <input type="text" id="dataprec" value="<%=data_prec%>">
                        <br>
                        Data Succ
                        <input type="text" id="datasucc" value="<%=data_succ%>">               
                        <br>                                                
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
                        <div class='height10'></div>
                        <button class='pulsante' onclick='aggiorna_planning_old();'>Aggiorna Planning Old</button>
                    </div>
                
                    <div class="clear"></div>
                    
                <%
                // Linea Temporale
                if(data.equals(Utility.dataOdiernaFormatoDB())){
                    int ora_corrente=Utility.ora_corrente();
                    int minuti_corrente=Utility.minuti_corrente();
                    int intestazione=110;
                    
                    int margin_celle_non_disponibili=2*(hcella+1)*inizio_ora;
                    if(inizio_minuti>=30)
                        margin_celle_non_disponibili=margin_celle_non_disponibili+(hcella+1);
                    
                    int margin_top=(ora_corrente*2)*(hcella+1);
                    if(minuti_corrente>=30)
                        margin_top=margin_top+(hcella+1);                    
                    margin_top=margin_top-margin_celle_non_disponibili+intestazione;                                        
                %>
                    <div style="width: 100%;height: 2px;background-color:red;position: absolute;z-index: 1000;top:0px;margin-top:<%=margin_top%>px;" title="<%=margin_top%>">&nbsp;</div>
                <%}%>
                  
                    
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
                                "attivita.stato='1' "+ 
                                "ORDER BY attivita.inizio ASC ");
                                        
                    Calendar now = Calendar.getInstance();       
                    
                    for(Risorsa risorsa:risorse){
                        risorsa=risorse_in_data.get(risorsa.getId());
                        boolean risorsaoccupata=false;
                        boolean risorsaabilitata=false;
                          
                        int risorsa_inizio_ora=0;
                        int risorsa_inizio_minuti=0;
                        if(!risorsa.getInizio().equals("")){
                            risorsa_inizio_ora=Utility.convertiStringaInInt(risorsa.getInizio().substring(11,13));                        
                            risorsa_inizio_minuti=Utility.convertiStringaInInt(risorsa.getInizio().substring(14,16));
                        }
                        
                        
                        
                        ArrayList<Attivita> listattivita=mappa_attivita.get(risorsa.getId());
                        if(listattivita==null)
                            listattivita=new ArrayList<Attivita>();
                    %>
                        
                        <div class="risorsa">
                            
                            <div class="intestazione" style="overflow: hidden;font-weight: bold;" title="[ID: <%=risorsa.getId()%>]&#10;Inizio: <%=Utility.convertiDatetimeFormatoIT(risorsa.getInizio())%>&#10;Fine:   <%=Utility.convertiDatetimeFormatoIT(risorsa.getFine())%>">
                                <input type="hidden" id="idrisorsa" value="<%=risorsa.getId()%>">                                
                                <input type="hidden" id="ordinamento" value="<%=risorsa.getOrdinamento()%>">                                                                                                
                                <span style="pointer-events: none;font-size: 9px;color:white;"><%=risorsa.getFase().getNome()%></span>
                                <%if(risorsa.getFasi_input().contains(daincollare_fase) && !daincollare.equals("")){%>                                
                                    <img src="<%=Utility.url%>/images/paste.png" style="position: absolute;width: 12px;bottom: 1px;right: 1px;">
                                <%}%>
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
                                    
                                    
                                    title=title+"Qtà: "+Utility.elimina_zero(attivita.getCommessa().getQta())+"&#10;";                         
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
                                        title=title+"Scostamento: "+ Utility.formatta_durata(attivita.getScostamento())+" h&#10;";                                    
                                    title=title+"&#10;Dettagli: "+attivita.getCommessa().getDettagli().replace("<br>", "&#10;")+"&#10;";
                                    if(!attivita.getTask().equals(""))
                                        title=title+"Task: " +Utility.eliminaNull(attivita.getTask())+"&#10;";
                                    if(attivita.getAttiva().equals("si"))
                                        title=title+"Attiva: " +Utility.eliminaNull(attivita.getAttiva());
                                    if(attivita.is_attiva_infogest())
                                        title=title+"Attiva Infogest: " +Utility.eliminaNull(attivita.getAttiva_infogest());
                                   

                                %>
                                
                            
                                
                                <div title="<%=title%>" 
                                    class="attivita <%if(attivita.getCompletata().equals("si")){%>attivita_completata<%}%>" 
                                id="attivita_<%=attivita.getId()%>" style="                                     
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
                                    <input type="hidden" id="bloccata" value="<%=attivita.getBloccata()%>">                                                                               
                                 
                                    <%                                        
                                        String fine_ultima_attivita="";
                                        Attivita attivita_finale=fine_attivita_commessa.get(attivita.getCommessa().getId());
                                        if(attivita_finale!=null)
                                            fine_ultima_attivita=attivita_finale.getFine();                                        
                                        if(!fine_ultima_attivita.equals(""))
                                            fine_ultima_attivita=fine_ultima_attivita.substring(0,10);                                        
                                    %>
                                    
                                    
                                    <div class="durata" style="position: absolute;<%if(!attivita.getTask().equals("")){%>border:2px solid orange;<%}%>">  
                                        <%=Utility.formatta_durata(durata)%>
                                    </div>
                                    
                                    <%if(attivita.getAttiva().equals("si") || attivita.is_attiva_infogest()){%>
                                        <div class="attivo attiva blink" style="position: absolute;right: 0px;">
                                            <img src='<%=Utility.url%>/images/v.png'>
                                        </div>
                                    <%}%>
                                    <%if(attivita.getCompletata().equals("si")){%>
                                        <div style="background-color:green;width: 20px;height: 20px;-webkit-border-radius: 18px;-moz-border-radius: 18px;border-radius: 18px;right: 0px;position: absolute">
                                            <img src="<%=Utility.url%>/images/v2.png" style="width: 18px;margin: 1px">                                        
                                        </div>
                                    <%}%>
                                    <%if(attivita.getBloccata().equals("si")){%>
                                        <div style="width: 20px;height: 20px;-webkit-border-radius: 18px;-moz-border-radius: 18px;border-radius: 18px;right: 0px;position: absolute">
                                            <img src="<%=Utility.url%>/images/lock.png" style="width: 10px;margin: 5px">                                        
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
                                            <%if(!attivita.getDescrizione().equals("")){%>
                                                <%=attivita.getDescrizione()%>      
                                            <%}else{%>
                                                <%=attivita.getCommessa().getDescrizione()%>      
                                            <%}%>
                                            <br>                         
                                            <%if(!attivita.getCommessa().getData_consegna().equals("")){%>
                                                <%=Utility.convertiDatetimeFormatoIT(attivita.getCommessa().getData_consegna()).substring(0,10)%>
                                                <br>
                                            <%}%>               
                                            <%if(!attivita.getNote().equals("")){%>
                                                <br>
                                                <%=attivita.getNote()%>
                                            <%}%>
                                        </div>  
                                        <%if(attivita.getRitardo()>0){%>
                                            <div class="ritardo">                                            
                                                <%=Utility.formatta_durata(attivita.getRitardo())%>
                                            </div>
                                        <%}%>
                                       
                                        <%
                                        int sequenza_int=(int)attivita.getSeq();
                                        double sequenza_double=attivita.getSeq()-sequenza_int;
                                        if(sequenza_double!=0){%>                                        
                                            <img src="<%=Utility.url%>/images/previous.png" style="width: 18px;" title="Sequenza: <%=attivita.getSeq()%>&#10;Fase: <%=attivita.getFase_input().getCodice()%>">
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
                                    String note=cella.stampa_note();
                                    String color="transparent";                
                                    risorsaabilitata=true;
                                    dataabilitata=true;
                                    if(cella.getValore().equals("-1"))
                                        color="rgba(158,180,204,1)";                                                                                                                           
                                    if(cella.getValore().equals("-1") && cella.getNote().contains("{PLANNING_CELLA_OPZIONE_1}")){
                                        color=PLANNING_CELLA_OPZIONE_1_COLORE;
                                    }
                                    if(cella.getValore().equals("-1") && cella.getNote().contains("{PLANNING_CELLA_OPZIONE_2}")){
                                        color=PLANNING_CELLA_OPZIONE_2_COLORE;                                        
                                    }
                                    //if(Utility.confrontaDate(Utility.dataOdiernaFormatoDB(),data)>0)
                                    //    valore="-2";
                                   //if(i<=lineatemporale)
                                   //    valore="-2";          
                                    

                                    if(i>=numerocelleinizio && i<numerocellefine){
                                        int margintop=(i-numerocelleinizio)*(hcella+1);
                                    %>
                                    <div 
                                            class=" cella <%=risorsa.getFasi_input().replaceAll(","," ")%>"
                                            style="overflow: hidden;
                                            <%if(valore.equals("-1")){out.print("z-index:3 !important;");}%>background-color:<%=color%>;
                                            <%if(cella.getFineOra()==0){%>border-bottom:1px solid <%=color%>;<%}%>;<%if(i==lineatemporale && false){%>border-bottom:1px solid red;<%}%>;position: absolute;
                                            margin-top:<%=margintop%>px;color:white;font-size:8px;" 
                                            title="<%=note%>">        
                                            <input type="hidden" id="idcella" value="<%=cella.getId()%>" style="width: 40px;float: right;">                                                                        
                                            <input type="hidden" id="valore" value="<%=valore%>" style="width: 20px;float: right;">                                     
                                            <%=note%>
                                            <span class="debug" style="background-color:#eee;position: absolute;z-index: 100000"><%=valore%></span>
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
             
            <div class='clear'></div>
                
    
                
                
    </body>
</html>
