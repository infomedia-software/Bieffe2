<%@page import="gestioneDB.GestioneFasi_Input"%>
<%@page import="beans.Fase_Input"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="beans.Fase"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    
    Fase  fase=GestioneFasi.getIstanza().ricerca(" fasi.id="+Utility.isNull(id)).get(0);
    ArrayList<Fase_Input> fasi_input=GestioneFasi_Input.getIstanza().ricerca(" stato='1' ORDER BY sequenza ASC");
    
    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=fase.getNome()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">


            function modifica_fase_cat(inField){
                var new_valore=inField.value;
                var campo_da_modificare=inField.id;
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/fasi_cat/__modifica_fase_cat.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                    }
                });
            }

            function aggiorna_fasi_cat(){
                var selected = [];
                $('.checkbox_fasi_cat:checked').each(function() {
                    selected.push($(this).attr('id'));
                });      

                var new_valore=selected;
                var campo_da_modificare="fasi_input";
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/fasi_cat/__modifica_fase_cat.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                        
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                    }
                });

            }


            $(function(){
                $('.checkbox_fasi_cat').change(function() {        
                    aggiorna_fasi_cat();
                });
            });
            
        </script>
        
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            
            <h1><%=fase.getNome()%></h1>
            
            <div class="box">
                <div class="etichetta">Codice</div>
                <div class="valore">
                    <input type="text" id="codice" value="<%=fase.getCodice()%>" onchange="modifica_fase_cat(this);"> 
                </div>


                <div class="etichetta">Nome</div>
                <div class="valore">
                    <input type="text" id="nome" value="<%=fase.getNome()%>" onchange="modifica_fase_cat(this);"> 
                </div>

                <div class="etichetta">Note</div>
                <div class="valore">
                    <input type="text" id="note" value="<%=fase.getNote()%>" onchange="modifica_fase_cat(this);"> 
                </div>

            </div>

        </div>
    </body>
</html>
