<%@page import="beans.Utente"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="beans.ActRes"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="beans.Act"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    
    String data=Utility.eliminaNull(request.getParameter("data"));
    if(data.equals(""))data=Utility.dataOdiernaFormatoDB();
    
    String stampa=Utility.eliminaNull(request.getParameter("stampa"));
    
    String id_act_res_input=Utility.eliminaNull(request.getParameter("id_act_res"));
    
    ArrayList<ActRes> act_res_list=GestioneActRes.getIstanza().act_res_utente(utente);
    
    Map<String,ArrayList<Act>> mappa_act=GestioneAct.getIstanza().act_data(data);
    
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lista Attività | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            <%if(stampa.equals("si")){%>
                $(function(){
                    window.print();
                });
            <%}%>
        </script>
    </head>
    <body>        
        <%if(stampa.equals("")){%>
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="container">
        <%}%>
        
        <h1>Lista Attività - <%=Utility.convertiDataFormatoIT(data)%></h1>
        
     
            <%for(ActRes act_res:act_res_list){
                String id_act_res=act_res.getId();
                ArrayList<Act> acts=mappa_act.get(act_res.getId());
                
                if(acts.size()>0 && (id_act_res_input.equals("") || id_act_res.equals(id_act_res_input))){
                %>
                    <h2><%=act_res.getNome()%></h2>
                    <table class="tabella">
                    <tr>
                        <th colspan="2">Commessa</th>                
                        <th>Cliente</th>
                        <th>Descrizione</th>
                        <th>Risorsa</th>
                        <th>Inizio</th>
                        <th>Fine</th>
                        <th>Durata</th>
                    </tr>
                    <%for(Act act:acts){
                    %>
                    <tr>
                        <td><%=act.getCommessa().getNumero()%></td>
                        <td><%=act.getCommessa().getDescrizione()%></td>
                        <td><%=act.getCommessa().getSoggetto().getAlias()%></td>
                        <td><%=act.getDescrizione()%></td>
                        <td><%=act.getAct_res().getNome()%></td>
                        <td><%=act.getInizio_string()%></td>
                        <td><%=act.getFine_string()%></td>
                        <td><%=act.getDurata_string()%></td>
                    </tr>
                    <%}%>
                    </table>
                    <div style="height:25px"></div>
                <%}%>
                
            <%}%>
            <%if(stampa.equals("")){%>
                </div>
            <%}%>
        </table>
    </body>
</html>
