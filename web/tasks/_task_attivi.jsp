<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<Task> task_attivi=GestioneSincronizzazione.getIstanza().elenco_task_attivi();
%>

<table class="tabella">
    <tr>
        <th>ID</th>
        <th>Fase</th>
        <th>Risorsa</th>
        <th colspan="2">Commessa</th>
        <th>Inizio</th>
        <th>Durata</th>        
        <th>Operatore</th>
        <th></th>
    </tr>
    <%for(Task task:task_attivi){%>
        <tr>
            <td><%=task.getId()%></td>
            <td title="ID: <%=task.getRisorsa().getId()%>&#10;Fase Produzione: <%=task.getRisorsa().getFasi_produzione()%>">
                <%=task.getRisorsa().getNome()%>
            </td>            
            <td>
                <%
                    ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.fasi_produzione LIKE "+Utility.isNullLike(task.getRisorsa().getFasi_produzione())+" and risorse.stato='1' ");
                    if(risorse.size()>0){
                        out.println(risorse.get(0).getNome());
                    }else{%>
                    <div class="tagsmall yellow">
                        <img src="<%=Utility.url%>/images/warning.png">
                    </div>
                    <%}
                %>
            </td>  
            <%if(!task.getCommessa().getDescrizione().equals("")){%>
                <td>
                    
                    <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=task.getCommessa().getNumero()%>' class="tag" style="background-color: <%=task.getCommessa().getColore()%>">
                        <%=task.getCommessa().getNumero()%> 
                    </a> 
                </td>
                <td>
                    <%=task.getCommessa().getSoggetto().getAlias()%> - <%=task.getCommessa().getDescrizione()%>                    
                </td>
            <%}%>            
            <td>
                <%if(!task.inizio_data().equals(Utility.dataOdiernaFormatoDB())){%>
                     <%=Utility.convertiDataFormatoIT(task.inizio_data())%>
                 <%}%>
                 <%=task.inizio_orario()%>
            </td>
            <td title="Durata Task:<%=task.getDurata()%> minuti&#10;Durata Arrot:<%=task.durata_arrotondata()%>">
                <%if(task.getDurata()!=-1){%>
                    <div class='tag'><%=task.durata_ore_minuti()%></div>
                <%}%>
            </td>                        
            <td><%=task.getNote()%></td>            
            <td>
                <a href='<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=task.getId()%>' class='pulsantesmall task float-right' target="_blank">
                    <img src="<%=Utility.url%>/images/task.png">                            
                </a>
            </td>
        </tr>
    <%}%>
</table>
