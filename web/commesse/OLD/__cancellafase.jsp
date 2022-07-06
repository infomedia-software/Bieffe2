<%@page import="utility.Utility"%>
<%@page import="utility.Utility"%>
<%
    String idfase=Utility.eliminaNull(request.getParameter("idfase"));    
    Utility.getIstanza().query("UPDATE fasi SET stato='-1' WHERE id="+idfase);
%>