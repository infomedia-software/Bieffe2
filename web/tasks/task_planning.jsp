 <%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    
    String prima_data_planning=Utility.getIstanza().querySelect("SELECT DATE(min(inizio)) as prima_data_planning FROM planning WHERE 1 ORDER BY inizio DESC LIMIT 0,1", "prima_data_planning");
    
    // Elimina le attività con durata pari a 0 => possono creare problemi    
    Utility.getIstanza().query("UPDATE attivita SET stato='-1' WHERE ore=0 AND minuti=0 AND stato='1' AND id_ordine_fornitore=''");
    
    ArrayList<Attivita> attivita_completate=GestionePlanning.getIstanza().ricercaAttivita( " "
            + "attivita.completata='SI_ATTESA' AND attivita.stato='1' AND attivita.durata_tasks>0 AND attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" "
                    + "ORDER BY attivita.inizio_tasks ASC, attivita.commessa ASC,attivita.seq ASC");
    
    ArrayList<Attivita> lista_attivita=GestionePlanning.getIstanza().ricercaAttivita(" "
            + " ((DATE(attivita.inizio)>="+Utility.isNull(prima_data_planning)+" AND "
            + " DATE(attivita.inizio)!="+Utility.isNull("3001-01-01")+" AND  DATE(attivita.inizio_tasks)!="+Utility.isNull("3001-01-01")+"    "            
            + " AND ( TIMESTAMPDIFF(MINUTE,attivita.inizio,attivita.inizio_tasks)>30 OR TIMESTAMPDIFF(MINUTE,attivita.inizio,attivita.inizio_tasks)<-30) "
            + " AND attivita.completata!='si' AND attivita.completata!='ignora' AND attivita.completata!='SI_ATTESA') OR attivita.attiva='si') AND attivita.stato='1' "
            + " AND attivita.completata!='ignora' "             
            + "ORDER BY attivita.inizio_tasks ASC, attivita.commessa ASC,attivita.seq ASC");
    
    
%>

<script type="text/javascript">

    function mostra_riprogramma_attivita(id_attivita){
        nascondipopup();
        mostrapopup("<%=Utility.url%>/planning/_riprogramma_attivita.jsp?id_attivita="+id_attivita,"Riprogramma Attività");
    }
    
    
    function attivita_completata(id_attivita){         
        var old_durata=$("#old_durata_"+id_attivita).val();
        var new_durata=$("#new_durata_"+id_attivita).val();
        if(validazione_durata(new_durata)===false){                       
            alert("La durata inserita non è corretta.");
            return;
        }
        mostraloader("Aggiornamento in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
            data: "campodamodificare=completata&newvalore=si&idattivita="+id_attivita,
            dataType: "html",
            success: function(){
                if(old_durata!==new_durata){
                    $.ajax({
                       type: "POST",
                       url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                       data: "campodamodificare=durata&newvalore="+new_durata+"&idattivita="+id_attivita,
                       dataType: "html",
                       success: function(){
                           aggiornaplanning();
                       },
                       error: function(){
                           alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attivita_completata parte 2");
                       }
                    });
                }else{
                    aggiornaplanning();
                }
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attivita_completata parte 1");
            }
        });
    }
    
    function trova_task_da_attivita(id_attivita,commessa,fase){
        mostraloader("Ricerca in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/tasks/_trova_task_da_attivita.jsp",
            data: "id_attivita="+id_attivita+"&commessa="+commessa+"&fase="+fase,
            dataType: "html",
            success: function(msg){
                if(msg==="ok"){
                    alert("Task trovato! L'attività è stata correttamente aggiornata");                    
                }else{
                    alert("Nessun task trovato!");
                }
                $("#div_task_planning").load("<%=Utility.url%>/tasks/task_planning.jsp #div_task_planning_inner",function(){nascondiloader();})
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE trova_task_da_attivita");
            }
        });
    } 
