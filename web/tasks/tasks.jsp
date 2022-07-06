<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tasks | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function sincronizza_tasks(){
                if(confirm("Procedere alla sincronizzazione dei tasks")){
                    mostraloader("Sincronizzazione in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/tasks/__sincronizza_tasks.jsp",
                        data: "",
                        dataType: "html",
                        success: function(msg){
                            location.href='<%=Utility.url%>/tasks/tasks.jsp';
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE sincronizza_task()");
                        }
                    });		
                }
            }
        </script>
        
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            
            <h1>Tasks</h1>
            
            <div class="box">
                <button class="pulsante" onclick="sincronizza_tasks()">Sincronizza</button>                      
            </div>
            
        
            
            
            <%
                String query="tasks.stato='1' ";
                String ordinamento="tasks.inizio DESC";
                String limit="0";
            %>
            <jsp:include page="_tasks.jsp">
                    <jsp:param name="query" value="<%=query%>"></jsp:param>
                    <jsp:param name="ordinamento" value="<%=ordinamento%>"></jsp:param>
                    <jsp:param name="limit" value="<%=limit%>"></jsp:param>
                    <jsp:param name="commesse.situazione" value="incorso"></jsp:param>	
            </jsp:include>
        </div>
    </body>
</html>
