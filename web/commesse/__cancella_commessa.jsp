<%@page import="utility.Utility"%>
<%
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    
    Utility.getIstanza().query("UPDATE commesse SET stato='-1' WHERE id="+id_commessa);
    Utility.getIstanza().query("UPDATE attivita SET stato='-1' WHERE commessa="+Utility.isNull(id_commessa));
%>