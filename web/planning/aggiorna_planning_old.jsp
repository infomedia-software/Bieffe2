<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Aggiornamento Planning | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            $(function(){
                mostraloader("Aggiornamento Planning");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/planning/__aggiorna_planning_old.jsp",
                    data: "",
                    dataType: "html",
                    success: function(msg){
                        location.href='<%=Utility.url%>/planning/planning.jsp';
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
