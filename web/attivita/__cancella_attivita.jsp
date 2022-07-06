<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    
    Utility.getIstanza().query("DELETE FROM attivita WHERE id="+id_attivita);

%>