<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    String durata=Utility.eliminaNull(request.getParameter("durata"));
    String id_act_ph=Utility.eliminaNull(request.getParameter("id_act_ph"));
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String note=Utility.eliminaNull(request.getParameter("note"));
      

    String id_act=Utility.getIstanza().query_insert("INSERT INTO act(id_commessa,descrizione,id_act_res,id_act_ph,durata,note,stato) "
        + "VALUES("
        + Utility.isNull(id_commessa)+","                    
        + Utility.isNull(descrizione)+","        
        + Utility.isNull(id_act_res)+","        
        + Utility.isNull(id_act_ph)+","        
        + durata+","                
        + Utility.isNull(note)+","
        + "'1'"
    + ")");
    
    Utility.getIstanza().query("UPDATE attivita SET id_act="+Utility.isNull(id_act)+" WHERE id="+id_attivita);

%>