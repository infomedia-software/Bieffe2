<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    ArrayList<Task> tasks=GestioneTasks.getIstanza().ricerca(" tasks.attivo='si' AND tasks.stato='1' ORDER BY tasks.id ASC ");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tasks | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
    
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        

        
        <div id="container">
            <h1>Tasks Attivi</h1>
            
            <%if(tasks.size()>0){%>
                <table class="tabella">                    
                   
                    <tr>
                        <th style="width: 75px">ID</th>
                        <th style="width: 140px">Inizio Task</th>
                        <th style="width: 75px">Durata<br>Effettiva</th>
                        <th style="width: 75px">Durata<br>Planning</th>                        
                        <th style="width: 50px"></th>                        
                        <th style="width: 100px">Risorsa</th>
                        <th style="width: 100px">Cliente</th>
                        <th style="width: 300px">Commessa</th>
                        <th>Descrizione</th>                                 
                        <th style="width: 140px">Inizio</th>                        
                        <th style="width: 55px">Attivo</th>
                        <th>Note</th>
                    </tr>
                    <%for(Task task:tasks){                                                
                    %>
                        <tr>
                            <td><%=task.getId()%> - <%=task.getId_esterno()%></td>    
                            <td>
                                <%if(!task.getAttivita().getInizio().equals("")){%>
                                    <%=Utility.convertiDatetimeFormatoIT(task.getAttivita().getInizio_tasks())%>
                                <%}else{%>
                                    <%=Utility.convertiDatetimeFormatoIT(task.getInizio())%>
                                <%}%>
                            </td>
                            <td>
                                <%if(task.getAttivita().getDurata_tasks()>0){%>
                                    <div class="tagsmall">
                                        <%
                                            double finalBuildTime = task.getAttivita().getDurata_tasks();
                                            int hours = (int) finalBuildTime;
                                            int minutes = (int) (finalBuildTime * 60) % 60;
                                            int seconds = (int) (finalBuildTime * (60*60)) % 60;

                                            out.println(String.format("%s:%s", hours, minutes, seconds));
                                        %>                                    
                                    </div>
                                <%}%>
                            </td>
                            <td>
                                <%if(task.getAttivita().getOre()>0 || task.getAttivita().getMinuti()>0){%>
                                    <%=Utility.formatta_durata(task.getAttivita().getDurata())%> h</div>
                                <%}%>
                            </td>
                            <td>
                                <%if(task.getAttivita().getDurata_tasks()>task.getAttivita().getDurata()){%>
                                    <div class="tagsmall red" title="Durata del task superiore alla durata dell'attività programmata">
                                        <img src="<%=Utility.url%>/images/warning.png">
                                    </div>
                                <%}%>
                            </td>
                                             
                            <td>
                                <%=task.getRisorsa().getId()%> <%=task.getRisorsa().getCodice()%> <%=task.getRisorsa().getNome()%> 
                            </td>       
                            <td>
                                <%=task.getCommessa().getSoggetto().getAlias()%>
                            </td>
                            <td>
                                <div class="tagsmall float-left" style="background-color: <%=task.getCommessa().getColore()%>"></div>
                                <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=task.getCommessa().getId()%>' target="_blank">
                                    <div class="float-left" style="line-height: 22px;margin-left: 5px;">
                                        <%=task.getCommessa().getNumero()%> <%=task.getCommessa().getDescrizione()%>
                                    </div>
                                </a>
                                                                
                            </td>
                            <td>
                                <%if(task.getAttivita().getId().equals("")){%>
                                    <div class="tagsmall yellow float-left">
                                        <img src="<%=Utility.url%>/images/warning.png">
                                    </div>
                                <%}%>
                                <%=task.getAttivita().getId()%> <%=task.getAttivita().getDescrizione()%>
                            </td>
                            <td><%=Utility.convertiDatetimeFormatoIT(task.getAttivita().getInizio())%></td>
                            <td>
                                <%if(task.getAttivo().equals("si")){%>
                                    <div class="tagsmall green"></div>
                                <%}%>
                            </td>
                            <td><%=task.getNote()%></td>
                        </tr>
                    <%}%>
                </table>
            <%}else{%>  
                <div class="errore">
                    Nessun task attualmente attivo !
                </div>
            <%}%>
        </div>
    </body>
</html>
