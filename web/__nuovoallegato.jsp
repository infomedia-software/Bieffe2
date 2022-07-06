<%@page import="utility.Utility"%>
<%
    String idrif=Utility.eliminaNull(request.getParameter("idrif"));
    String rif=Utility.eliminaNull(request.getParameter("rif"));
    String url=Utility.eliminaNull(request.getParameter("url"));
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    
    Utility.getIstanza().query(" INSERT INTO allegati(idrif,rif,url,descrizione) VALUES(" +
             Utility.isNull(idrif)+","+
             Utility.isNull(rif)+","+
             Utility.isNull(url)+","+
             Utility.isNull(descrizione)+")");
%>