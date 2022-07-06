<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String situazione=Utility.eliminaNull(request.getParameter("situazione"));
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sincronizza Commesse | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            $(function(){
                mostraloader("Sincronizzazione Commesse in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/commesse/__sincronizza_commesse.jsp",
                    data: "id_commessa=<%=id_commessa%>",
                    dataType: "html",
                    success: function(msg){
                        <%if(!id_commessa.equals("")){%>
                            location.href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=id_commessa%>';
                        <%}%>
                        <%if(!situazione.equals("")){%>    
                            location.href='<%=Utility.url%>/commesse/commesse.jsp?situazione=<%=situazione%>';
                        <%}%>
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                    }
                });
	 
            });
        </script>
        
    </head>
    <body>        
         <div id='loader'>
            <img src="<%=Utility.url%>/images/loader.gif">
            <br>
            <div id='loadertesto'></div>
        </div>
    </body>
</html>
