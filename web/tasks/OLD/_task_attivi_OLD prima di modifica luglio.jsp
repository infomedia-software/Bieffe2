<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<Task> task_attivi=GestioneSincronizzazione.getIstanza().task_attivi_old();
%>

<script type="text/javascript">
    function riprogramma_attivita_da_task(id_attivita,id_cella){
        if(confirm("Procedere alla riprogrammazione dell'attività associata al task attivo?")){
            mostraloader("Riprogrammazione in corso da task...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__riprogramma_attivita.jsp",
                data: "id_attivita="+id_attivita+"&id_cella="+id_cella,
                dataType: "html",
                success: function(msg){  
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE riprogramma_attivita_da_task()" );
                }
            });
        }
    }
</script>


<table class="tabella">
    <tr>
        <th>Risorsa</th>
        <th colspan="2">Commessa</th>
        <th>Inizio</th>
        <th>Durata<br>Task</th>
        <th>Durata<br>Attività</th>
        <th colspan="3">Attività</th>
        <th></th>
        <th></th>
    </tr>
    <%for(Task task:task_attivi){%>
        <tr>
            <td><div class="tag" title="ID: <%=task.getRisorsa().getId()%>&#10;Fase Produzione: <%=task.getRisorsa().getFasi_produzione()%>"><%=task.getRisorsa().getNome()%></div></td>
            
            <%if(!task.getCommessa().getDescrizione().equals("")){%>
                <td>
                    <div class="tagsmall  float-left" style='background-color: <%=task.getCommessa().getColore()%>'></div>
                </td>
                <td> 
                    <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=task.getCommessa().getNumero()%>' style='font-weight: bold;'>
                        <%=task.getCommessa().getNumero()%> <%=task.getCommessa().getDescrizione()%>
                    </a> 
                    | 
                    <%=task.getCommessa().getSoggetto().getAlias()%>                    
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
            
            <%if(task.getAttivita()==null){%>
                <td colspan='1'>
                    <div class='tagsmall yellow margin-auto'   title="Impossibile trovare un'attività associabile nel planning">
                        <img src='<%=Utility.url%>/images/warning.png'>
                    </div>        
                </td>
                <td colspan="3"></td>
            <%}%>
            <%if(task.getAttivita()!=null){%>
            
                <%if(!task.getAttivita().getSituazione().equals(Attivita.INPROGRAMMAZIONE)){%>
                    <td colspan='4'>
                        <div class='tagsmall float-left yellow'   title="Attività importata ma non programmata">
                            <img src='<%=Utility.url%>/images/warning.png'>
                        </div>        
                    </td>
                <%}else{%>               
                    <td>
                        <div class='tagsmall'><%=Utility.elimina_zero(task.getAttivita().getDurata())%> h</div>
                    </td>   
                    <td>    
                        <div title='ID: <%=task.getAttivita().getId()%>&#10;<%=task.getAttivita().getSituazione()%>'>
                            <%=task.getAttivita().getDescrizione()%>                    
                            <br>
                            <%=Utility.convertiDatetimeFormatoIT(task.getAttivita().getInizio())%>
                        </div>
                    </td>

                    <td>
                    <!-- Attività programmata in orario differente dal task-->
                        <%
                        String cella_inizio_task=GestioneTasks.getIstanza().verifica_inizio_task_attivita(task);
                        if(!cella_inizio_task.equals("")){%>
                            <button class="pulsantesmall planning" onclick="riprogramma_attivita_da_task('<%=task.getAttivita().getId()%>','<%=cella_inizio_task%>')" title="Riprogramma l'attività in base al task corrispondente">
                                <img src="<%=Utility.url%>/images/planning.png">
                            </button>                    
                        <%}%>
                    </td>
                    <!-- Attività in Ritardo -->              
                      <td>
                        <%
                        double ritardo=task.durata_arrotondata() - task.getAttivita().getDurata(); 
                        if(ritardo>0 && cella_inizio_task.equals("")){%>
                            <button class="pulsantesmall red " 
                                    onclick="imposta_ritardo('<%=task.getAttivita().getId()%>','<%=Utility.elimina_zero(ritardo)%>')" 
                                    title="L'attività in planning risulta essere in ritardo di <%=Utility.elimina_zero(ritardo)%> h">
                                <img src="<%=Utility.url%>/images/planning.png">
                            </button>
                        <%}%>
                    </td>
                <%}%>
            <%}%>
            <td><%=task.getNote()%></td>            
            <td>
                <a href='<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=task.getId()%>' class='pulsantesmall task float-right' target="_blank">
                    <img src="<%=Utility.url%>/images/task.png">                            
                </a>
            </td>
        </tr>
    <%}%>
</table>
