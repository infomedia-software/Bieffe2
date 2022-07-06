<%@page import="beans.Task"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String commessa=Utility.eliminaNull(request.getParameter("commessa"));
    String fase=Utility.eliminaNull(request.getParameter("fase"));
    
    Task task=GestioneSincronizzazione.getIstanza().trova_task_da_attivita(commessa, fase);
    if(task!=null){
        String id_task=task.getId();
        String inizio_tasks=task.getInizio();
        if(inizio_tasks.equals("")){
            Utility.getIstanza().query("UPDATE attivita "
                    + "SET task="+Utility.isNull(id_task)+" "
                    + "WHERE id="+id_attivita);        
        }else{
            Utility.getIstanza().query("UPDATE attivita "
                    + "SET task="+Utility.isNull(id_task)+",inizio_tasks="+Utility.isNull(inizio_tasks)+" "
                    + "WHERE id="+id_attivita);        
        }
        out.print("ok");
    }else{
        Utility.getIstanza().query("UPDATE attivita "
                    + "SET task="+Utility.isNull("-1")+" "
                    + "WHERE id="+id_attivita);        
        out.print("");
    }
%>