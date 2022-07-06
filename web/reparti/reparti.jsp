<%@page import="java.util.ArrayList"%>
<%@page import="beans.Reparto"%>
<%@page import="gestioneDB.GestioneReparti"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    ArrayList<Reparto> reparti=GestioneReparti.getIstanza().ricerca("");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reparti | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        <div id="container">
            
            <h1>Reparti</h1>
            
            <div class="box">                            
                <button class="pulsante" onclick="mostrapopup('<%=Utility.url%>/reparti/_nuovo_reparto.jsp','Nuovo Reparto')">
                    <img src="<%=Utility.url%>/images/add.png">
                    Nuovo Reparto
                </button>                              
            </div>
            
            <table class="tabella">
                <tr>
                    <th style="width: 45px"></th>
                    <th>Nome</th>
                    <th>Note</th>
                </tr>
                <%for(Reparto r:reparti){%>
                    <tr>
                        <td>
                            <a class="pulsantesmall" href='<%=Utility.url%>/reparti/reparto.jsp?id_reparto=<%=r.getId()%>'><img src="<%=Utility.url%>/images/edit.png"></a>
                        </td>
                        <td><%=r.getNome()%></td>
                        <td><%=r.getNote()%></td>
                    </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
