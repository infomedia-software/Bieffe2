<%@page import="beans.CDL"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCDL"%>
<%
    
    String id=Utility.eliminaNull(request.getParameter("id"));
    CDL cdl=GestioneCDL.getIstanza().ricerca(" cdl.id="+Utility.isNull(id)).get(0);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=cdl.getCodice()%> <%=cdl.getNome()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function modificacdl(inField){
                var newvalore=inField.value;
                var campodamodificare=inField.id;
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/cdl/__modificacdl.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacdl()");
                    }
                });
            }
        </script>
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1><%=cdl.getCodice()%> <%=cdl.getNome()%></h1>
            
            <div class="etichetta">Codice</div>
            <div class="valore">
                <input type="text" id="codice" value="<%=cdl.getCodice()%>" onchange="modificacdl(this)">
            </div>
            
        
            <div class="etichetta">Nome</div>
            <div class="valore">
                <input type="text" id="nome" value="<%=cdl.getNome()%>" onchange="modificacdl(this)">
            </div>
            
            <div class="etichetta">Note</div>
            <div class="valore">
                <textarea id="note" onchange="modificacdl(this)"><%=cdl.getNote()%></textarea>
            </div>
        </div>
    </body>
</html>
