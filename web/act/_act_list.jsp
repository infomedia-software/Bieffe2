<%@page import="utility.Utility"%>
<%@page import="beans.Act"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneAct"%>
<%
    ArrayList<Act> lista=GestioneAct.getIstanza().ricerca(" act.stato='1' ");
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals(""))
        data=Utility.dataOdiernaFormatoDB();
    if(!id_act_res.equals(""))
        lista=GestioneAct.getIstanza().ricerca(" act.stato='1' AND act.id_act_res="+Utility.isNull(id_act_res)+" AND ( DATE(act.inizio)>="+Utility.isNull(data)+" OR DATE(act.fine)>="+Utility.isNull(data)+") ORDER BY act.inizio ASC");
%>

<div class="box">
    
    <%if(lista.size()==0){%>
        <div class="messaggio">Nessuna attività programmata</div>    
    <%}else{%>
        <table class="tabella">
            <tr>
                <th></th>        
                <th>Descrizione</th>        
                <th>Risorsa</th>
                <th>Durata</th>
                <th>Inizio</th>
                <th>Fine</th>
            </tr>
            <%for(Act act:lista){%>
                <tr>
                    <td>
                        <button class="pulsante_tabella" onclick="mostrapopup('<%=Utility.url%>/act/_programma_act.jsp?id_act=<%=act.getId()%>')">Programma</button>
                        <button class="pulsante_tabella">Dettagli</button>
                    </td>
                    <td><%=act.getDescrizione()%></td>
                    <td><%=act.getAct_res().getCodice()%> <%=act.getAct_res().getNome()%></td>
                    <td><%=act.getDurata_string()%></td>
                    <td><%=act.getInizio_string()%></td>
                    <td><%=act.getFine_string()%></td>
                </tr>
            <%}%>
        </table>
    <%}%>
</div>