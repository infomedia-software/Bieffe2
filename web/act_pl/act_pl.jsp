<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.GestioneActTsk"%>
<%@page import="beans.ActTsk"%>
<%@page import="beans.Utente"%>
<%@page import="gestioneDB.GestioneActCal"%>
<%@page import="java.util.HashMap"%>
<%@page import="gestioneDB.GestioneActCel"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="beans.Act"%>
<%@page import="java.util.Map"%>
<%@page import="beans.ActRes"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    
    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals(""))data=Utility.dataOdiernaFormatoDB();
    Map<String,String> calendario=GestioneActCal.getIstanza().ricerca(" data>="+Utility.isNull(data)+" AND attivo='si' ORDER BY data ASC LIMIT 0,7");
    if(calendario.get(data)==null){
        response.sendRedirect(Utility.url+"/act_cal/act_cal.jsp");
        return;
    }
    
    
    Map<String,Integer> act_res_data_inizio_fine=GestioneActRes.getIstanza().act_res_data_inizio_fine(data);
    int inizio=act_res_data_inizio_fine.get("inizio");
    int fine=act_res_data_inizio_fine.get("fine");
    
    
    ArrayList<ActRes> act_res_list=GestioneActRes.getIstanza().act_res_utente(utente);

    Map<String,ArrayList<Act>> mappa_act=GestioneAct.getIstanza().act_data(data);
    Map<String,ActRes> mappa_ac_res=GestioneActRes.getIstanza().act_res_data(data);
    
    
    String id_act_da_programmare="";
    ArrayList<Act> lista_act_da_programmare=GestioneAct.getIstanza().ricerca(" act.inizio IS NULL AND act.fine IS NULL AND act.stato='1' ORDER BY act.data_modifica DESC");
    if(lista_act_da_programmare.size()>0){
        id_act_da_programmare=lista_act_da_programmare.get(0).getId();
    }
    
    
    

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Planning | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function cambia_giorno(){
                var giorno=$("#data").val();
                function_cambia_giorno(giorno);
            }            
            function function_cambia_giorno(giorno){
                location.href='<%=Utility.url%>/act_pl/act_pl.jsp?data='+giorno;   
            }
            
            $(document).bind("contextmenu", function (event) {
                event.preventDefault(); // Avoid the real one
                var classe=$(event.target).attr('class');                
                
                var t=event.pageY + "px";
                var l=event.pageX + "px";                                
                
                if(classe==="act_cel"){
                    var disponibile=$(event.target).attr("disponibile");
                    
                    if(disponibile==="si" || disponibile==="no"){
                        var ora=$(event.target).attr("ora");
                        var id_act_res=$(event.target).attr("id_act_res");                        
                        $("#ora").val(ora);
                        $("#id_act_res").val(id_act_res);
                        $("#menu_act_cel").finish().toggle(100).css({top: t,left: l});                                                                
                        if(disponibile==="si"){$("#attiva_act_cel").hide();$("#disattiva_act_cel").show();$("#incolla_act").show();}
                        if(disponibile==="no"){$("#attiva_act_cel").show();$("#disattiva_act_cel").hide();$("#incolla_act").hide();}                        
                    }                    
                    if(disponibile===""){
                        var id_act=$(event.target).attr("id_act");                                 
                        if(id_act!==undefined){
                            $("#id_act").val(id_act);
                            $("#menu_act").finish().toggle(100).css({top: t,left: l});                                                                                
                        }
                    }
                }
                if(classe==="act_list"){                                        
                    var id_act=$(event.target).attr("id_act");                                        
                    $("#id_act").val(id_act);                    
                }
                if(classe==="act_res"){                                        
                    var id_act_res=$(event.target).attr("id_act_res");                                                            
                    $("#id_act_res").val(id_act_res);      
                    $("#menu_act_res").finish().toggle(100).css({top: t,left: l});                                                                                
                }
            });  
                         
            $(document).bind("mousedown", function (e) {
                if (!$(e.target).parents(".custom-menu").length > 0) {
                    chiudi_context_menu();
                }
            });

            function chiudi_context_menu(){
                $(".custom-menu").hide(100);
            }        
            
            
            function seleziona_act_da_programmare(id_act){
                $(".act_da_programmare").removeClass("tr_selected");
                $("#act_da_programmare_"+id_act).addClass("tr_selected");
                $("#id_act_da_programmare").val(id_act);
            }
            
            function programma_act(){     
                mostraloader("Aggiornamento in corso...");
                var id_act_da_programmare=$("#id_act_da_programmare").val();                                                
                var id_act_res=$("#id_act_res").val();
                var ora=$("#ora").val();
                var data=$("#data").val();
                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act/__programma_act.jsp",
                    data: "id_act="+id_act_da_programmare+"&id_act_res="+id_act_res+"&data="+data+"&ora="+ora,
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                    }
                });
            }
         
            function incolla_act_prima_dopo(operazione){
                var id_act=$("#id_act").val();
                var id_act_incolla=$("#id_act_da_programmare").val();                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act/__incolla_act_prima_dopo.jsp",
                    data: "id_act_incolla="+id_act_incolla+"&operazione="+operazione+"&id_act="+id_act,
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE incolla_prima_dopo_act");
                    }
                });
            }
         
            function taglia_act(){
                mostraloader("Aggiornamento in corso...");
                var id_act=$("#id_act").val();
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act/__taglia_act.jsp",
                    data: "id_act="+id_act,
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE taglia_act");
                    }
                });		
            }
      
            function mostra_act(id_act){
                $("#scheda_act").load("<%=Utility.url%>/act/_act.jsp?id_act="+id_act);
            }
            
            function attiva_disattiva_act_cel(operazione){
                mostraloader("Aggiornamento in corso...");
                var id_act_res=$("#id_act_res").val();
                var ora=$("#ora").val();
                var data=$("#data").val();                                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_pl/__attiva_disattiva_act_cel.jsp",
                    data: "id_act_res="+id_act_res+"&data="+data+"&ora="+ora+"&operazione="+operazione,
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attiva_disattiva_act_cel");
                    }
                });
	
            }
            
            function start_act_tsk(){
                var id_act=$("#id_act").val();
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_tsk/__start_act_tsk.jsp",
                    data: "id_act="+id_act,
                    dataType: "html",
                    success: function(msg){                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE start_act_tsk");
                    }
                });
            }
            
            
            function modifica_orari_act_res(){
                var id_act_res=$("#id_act_res").val();
                var data=$("#data").val();                
                mostrapopup("<%=Utility.url%>/act_res/_modifica_orari_act_res.jsp?id_act_res="+id_act_res+"&data="+data);
            }
            
            function attivita_act(){
                var id_act_res=$("#id_act_res").val();
                var data=$("#data").val();   
                window.open("<%=Utility.url%>/act/_act_list.jsp?id_act_res="+id_act_res+"&data="+data,'_blank');
            }
            function stampa_attivita_act(){
                var id_act_res=$("#id_act_res").val();
                var data=$("#data").val();   
                window.open("<%=Utility.url%>/act/_act_list.jsp?stampa=si&id_act_res="+id_act_res+"&data="+data,'_blank');
            }

            function aggiorna_act_pl(){
                $("#div_act_pl").load("<%=Utility.url%>/act_pl/act_pl.jsp?data=<%=data%> #div_act_pl_inner",function(){nascondiloader();nascondipopup();});
            }
            
            function cancella_act(id_act){                
                if(confirm("Procedere alla cancellazione dell'act?")){
                    mostraloader("Cancellazione in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/act/__cancella_act.jsp",
                        data: "id_act="+id_act,
                        dataType: "html",
                        success: function(msg){
                            aggiorna_act_pl();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancella_act");
                        }
                    });
                }
            }
            
            
            function start(websocketServerLocation){
                ws = new WebSocket(websocketServerLocation);
                ws.onmessage = function(evt) { 
                    var messaggio=evt.data;                    
                    if(messaggio.includes("aggiorna_act_pl")){ 
                        aggiorna_act_pl();
                    }
                    if(messaggio.includes("start_act_tsk")){
                        aggiorna_act_pl();
                    }
                    if(messaggio.includes("stop_act_tsk")){                        
                        aggiorna_act_pl();
                    }
                };
                ws.onclose = function(){                      
                    setTimeout(function(){start(websocketServerLocation);}, 5000);
                };
            }

            $(function(){
                start("<%=Utility.socket_url%>");   
            });

            
            
        </script>
        
            
            
    </head>
    <body>
        
       
    <jsp:include page="../_loader.jsp"></jsp:include>
    <jsp:include page="../_popup.jsp"></jsp:include>
    
        
        
    <!-- MENU -->
    <div style="background-color: #2C3B50;width: calc(100% - 10px);padding: 5px;">                    
        <a href="<%=Utility.url%>"><img src="<%=Utility.url%>/images/infomedia cerchio.png" style="height: 35px;float: left;margin-right: 10px"></a>
        
        <input type="date" id="data" class="date"  value="<%=data%>" onchange="cambia_giorno()">
        
        
        <a class="pulsante risorse float-right" href='<%=Utility.url%>/act_res/act_res_list.jsp'><img src="<%=Utility.url%>/images/risorsa.png">Risorse</a>                                   
        <a class="pulsante task float-right" href='<%=Utility.url%>/act_tsk/act_tsk_list.jsp'><img src="<%=Utility.url%>/images/task.png">Task</a>                           
        <a class="pulsante print float-right" href='<%=Utility.url%>/act/_stampa_act_list.jsp?data=<%=data%>'><img src="<%=Utility.url%>/images/print.png">Stampa</a>                           
        <div style="color:white;float: right;margin-right: 10px;height: 40px;line-height: 40px;font-style: italic">
            Ciao, <%=utente.getNome()%> <%=utente.getCognome()%>
        </div>
        <div class="clear"></div>
    </div>
         
    <div class="height10"></div>
        
    <div id="div_act_pl">
        <div id="div_act_pl_inner">
                         
            
                <jsp:include page="../act_tsk/_act_tsk_attivi.jsp"></jsp:include>
            
                <!-- Menu Tasto destro--> 

                
                <%if(utente.is_ufficio()){%>
                    <!-- Act -->
                    <ul class='custom-menu' id="menu_act">                                                     
                        <li onclick="start_act_tsk()"><img src="<%=Utility.url%>/images/play.png" class="custom-menu-icon">Start</li>                                 
                    </ul>
                <%}%>
                
                <%if(utente.is_amministratore()){%>
                <!-- Act -->
                <ul class='custom-menu' id="menu_act">                                  
                    <li onclick="taglia_act()"><img src="<%=Utility.url%>/images/cut.png" class="custom-menu-icon">Taglia</li>                                 
                    <%if(!id_act_da_programmare.equals("")){%>
                        <li onclick="incolla_act_prima_dopo('prima')"><img src="<%=Utility.url%>/images/paste.png" class="custom-menu-icon">Programma Prima</li>                                 
                        <li onclick="incolla_act_prima_dopo('dopo')"><img src="<%=Utility.url%>/images/paste.png" class="custom-menu-icon">Programma Dopo</li>                                                        
                    <%}%>
                     <li onclick="start_act_tsk()"><img src="<%=Utility.url%>/images/play.png" class="custom-menu-icon">Start</li>                                 
                </ul>

                 <!-- Act -->
                <ul class='custom-menu' id="menu_act">                                  
                    <li onclick="taglia_act()"><img src="<%=Utility.url%>/images/cut.png" class="custom-menu-icon">Taglia</li>                                 
                    <%if(!id_act_da_programmare.equals("")){%>
                        <li onclick="incolla_act_prima_dopo('prima')"><img src="<%=Utility.url%>/images/paste.png" class="custom-menu-icon">Programma Prima</li>                                 
                        <li onclick="incolla_act_prima_dopo('dopo')"><img src="<%=Utility.url%>/images/paste.png" class="custom-menu-icon">Programma Dopo</li>                                                        
                    <%}%>
                     <li onclick="start_act_tsk()"><img src="<%=Utility.url%>/images/play.png" class="custom-menu-icon">Start</li>                                 
                </ul>

                <!-- ActCel -->
                <ul class='custom-menu' id="menu_act_cel">                  
                    <%if(!id_act_da_programmare.equals("")){%>
                        <li onclick="programma_act()" id="programma_act"><img src="<%=Utility.url%>/images/paste.png" class="custom-menu-icon">Programma</li>                                                 
                    <%}%>
                    <li onclick="attiva_disattiva_act_cel('attiva')" id="attiva_act_cel"> <img src="<%=Utility.url%>/images/abilita.png" class="custom-menu-icon">Attiva</li>                                                   
                    <li onclick="attiva_disattiva_act_cel('disattiva')" id="disattiva_act_cel"><img src="<%=Utility.url%>/images/disabilita.png" class="custom-menu-icon">Disattiva</li>                                                 
                </ul>

                <!-- ActRes-->
                 <ul class='custom-menu' id="menu_act_res">                  
                    <li onclick="modifica_orari_act_res()" > <img src="<%=Utility.url%>/images/setting.png" class="custom-menu-icon">Configura</li>                                                    
                    <li onclick="attivita_act()" > <img src="<%=Utility.url%>/images/list.png" class="custom-menu-icon">Attività su Risorsa</li>                                                    
                    <li onclick="stampa_attivita_act()" > <img src="<%=Utility.url%>/images/list.png" class="custom-menu-icon">Stampa Attività </li>                                                    
                 </ul>
            <%}%>
               
            
                <div style="position: fixed;right: 5px;bottom: 5px;background-color: #eee;display: none;">
                  id_act  <input type="text" id="id_act" value="">
                  <br>
                  id_act da programmare<input type="text" id="id_act_da_programmare" value="<%=id_act_da_programmare%>">
                  <br>
                  id_act_res <input type="text" id="id_act_res">            
                  <br>
                  ora<input type="text" id="ora">
                </div>

            
          
            
            <div style="width: 25%;background-color: #eee;float: right;min-height: 100%;">                
                <div id="scheda_act"></div>    
                <%if(utente.is_amministratore()){%>
                    <div class='box'>
                        <h2>Da Programmare</h2>
                        <%if(lista_act_da_programmare.size()==0){%>
                            <div class="messaggio">Nessuna attività da programmare</div>
                        <%}else{%>                            

                        <%for(Act act:lista_act_da_programmare){%>                                    
                        <div title="ID: <%=act.getId()%>" class="act_da_programmare cursor-pointer <%if(act.getId().equals(id_act_da_programmare)){%> tr_selected <%}%>" id="act_da_programmare_<%=act.getId()%>" onclick="seleziona_act_da_programmare('<%=act.getId()%>')" style="padding: 5px;margin: 5px;line-height: 16px">                                                                        
                                <div class="tag float-left" style="margin-right: 5px;background-color: <%=act.colore()%>;"><%=act.getCommessa().getNumero()%></div>                                
                                <button class="pulsantesmall delete float-right" value="-1" id="stato" onclick="cancella_act('<%=act.getId()%>')"><img src="<%=Utility.url%>/images/delete.png"></button>
                                <div class="clear"></div>
                                <b>
                                    <%=act.getCommessa().getDescrizione()%>
                                </b>
                                <br>
                                <%=act.cliente()%>
                                <br>
                                <%=act.getAct_ph().getNome()%> - <%=act.getDescrizione()%>
                                <div class="clear"></div>
                                <div class="tag color_eee float-left"><%=act.getDurata_string()%> h</div>                                                                
                                <div class="clear"></div>                                
                            </div>                                    
                        <%}%>
                            
                        <%}%>
                    </div>                        
                <%}%>                      
                                                                   
            </div>            
                    
            <div style="width: calc(75%);background-color: #eee;float: left;">
            
           
            
       
            <div class="tabs">
            
            <!-- ELENCO DATE -->
            <a class="tab color_orange <%if(data.equals(Utility.dataOdiernaFormatoDB())){%> tab2 <%}%>" onclick="function_cambia_giorno('<%=Utility.dataOdiernaFormatoDB()%>')"><%=Utility.giornoDellaSettimana(Utility.dataOdiernaFormatoDB())%> <%=Utility.convertiDataFormatoIT(Utility.dataOdiernaFormatoDB())%></a>                
            <%
                ArrayList<String> date = new ArrayList<String>(calendario.keySet());
                for(String data_temp:date){                    
                    if(!data_temp.equals(Utility.dataOdiernaFormatoDB())){%>
                        <a class="tab <%if(data.equals(data_temp)){%> tab2 <%}%> " onclick="function_cambia_giorno('<%=data_temp%>')"><%=Utility.giornoDellaSettimana(data_temp)%> <%=Utility.convertiDataFormatoIT(data_temp)%></a>                
                    <%}%>                
                <%}%>                
                <a class="tab lightgray" href='<%=Utility.url%>/act_cal/act_cal.jsp'>Calendario</a>                           
            </div>
            
            
            <!-- ELENCO ACT_RES -->
            
            
            <%for(ActRes act_res:act_res_list){
                String id_act_res=act_res.getId();
                ArrayList<Act> acts=mappa_act.get(act_res.getId());
                ActRes act_res_orari=mappa_ac_res.get(act_res.getId());                
            %>
                                                             
                    <div class="box">                     
                        <table class="tabella_act_res">
                            <tr>
                                <th colspan="6" class="act_res" id_act_res="<%=id_act_res%>">
                                    <%=act_res.getNome()%>
                                </th>                                
                                <%for(int i=inizio;i<fine;i++){%>
                                    <th style="font-size: 8px;">                                    
                                    <%=GestioneActCel.calcola_orario_act_cel_from_indice(i)%>                                    
                                    <br>
                                    <%=GestioneActCel.calcola_orario_act_cel_from_indice(i+1)%>
                                    </th>
                                <%}%>
                            </tr>
                            
                            <%
                            Map<Integer,Act> mappa_act_cel=new HashMap<Integer,Act>();
                            for(Act act:acts){%>
                                <tr onclick="mostra_act('<%=act.getId()%>')" class="cursor-pointer">
                                    <td class="act_list" id_act="<%=act.getId()%>" style="width: 100px;min-width: 100px;width: 100px;height: 20px">
                                        <div class="tag_tabella" style="background-color: <%=act.getCommessa().getColore()%>;color:white;">
                                            <%=act.getCommessa().getNumero()%>
                                        </div>
                                    </td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"><div><%=act.getCommessa().getDescrizione()%></div></td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"><div><%=act.getCommessa().getSoggetto().getAlias()%></div></td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"><div><%=act.getDescrizione()%></div></td>
                                    <td style="width: 50px;min-width: 50px;width: 50px">
                                        <span style="font-size: 10px; line-height: 12px;"><%=act.getInizio_string().replaceAll(Utility.convertiDataFormatoIT(data)+" ", "")%></span>
                                        <span style="font-size: 10px; line-height: 12px;"><%=act.getFine_string().replaceAll(Utility.convertiDataFormatoIT(data)+" ", "")%></span>
                                    </td>
                                    <td style="width: 35px;min-width: 35px;width: 35px">
                                        <span class="tag bold <%if(act.is_completata()){%> green <%}%> <%if(act.is_attiva()){%> blink <%}%>"><%=act.getDurata_string()%> h </span>
                                    </td>                                    
                                    <%for(int i=inizio;i<fine;i++){                                        
                                        String background_color="";
                                        String ora=GestioneActCel.calcola_orario_act_cel_from_indice(i);
                                        String valore=act_res_orari.get_cella(i);
                                        boolean is_lavorativa=true;                                        
                                        
                                        if(valore.equals("-1")){
                                            is_lavorativa=false;
                                            background_color="darkgray";
                                        }else{
                                            if(act.occupa_data_ora(data, ora) && is_lavorativa){background_color=act.colore();valore=act.getId();}                                    
                                            if(mappa_act_cel.get(i)==null && !background_color.equals(""))
                                                mappa_act_cel.put(i,act);                                        
                                        }
                                    %>
                                    <td class="act_cel" style="pointer-events: none;background-color: <%=background_color%>;border:1px solid transparent">&nbsp;</td>
                                    <%}%>
                                </tr>    
                                <%}%>
                                <tr>
                                    <td style="width: 100px;min-width: 100px;width: 100px"></td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"></td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"></td>
                                    <td style="width: 100px;min-width: 100px;width: 100px"></td>
                                    <td style="width: 50px;min-width: 50px;width: 50px"></td>
                                    <td style="width: 35px;min-width: 35px;width: 35px"></td>    
                                    <%for(int i=inizio;i<fine;i++){                                        
                                        String disponibile="";  
                                        String id_act="";  
                                        String background_color="";
                                        String ora=GestioneActCel.calcola_orario_act_cel_from_indice(i);
                                        String valore=act_res_orari.get_cella(i);                                        
                                        if(valore.equals("-1")){disponibile="no";background_color="darkgray";}                                        
                                        if(mappa_act_cel.get(i)!=null){id_act=mappa_act_cel.get(i).getId();background_color=mappa_act_cel.get(i).colore();}
                                        if(background_color.equals("") )disponibile="si";
                                    %>
                                        <td class="act_cel" style="border:1px solid #eee;border-top:2px solid #444;background-color: <%=background_color%>;" 
                                        id_act_res="<%=id_act_res%>" ora="<%=ora%>" disponibile="<%=disponibile%>" id_act="<%=id_act%>" title="<%=id_act%>">&nbsp;</td>
                                    <%}%>
                            </tr>                          
                        </table>                                                  
                    </div>
              <%}%>
            
        </div>        
        </div>    
    </div>
            
 
            
    </body>
</html>
