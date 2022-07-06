<%@page import="beans.Fase"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ArrayList<Fase> acts=GestioneFasi.getIstanza().ricerca("stato='1' ORDER BY ordinamento ASC");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fasi | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
       
            function aggiorna_fasi(){                
                $("#div_fasi").load("<%=Utility.url%>/fasi_cat/fasi_cat.jsp #div_fasi_inner",function(){nascondiloader();nascondipopup();});
            }
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1>Fasi</h1>
            
            <div class="box">                                                       
                <button class="pulsante" onclick="mostrapopup('<%=Utility.url%>/fasi_cat/_nuova_fase.jsp','Nuova Fase')">
                    <img src="<%=Utility.url%>/images/add.png">
                    Nuova Fase
                </button>                    
            </div>


            <div id="div_fasi">
                <div id="div_fasi_inner">    
                    <table class="tabella">
                        <tr>
                            <th style="width: 45px;"></th>
                            <th>Codice</th>
                            <th>Nome</th>
                            <th>Note</th>
                            <th>Ordinamento</th>
                        </tr>
                        <%for(Fase fase_cat:acts){%>
                            <tr>
                                <td>
                                    <a class="pulsantesmall" href='<%=Utility.url%>/fasi_cat/fase_cat.jsp?id=<%=fase_cat.getId()%>'>
                                        <img src="<%=Utility.url%>/images/edit.png">
                                    </a>
                                </td>
                                <td><%=fase_cat.getCodice()%></td>
                                <td><%=fase_cat.getNome()%></td>
                                <td><%=fase_cat.getNote()%></td>
                                <td><%=fase_cat.getOrdinamento()%></td>
                            </tr>
                        <%}%>
                    </table>
                </div>
            </div>

            
        </div>
    </body>
</html>
