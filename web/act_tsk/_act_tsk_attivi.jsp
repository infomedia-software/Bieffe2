<%@page import="utility.Utility"%>
<%@page import="beans.ActTsk"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActTsk"%>
<%@page import="beans.Utente"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");  
    ArrayList<ActTsk> act_tsk_attivi=GestioneActTsk.getIstanza().tsk_attivi_utente(utente);
%>

<script type="text/javascript">
      function stop_act_tsk(id_act_tsk,completata){
        $.ajax({
           type: "POST",
           url: "<%=Utility.url%>/act_tsk/__stop_act_tsk.jsp",
           data: "id_act_tsk="+id_act_tsk+"&completata="+completata,
           dataType: "html",
           success: function(msg){                        
               
           },
           error: function(){
               alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE start_tsk");
           }
       });
    }
    function modifica_act_tsk(id_act_tsk,inField){
        var new_valore=inField.value;
        var campo_da_modificare=inField.id;
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/act_tsk/__modifica_act_tsk.jsp",
            data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id_act_tsk="+id_act_tsk,
            dataType: "html",
            success: function(msg){
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_act_tsk");
            }
        });
    }
   
    $(function(){
        var today = new Date();
        var Christmas = new Date(today.getFullYear() + "-12-25");
        var diffMs = (Christmas - today); // milliseconds between now & Christmas
        var diffDays = Math.floor(diffMs / 86400000); // days
        var diffHrs = Math.floor((diffMs % 86400000) / 3600000); // hours
        var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000); // minutes
        $("#diff").html(diffHrs + "h - " + diffMins + " m ");
    });
   
</script>



<div onclick="$('#div_tsk_attivi').stop().slideToggle('slow')" style="position: fixed;left: 5px;bottom:0px;height: 20px;line-height: 20px;letter-spacing: 1px;color:white;padding: 5px;width: 100px;background-color: darkgray;z-index: 2;cursor: pointer;background-color: #267d98;-webkit-border-top-left-radius: 8px;
-webkit-border-top-right-radius: 8px;
-moz-border-radius-topleft: 8px;
-moz-border-radius-topright: 8px;
border-top-left-radius: 8px;
border-top-right-radius: 8px;text-align: center;" >
    <%=act_tsk_attivi.size()%> Task Attivi    
</div>


<div id="div_tsk_attivi"  style="position: fixed;height: 200px;bottom:5px;left:125px;z-index: 1;display: none" >
    
    <%for(ActTsk act_tsk:act_tsk_attivi){%>
        
        <div style="float: left;margin: 5px;background-color: #eee;padding: 5px;">
            
            <div class="blink" style="text-shadow: 2px 2px 4px black;font-weight: bold;float: left;width: 90px;height: 90px;line-height: 90px;text-align: center;background-color: <%=act_tsk.commessa_colore()%>;color:white;font-size: 20px;-webkit-border-radius: 100px;-moz-border-radius: 100px;border-radius: 100px;">
                <%=act_tsk.commessa_numero()%>
            </div>        
            <div style="float: right;">
                <button class="pulsante_tabella float-right" onclick="mostrapopup('<%=Utility.url%>/act_tsk/_act_tsk.jsp?id_act_tsk=<%=act_tsk.getId()%>')"><img src="<%=Utility.url%>/images/edit.png">Dettagli</button>
                <br>                                
                <button class="pulsante_tabella green float-right" onclick="stop_act_tsk('<%=act_tsk.getId()%>','si')"><img src="<%=Utility.url%>/images/v.png">Completata</button>
                <br>
                <button class="pulsante_tabella color_orange float-right" onclick="stop_act_tsk('<%=act_tsk.getId()%>','')"><img src="<%=Utility.url%>/images/stop.png">Stop</button>    
            </div>
            <div class="height5"></div>
            
            <div style="background-color: #abcfed;-webkit-border-radius: 3px;-moz-border-radius: 3px;border-radius: 3px;color:white;height: 20px;line-height: 20px;">
                <img src="<%=Utility.url%>/images/man.png" style="height: 18px;float: left;margin-right: 5px;margin-left: 2px;"> <%=act_tsk.getSoggetto().getCognome()%> <%=act_tsk.getSoggetto().getNome()%>
            </div>
            <div style="font-size: 12px;margin: 5px;"><%=act_tsk.commessa_descrizione()%></div>        
            <div style="font-size: 12px;margin: 5px;"><%=act_tsk.commessa_cliente()%></div>

            <div style="font-size: 11px;margin: 5px;"><%=act_tsk.getInizio_it()%></div>
            
            <div style="font-size: 11px;margin: 5px;" id="diff"></div>
        </div>
    <%}%>
</div>

