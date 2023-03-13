<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String query=Utility.eliminaNull(request.getParameter("query"));
    if(query.equals("")){
        query=" act_tsk.stato='1' ";
    }
    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Task | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1>Task</h1>
            <div class="box">
                <jsp:include page="_act_tsk_list.jsp">
                    <jsp:param name="query" value="<%=query%>"></jsp:param>
                </jsp:include>
            </div>
        </div>
    </body>
</html>
