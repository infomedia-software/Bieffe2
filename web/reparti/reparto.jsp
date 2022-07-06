<%@page import="utility.Utility"%>
<%@page import="beans.Reparto"%>
<%@page import="gestioneDB.GestioneReparti"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id_reparto=Utility.eliminaNull(request.getParameter("id_reparto"));
    Reparto reparto=GestioneReparti.getIstanza().ricerca(" reparti.id="+id_reparto).get(0);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=reparto.getNome()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function modifica_reparto(inField){
                var new_valore=inField.value;
                var campo_da_modificare=inField.id;
                $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/reparti/__modifica_reparto.jsp",
                        data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id_reparto=<%=id_reparto%>",
                        dataType: "html",
                        success: function(msg){
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                        }
                });
            }
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1><%=reparto.getNome()%></h1>
            <div class="scheda">
                <div class="etichetta">Nome</div>
                <div class="valore">
                    <input type="text" id="nome" value="<%=reparto.getNome()%>" onchange="modifica_reparto(this);">
                </div>
                
                <div class="etichetta">Note</div>
                <div class="valore">
                    <textarea id="note" onchange="modifica_reparto(this);"><%=Utility.standardizzaStringaPerTextArea(reparto.getNote())%></textarea>
                </div>
                <div class="clear"></div>
            </div>
        </div>
    </body>
</html>
