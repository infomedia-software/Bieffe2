
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Task"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String tm_task_id=Utility.eliminaNull(request.getParameter("id_esterno"));
    ArrayList<Task> sottotasks=GestioneTasks.getIstanza().sottotasks(tm_task_id);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sottotask | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
       
        <div id="container">
            
            <h1>Sottotask</h1>
            <%if(sottotasks.size()==0){%>
                <div class="errore">Nessun sottotask presente.</div>
            <%}else{%>
            
            <table class="tabella">
                <tr>
                    <th>Risorsa</th>
                    <th>Inizio</th>
                    <th>Fine</th>
                    <th>Durata</th>
                </tr>
                <%
                double durata=0;    
                for(Task task:sottotasks){
                    durata=durata+task.getAttivita().getDurata_tasks();
                    %>
                    <tr>
                        <td class="text-align-center"><%=task.getNote()%></td>                        
                        <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(task.getInizio())%></td>                        
                        <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(task.getFine())%></td>                        
                        <td class="text-align-center"><%=Utility.formattaOrario(0, (int)task.getAttivita().getDurata_tasks())%></td>
                    </tr>
                <%}%>
                <tr>
                    <th colspan='3'></th>
                    <th class="text-align-center"><%=Utility.formattaOrario(0,(int)durata)%></th>
                </tr>
            </table>
            <%}%>
        </div>
    </body>
</html>
