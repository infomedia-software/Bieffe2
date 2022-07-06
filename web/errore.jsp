<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String messaggio=Utility.eliminaNull(request.getParameter("messaggio"));
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Errore <%=Utility.nomeSoftware%></title>
        <jsp:include page="_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <div style="margin: auto;margin-top:50px;text-align: center;">
            <img src="<%=Utility.url%>/images/infogest.jpg" style="height: 100px">
            <div class="height10"></div>
            ...si è verificato un errore
            <div class="height10"></div>
            <%if(!messaggio.equals("")){%>
                <div style="font-size: 12px;line-height: 14px;"><%=messaggio%></div>
            <%}%>
            <a href='<%=Utility.url%>/index.jsp' class="pulsante margin-auto" style="float: none">Torna alla Home</a>
            <div class="height10"></div>
        </div>
    </body>
</html>
