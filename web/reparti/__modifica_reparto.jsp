
<%@page import="utility.Utility"%>
<%
	String id_reparto=Utility.eliminaNull(request.getParameter("id_reparto"));
	String campo_da_modificare=Utility.eliminaNull(request.getParameter("campo_da_modificare"));
	String new_valore=Utility.eliminaNull(request.getParameter("new_valore"));
		
	Utility.getIstanza().query("UPDATE reparti SET "+campo_da_modificare+"="+Utility.isNull(new_valore)+" WHERE id="+id_reparto);
%>