</script>
    
    <div id="div_task_planning">
        <div id="div_task_planning_inner">
            
            <table class="tabella">
                <tr>
                    <th>Fase</th>
                    <th>Risorsa</th>                    
                    <th colspan="4">Attività</th>
                    <th style="width: 150px">Inizio<br>da Planning</th>
                    <th style="width: 150px">Inizio<br>da Optimus</th>
                    <th>Durata<br>Attività</th>
                    <th>Durata<br>Task</th>                    
                    <th>Durata<br>Finale</th>
                    <th></th>
                </tr>
                <%for(Attivita attivita:attivita_completate){
                    double durata_sottostask_arrotondata=attivita.durata_tasks_arrotondata();
                %>
                <tr>
                    <td>
                        <%=attivita.getFase_input().getCodice()%>
                    </td>
                    <td>
                        <%=attivita.getRisorsa().getNome()%>
                    </td>                    
                    <td>
                        <button class='pulsantesmall' title="Id Attività: <%=attivita.getId()%> - Id Task: <%=attivita.getTask()%>" onclick="mostrapopup('<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita.getId()%>','Attività [ID: <%=attivita.getId()%>]')"> 
                            <img src='<%=Utility.url%>/images/edit.png'>
                        </button>
                    </td>
                    <td>                        
                        <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=attivita.getCommessa().getId()%>' class="tag" style="background-color:<%=attivita.getCommessa().getColore()%>" style="min-width: 100px" target="_blank">
                            <%=attivita.getCommessa().getNumero()%>
                        </a>
                    </td>
                    <td>
                        <%=attivita.getCommessa().getSoggetto().getAlias()%> 
                    </td>
                    <td title='ID Attività: <%=attivita.getId()%>'>
                        <%=attivita.getCommessa().getDescrizione()%>
                    </td>
                    <td>
                        <%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%>
                    </td>
                    <td>
                        <%=Utility.convertiDatetimeFormatoIT(attivita.getInizio_tasks())%>
                    </td>
                    <td>
                        <input type="hidden" id="old_durata_<%=attivita.getId()%>" value="<%=attivita.getDurata()%>" readonly="true" tabindex="-1">
                        <div class="tagsmall"><%=Utility.elimina_zero(attivita.getDurata())%> h</div>
                    </td>
                    <td>                                                
                        <a target="_blank" href="<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=attivita.getTask()%>" 
                            class="tagsmall task <%if(attivita.durata_tasks_arrotondata()>attivita.getDurata()){%>red<%}%>" 
                            title="Task: <%=attivita.getTask()%>&#10;Durata: <%=attivita.getDurata_tasks()%> minuti" >
                            <%=Utility.elimina_zero(durata_sottostask_arrotondata)%> h
                        </a>   
                    </td>
                    <td>                       
                        <input type="number" id="new_durata_<%=attivita.getId()%>" value="<%=Utility.elimina_zero(durata_sottostask_arrotondata)%>" style="max-width: 60px">
                    </td>
                    <td>
                        <button class="pulsante green" onclick="attivita_completata('<%=attivita.getId()%>');">
                            <img src="<%=Utility.url%>/images/v2.png"> Completa
                        </button>
                    </td>
                </tr>
                <%}%>
            
                    <%
                    String commessa_prec="";    
                    for(Attivita attivita:lista_attivita){%>
                        <tr>
                            <td>
                                <%=attivita.getFase_input().getCodice()%>
                            </td>
                            <td>
                                <%=attivita.getRisorsa().getNome()%>
                            </td>                            
                            <td>
                                <button class='pulsantesmall' title="ID Attività: <%=attivita.getId()%> - ID Task: <%=attivita.getTask()%>" onclick="mostrapopup('<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita.getId()%>','Attività [ID: <%=attivita.getId()%>]')"> 
                                    <img src='<%=Utility.url%>/images/edit.png'>
                                </button>
                            </td>
                            <td>                                
                                <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=attivita.getCommessa().getId()%>' target="_blank" class="tag fit-content <%if(attivita.getAttiva().equals("si")){%>blink<%}%>" style="background-color:<%=attivita.getCommessa().getColore()%>" title='ID: <%=attivita.getId()%>'>
                                    <%=attivita.getCommessa().getNumero()%>
                                </a>
                            </td>
                            <td><%=attivita.getCommessa().getSoggetto().getAlias()%></td>
                            <td>
                                <%=attivita.getDescrizione()%>
                            </td>
                            <td>
                                <%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%>
                            </td>
                            <td>
                                <%=Utility.convertiDatetimeFormatoIT(attivita.getInizio_tasks())%>
                            </td>                            
                            <td>                                
                                <div class="tagsmall" title="Fine Attività: <%=Utility.convertiDatetimeFormatoIT(attivita.getFine())%>">
                                    <%=Utility.elimina_zero(attivita.getDurata())%> h                             
                                </div>                                
                            </td>
                            <td>
                                <%if(!attivita.getTask().equals("")){%>
                                    <a target="_blank" href="<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=attivita.getTask()%>" 
                                       class="tagsmall task <%if(attivita.durata_tasks_arrotondata()>attivita.getDurata()){%>red<%}%>" 
                                       title="Task: <%=attivita.getTask()%>&#10;Durata: <%=attivita.getDurata_tasks()%> minuti" >
                                        <%=Utility.elimina_zero(attivita.durata_tasks_arrotondata())%> h
                                    </a>    
                                <%}%>
                            </td>
                                <%if(attivita.getTask().equals("")){%>
                                    <td colspan="2">
                                        <div class="tagsmall yellow" title="Impossibile trovare il task associato all'attività">
                                            <img src="<%=Utility.url%>/images/warning.png">
                                        </div>
                                    </td>
                                <%}else{%>                                    
                                    <td></td>
                                    <td>
                                        <%if(!attivita.getSituazione().equals(Attivita.INPROGRAMMAZIONE)){%>
                                            <div class="tagsmall yellow float-left" title="L'attività non risulta essere configurata">
                                                <img src="<%=Utility.url%>/images/warning.png">                                               
                                            </div>
                                        <%}else{%>
                                            <%if((!attivita.getInizio_tasks().contains("3001") && !commessa_prec.equals(attivita.getCommessa().getNumero()))
                                                || (attivita.getDurata_tasks()>attivita.getDurata())){                                                    
                                                int minuti=Math.abs((int)Utility.compareTwoTimeStamps(attivita.getInizio_tasks(),attivita.getInizio()));
                                                if(minuti>30 || attivita.durata_tasks_arrotondata()>attivita.getDurata()){
                                                    commessa_prec=attivita.getCommessa().getNumero();
                                                %>
                                                <button class="pulsante" onclick="mostra_riprogramma_attivita('<%=attivita.getId()%>')" title="<%=minuti%> minuti di differenza">
                                                    <img src="<%=Utility.url%>/images/warning.png">
                                                    Risolvi  
                                                </button>                    
                                                <%}else{
                                                        commessa_prec="";
                                                    %>                                                    
                                                <%}%>
                                            <%}%>
                                        <%}%>
                                    </td>                                       
                                <%}%>                     
                        </tr>
                    <%
                        
                    }%>
                    
            </table>       
        </div>
    </div>