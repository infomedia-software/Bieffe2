<%@page import="utility.Utility"%>
<%
    String idelemento=Utility.eliminaNull(request.getParameter("idelemento"));    
    Utility.getIstanza().query("UPDATE commessa_elementi SET stato='-1' WHERE id="+idelemento);    
    Utility.getIstanza().query("UPDATE fasi SET stato='-1' WHERE elemento="+idelemento);
%>