<%@page import="utility.Utility"%>
<%
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    
    Utility.getIstanza().query("UPDATE act SET stato='-1' WHERE id="+id_act);
    Utility.getIstanza().query("UPDATE attivita SET id_act='' WHERE id_act="+id_act);
%>