<%@page import="utility.Utility"%>
<%
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String campo_da_modificare=Utility.eliminaNull(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.eliminaNull(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE act_res SET "+campo_da_modificare+"="+Utility.isNull(new_valore)+" WHERE id="+id_act_res);
%>
