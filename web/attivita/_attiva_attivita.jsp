<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    Attivita attivita=GestionePlanning.getIstanza().get_attivita(id_attivita);
%>


<div class="box">
    <div class="etichetta">Commessa</div>
    <div class="valore">
        <span>
            <div class="ball" style="background-color: <%=attivita.getCommessa().getColore()%>"></div>
            <%=attivita.getCommessa().getNumero()%> <%=attivita.getCommessa().getSoggetto().getAlias()%> - <%=attivita.getCommessa().getDescrizione()%></span>
    </div>        

    <div class="etichetta" >Attività</div>
    <div class="valore"><span title="ID Attività: <%=attivita.getId()%>"><%=attivita.getDescrizione()%></span></div>     

    <div class="etichetta">Risorsa</div>
    <div class="valore"><span> <%=attivita.getRisorsa().getCodice()%> <%=attivita.getRisorsa().getNome()%></span></div>

    <div class="etichetta">Inizio / Fine / Durata</div>
    <div class="valore">
        <span style="width: 120px;float: left;"><%=attivita.getInizio_it()%></span> 
        <span style="width: 120px;margin-left: 10px;float: left;"><%=attivita.getFine_it()%></span>
        <span style="width: 120px;margin-left: 10px;float: left;"><%=Utility.elimina_zero(attivita.getDurata())%> h</span>
    </div>
    
    <div class="height10"></div>

    <%if(!attivita.is_attiva_infogest()){%>
        <button class="pulsantebig attiva float-right" onclick="modifica_attivita('<%=id_attivita%>',this)" id="attiva_infogest" value="si"><img src="<%=Utility.url%>/images/play.png">Attiva</button>       
    <%}else{%>
        <button class="pulsantebig green float-right" onclick="modifica_attivita('<%=id_attivita%>',this)" id="completata" value="si" ><img src="<%=Utility.url%>/images/v2.png">Completata</button>
        <button class="pulsantebig red float-right" onclick="modifica_attivita('<%=id_attivita%>',this)" id="attiva_infogest" value=""><img src="<%=Utility.url%>/images/stop.png">Disattiva</button>
    <%}%>
    
</div>