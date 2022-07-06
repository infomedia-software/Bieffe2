<%@page import="beans.Fase"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Fase_Input"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="gestioneDB.GestioneFasi_Input"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    ArrayList<Fase_Input> sottofasi=GestioneFasi_Input.getIstanza().ricerca(" 1 ORDER BY fasi_input.sequenza ASC");
    ArrayList<Fase> fasi=GestioneFasi.getIstanza().ricerca("");
%>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sottofasi | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function modifica_fase_input(inField,id_fase_input){                
                var new_valore=inField.value;
                var campo_da_modificare=inField.id;                 
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/fasi_cat/__modifica_fase_input.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id_fase_input="+id_fase_input,
                    dataType: "html",
                    success: function(msg){
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_fase_input()");
                    }
                });
            }
        </script>
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1>Sottofasi</h1>
            
        
            <table class="tabella" style="table-layout: fixed">
                <tr>
                    <th>Codice</th>
                    <th>Descrizione</th>
                    <th>Fase</th>
                    <th>Esterna</th>
                    <th>Stampa</th>
                    <th>Allestimento</th>
                </tr>
                <%for(Fase_Input sottofase:sottofasi){%>
                    <tr>
                        <td><%=sottofase.getCodice()%></td>
                        <td><%=sottofase.getNome()%></td>
                        <td>
                            <select id="fase" onchange="modifica_fase_input(this,'<%=sottofase.getId()%>')">
                                <option value=""></option>
                                <%for(Fase fase:fasi){%>
                                    <option value="<%=fase.getId()%>" <%if(sottofase.getFase().getId().equals(fase.getId())){%>selected="true"<%}%>><%=fase.getCodice()%> <%=fase.getNome()%> <%=fase.getNote()%></option>
                                <%}%>
                            </select>

                        </td>
                        <td>
                                <select id="esterna" onchange="modifica_fase_input(this,'<%=sottofase.getId()%>')">
                                    <option value=""></option>
                                    <option value="si" <%if(sottofase.getEsterna().equals("si")){%>selected="true"<%}%>>Si</option>
                                </select>
                            
                        </td>
                        <td>
                            
                                <select id="stampa" onchange="modifica_fase_input(this,'<%=sottofase.getId()%>')">
                                    <option value=""></option>
                                    <option value="si" <%if(sottofase.getStampa().equals("si")){%>selected="true"<%}%>>Si</option>
                                </select>
                            
                        </td>
                        <td>
                            
                                <select id="allestimento" onchange="modifica_fase_input(this,'<%=sottofase.getId()%>')">
                                    <option value=""></option>
                                    <option value="si" <%if(sottofase.getAllestimento().equals("si")){%>selected="true"<%}%>>Si</option>
                                </select>
                            
                        </td>
                    </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
