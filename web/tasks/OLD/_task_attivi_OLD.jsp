
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<Task> task_attivi=GestioneTasks.getIstanza().ricerca(" tasks.attivo='si' AND tasks.stato='1' ORDER BY tasks.id ASC ");
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
    <thead>
        <tr>
            <th>Risorsa</th>
            <th></th>                                        
            <th>Commessa</th>                                        
            <th>Avviato</th>
            <th>Durata<br>Task</th>
            <th>Durata<br>Attività</th>
            <th>Programmata</th>            
            <th></th>
            <th style="width: 40px"></th>
        </tr>
    </thead>
    <tbody>
        <%for(Task task:task_attivi){%>
        
            <tr>
                <td><%=task.getRisorsa().getNome()%></td>
                <td > 
                    <%if(!task.getAttivita().getId().equals("")){%>
                        <div class="tagsmall yellow float-left" style='background-color: <%=task.getCommessa().getColore()%>'></div>
                        
                    <%}%>
                </td>
                <td>
                    <b><%=task.getCommessa().getNumero()%> <%=task.getCommessa().getDescrizione()%></b> | <%=task.getCommessa().getSoggetto().getAlias()%>                    
                </td>    
                
                <!-- Task -->
                <td>
                    <%if(!task.inizio_data().equals(Utility.dataOdiernaFormatoDB())){%>
                        <%=Utility.convertiDataFormatoIT(task.inizio_data())%>
                    <%}%>
                    <%=task.inizio_orario()%>
                </td>
               
                <!-- Attività -->
                    <%if(task.getAttivita().getId().equals("")){%>
                        <td colspan="5">
                            <div class='tagsmall yellow float-left'   title="Impossibile trovare un'attività associabile nel planning">
                                <img src='<%=Utility.url%>/images/warning.png'>
                            </div>        
                        </td>
                    <%}else{%>                
                        <td>
                            <div class="tag" title="Somma delle durate dei sottotask letti da Optimus">
                                <%=Utility.converti_durata(task.getAttivita().getDurata_tasks())%>
                            </div>
                        </td>                       
                        <td>
                            <div class="tagsmall"><%=Utility.elimina_zero(task.getAttivita().getDurata())%> h</div>
                        </td>                        
                        <td>
                            <%=Utility.convertiDatetimeFormatoIT(task.getAttivita().getInizio())%>
                        </td>
                                                                                       
                        <td>
                            <!-- Attività programmata in orario differente dal task-->
                            <%
                            String cella_inizio_task=GestioneTasks.getIstanza().verifica_inizio_task_attivita(task);
                            if(!cella_inizio_task.equals("")){
                         %>
                            <button class="pulsantesmall planning float-left" onclick="riprogramma_attivita_da_task('<%=task.getAttivita().getId()%>','<%=cella_inizio_task%>')" title="Riprogramma l'attività in base al task corrispondente">
                                <img src="<%=Utility.url%>/images/planning.png">
                            </button>
                        <%}%>                           
                            <!-- Attività in ritardo rispetto al task-->
                            <%   
                                
                            if (task.getAttivita().getDurata_tasks() > task.getAttivita().getDurata()) {%>                                                                   
                            <%                                                                
                                String title_ritardo="";
                                int durata_attuale = (int) Utility.compareTwoTimeStamps(Utility.dataOraCorrente_String(), task.getInizio());
                                int hhh = durata_attuale / 60;
                                int mmm = durata_attuale % 60;
                                title_ritardo=hhh + ":" + mmm + "";
                            %>
                                <div class="tag"><%=title_ritardo%></div>
                                
                            <%int ritardo = (int) Utility.compareTwoTimeStamps(Utility.dataOraCorrente_String(), task.getAttivita().getFine());
                                int hhhh = ritardo / 60;
                                int mmmm = ritardo % 60;
                                double ritardo_task = hhhh;

                                if (mmmm > 0 && mmmm < 30) {
                                    ritardo_task = ritardo_task + 0.5;
                                }
                                if (mmmm >= 30) {
                                    ritardo_task = ritardo_task + 1;
                                }
                                title_ritardo=title_ritardo+"&#10;Ritardo: " + hhhh + " h " + mmmm + " m&#10;" + ritardo_task;
                            
                                if(ritardo_task>0){%>
                                    <button class="pulsantesmall red float-left " onclick="imposta_ritardo('<%=task.getAttivita().getId()%>','<%=ritardo_task%>')" title="<%=title_ritardo%>">
                                        <img src="<%=Utility.url%>/images/planning.png">
                                    </button>
                                <%}else{%>
                                    <div class="tagsmall" title="<%=title_ritardo%>"><%=title_ritardo%></div>
                                <%}%>
                            <%}%>                                                
                        </td>
                        <td>
                            <a href='<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=task.getId_esterno()%>' class='pulsantesmall task float-right' target="_blank">
                                <img src="<%=Utility.url%>/images/task.png">                            
                            </a>
                        </td>
                    <%}%>
            </tr>
        <%}%>
    </tbody>
</table>

<div class="clear"></div>
