<%@page import="beans.ActRes"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    ArrayList<ActRes> act_res_list=GestioneActRes.getIstanza().ricerca("");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Risorse | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            
        </script>        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <div class="box">
                <button class="pulsante" onclick="mostrapopup('<%=Utility.url%>/act_res/_new_act_res.jsp')"><img src="<%=Utility.url%>/images/add.png">Nuova Risorsa</button>
            </div>
            
            <div class="box">
                <table class="tabella"
                    <tr>
                        <th>Codice</th>
                        <th>Nome</th>
                        <th></th>    
                    </tr>
                    <%for(ActRes act_res:act_res_list){%>
                        <tr>
                            <td><a href='<%=Utility.url%>/act_res/act_res.jsp?id_act_res=<%=act_res.getId()%>' class="pulsante_tabella">Dettagli</a></td>
                            <td><%=act_res.getCodice()%></td>
                            <td><%=act_res.getNome()%></td>
                        </tr>
                    <%}%>
                </table>            
        </div>
    </body>
</html>
