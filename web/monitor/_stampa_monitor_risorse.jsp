<%@page import="utility.Utility"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%
    ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.planning='si' ORDER BY risorse.ordinamento ASC");
%>

<script type="text/javascript">
    function stampa_monitor_risorse(){
        var checkedValues = $('.checkbox_risorsa:checked').map(function() {return this.value;}).get().toString(); 
        if(checkedValues!==""){
            mostraloader("Stampa in corso...");
            var queryrisorse=" risorse.id IN ("+checkedValues+") ";
            location.href="<%=Utility.url%>/monitor/monitor.jsp?stampa=si&queryrisorse="+queryrisorse;
        }
   }
</script>

<div class="box">
    <%for(Risorsa risorsa:risorse){%>        
    <input type="checkbox" class="checkbox_risorsa" value="<%=risorsa.getId()%>">
        <label for="data_ora_1"><%=risorsa.getCodice()%> <%=risorsa.getNome()%></label>
        <div class="height5"></div>                        
    <%}%>
    
    <button class="pulsante float-right" onclick="stampa_monitor_risorse()"><img src="<%=Utility.url%>/images/print.png">Stampa</button>
</div>