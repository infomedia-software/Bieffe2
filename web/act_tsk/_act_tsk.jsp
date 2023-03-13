<%@page import="beans.ActTsk"%>
<%@page import="gestioneDB.GestioneActTsk"%>
<%@page import="utility.Utility"%>

<%
    String id_act_tsk=Utility.eliminaNull(request.getParameter("id_act_tsk"));
    
    ActTsk act_tsk=GestioneActTsk.getIstanza().get_act_tsk(id_act_tsk);
%>

<div class="box">
    
    <button class="pulsante_tabella red float-right"><img src="<%=Utility.url%>/images/delete.png">Cancella</button>
    <%if(!act_tsk.is_concluso()){%>
        <button class="pulsante_tabella green float-right" onclick="stop_act_tsk('<%=id_act_tsk%>','si')"><img src="<%=Utility.url%>/images/v.png">Completata</button>
        <button class="pulsante_tabella color_orange float-right" onclick="stop_act_tsk('<%=id_act_tsk%>','')"><img src="<%=Utility.url%>/images/stop.png">Stop</button>    
    <%}%>
</div>

<div class="box">

    <div class="etichetta">Commessa</div>
    <div class="valore">
        <span>
            <div class="ball" style="background-color: <%=act_tsk.commessa_colore()%>"></div>
            <%=act_tsk.commessa_numero()%> <%=act_tsk.commessa_descrizione()%>
        </span>
    </div>      
</div>
    
<div class="box">
   
    <h3>Attività</h3>
    <div class="etichetta">Descrizione</div>
    <div class="valore"><span><%=act_tsk.getAct().getDescrizione()%></span></div>
    
    <div class="etichetta">Inizio / Fine</div>
    <div class="valore"><span><%=act_tsk.getAct().getInizio_string()%> / <%=act_tsk.getAct().getFine_string()%></span></div>
    
    <div class="etichetta">Durata</div>
    <div class="valore"><span><%=act_tsk.getAct().getDurata_string()%> h</span></div>
    

</div>


<div class="box">
    <h3>Task</h3>
    
    <div class="etichetta">Utente</div>
    <div class="valore"><span><%=act_tsk.getSoggetto().getCognome()%> <%=act_tsk.getSoggetto().getNome()%></span></div>
    
    <div class="etichetta">Inizio</div>
    <div class="valore"><span><%=act_tsk.getInizio_it()%></span></div>
    
    <%if(act_tsk.is_concluso()){%>
        <div class="etichetta">Fine</div>
        <div class="valore"><span><%=act_tsk.getFine_it()%></span></div>                
    <%}%>
        
    <div class="etichetta">Note</div>
    <div class="valore">
        <textarea id="note" onchange="modifica_act_tsk('<%=id_act_tsk%>',this)"><%=Utility.standardizzaStringaPerTextArea(act_tsk.getNote())%></textarea>
    </div>

</div>