<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true" %>
<%
    String nome=Utility.eliminaNull(request.getParameter("nome"));
    String note=Utility.eliminaNull(request.getParameter("note"));
    
    String id_reparto=Utility.getIstanza().query_insert(" INSERT into reparti(nome,note) VALUES("
            + Utility.isNull(nome)+","
            + Utility.isNull(note)+")");
    out.print(id_reparto);
%>