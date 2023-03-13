<%@page import="beans.Act"%>
<%@page import="beans.ActTsk"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActTsk"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%
    String query=Utility.eliminaNull(request.getParameter("query"));    
    ArrayList<ActTsk> act_tsk_list=GestioneActTsk.getIstanza().ricerca(query);    
%>



<table class="tabella" >
    <tr>
        <th rowspan="2"></th>
        <th colspan="3" rowspan="2">Commessa</th>
        <th colspan="4">Attività</th>
        <th colspan="3">Task</th>        
    </tr>
    <tr>
        <th>Descrizione</th>        
        <th>Inizio</th>
        <th>Fine</th>
        <th>Durata</th>
        <th>Utente</th>        
        <th>Inizio</th>        
        <th>Fine</th>
    </tr>
    <%for(ActTsk act_tsk:act_tsk_list){        
        Act act=act_tsk.getAct();
    %>             
        <tr>
            <td>
                <button class="pulsante_tabella" onclick="mostrapopup('<%=Utility.url%>/act_tsk/_act_tsk.jsp?id_act_tsk=<%=act_tsk.getId()%>')"><img src="<%=Utility.url%>/images/edit.png">Dettagli</button>
            </td>
            <td> 
                <div class="tag_tabella" style="background-color: <%=act.getCommessa().getColore()%>;color:white;"><%=act.getCommessa().getNumero()%></div>
            </td>
            <td><%=act.getCommessa().getDescrizione()%></td>
            <td><%=act.getCommessa().getSoggetto().getAlias()%></td>
            <td><%=act.getDescrizione()%></td>
            <td style="width: 125px"><%=act.getInizio_string()%></td>
            <td style="width: 125px"><%=act.getFine_string()%></td>
            <td style="width: 125px"><%=act.getDurata_string()%> h</td>
            <td style="width: 125px">
                <%=act_tsk.getSoggetto().getCognome()%> <%=act_tsk.getSoggetto().getNome()%>
            </td>
            <td style="width: 125px">
                <%=act_tsk.getInizio_it()%>                
            </td>
            <td style="width: 125px">
                <%if(act_tsk.is_concluso()){%>                    
                    <%=act_tsk.getFine_it()%>                
                <%}%>
            </td>            
        </tr>           
    <%}%>    
</table>