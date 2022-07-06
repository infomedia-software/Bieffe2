<%@page import="utility.Utility"%>
<%    
    String query=Utility.eliminaNull(request.getParameter("query"));
    if(!query.equals(""))
        Utility.getIstanza().query(query);
%>