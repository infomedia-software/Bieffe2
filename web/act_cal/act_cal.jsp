<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActCal"%>
<%@page import="java.util.Map"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<%    
    ArrayList<String> date=new ArrayList<String>();
    String prima_data=Utility.dataOdiernaFormatoDB();
    String ultima_data=Utility.dataFutura(prima_data, 60);
    while(!prima_data.equals(ultima_data)){
        date.add(prima_data);
        prima_data=Utility.dataFutura(prima_data, 1);
    }
    
    Map<String,String> calendario=GestioneActCal.getIstanza().ricerca(" data>="+prima_data);
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calendario | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function crea_giorno(data){
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_cal/__crea_giorno.jsp",
                    data: "data="+encodeURIComponent(String(data)),
                    dataType: "html",
                    success: function(msg){
                        location.reload();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                    }
                });
            }
            function attiva_giorno(data){
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_cal/__attiva_giorno.jsp",
                    data: "data="+encodeURIComponent(String(data)),
                    dataType: "html",
                    success: function(msg){
                        location.reload();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                    }
                });
            }
            
            function disattiva_giorno(data){
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/act_cal/__disattiva_giorno.jsp",
                    data: "data="+encodeURIComponent(String(data)),
                    dataType: "html",
                    success: function(msg){
                        location.reload();
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
            <h1>Calendario</h1>
            <div class="box">
                <table class="tabella" style="width: 200px">
                    <tr>                        
                        <th>Data</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                    <%for(String data:date){                        
                        String valore=calendario.get(data);
                    %>
                    <tr>
                        <td>
                            <%=Utility.giornoDellaSettimana(data)%> <%=Utility.convertiDataFormatoIT(data)%>
                        </td>
                        <td>
                            <%if(valore==null){%>
                                <button class="pulsante_tabella color_nuovo" onclick="crea_giorno('<%=data%>')">Crea Giorno</button>
                            <%}else{%>
                                <%if(valore.equals("si")){%>
                                    <a href="<%=Utility.url%>/act_pl/act_pl.jsp?data=<%=data%>" class="pulsante_tabella">Visualizza</a>
                                <%}%>
                            <%}%>
                        </td>                        
                            <%if(valore!=null){%>                                
                                <%if(valore.equals("")){%>
                                    <td>                                
                                        <div class="tag_tabella color_eee" style="color:white">Attivo</div>
                                        <div class="tag_tabella red" style="color:white">Non Attivo</div>
                                    </td>
                                    <td>
                                        <button class="pulsante_tabella" onclick="attiva_giorno('<%=data%>')">Attiva</button>
                                    </td>
                                <%}else{%>
                                    <td>
                                        <div class="tag_tabella green">Attivo</div>
                                        <div class="tag_tabella color_eee" style="color:white">Non Attivo</div>
                                    </td>
                                    <td>
                                        <button class="pulsante_tabella" onclick="disattiva_giorno('<%=data%>')">Disattiva</button>
                                    </td>
                                <%}%>
                            <%}else{%>
                                <td colspan="2"></td>
                            <%}%>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </div>
        </div>
    </body>
</html>
