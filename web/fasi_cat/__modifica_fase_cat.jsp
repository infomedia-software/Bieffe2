<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%
    String id_fase_cat=Utility.eliminaNull(request.getParameter("id"));
    
    String campo_da_modificare=Utility.eliminaNull(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.eliminaNull(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE fasi SET "+campo_da_modificare+"="+Utility.isNull(new_valore)+" WHERE id="+id_fase_cat);

%>