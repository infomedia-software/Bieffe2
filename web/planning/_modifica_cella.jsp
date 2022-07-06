<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.PlanningCella"%>
<%@page import="utility.Utility"%>
<%
    String id_cella=Utility.eliminaNull(request.getParameter("id_cella"));
    
    String PLANNING_CELLA_OPZIONE_1=Utility.getIstanza().getValoreByCampo("opzioni", "valori", "etichetta='PLANNING_CELLA_OPZIONE_1'");
    String PLANNING_CELLA_OPZIONE_1_COLORE=Utility.getIstanza().getValoreByCampo("opzioni", "valori", "etichetta='PLANNING_CELLA_OPZIONE_1_COLORE'");
    
    String PLANNING_CELLA_OPZIONE_2=Utility.getIstanza().getValoreByCampo("opzioni", "valori", "etichetta='PLANNING_CELLA_OPZIONE_2'");
    String PLANNING_CELLA_OPZIONE_2_COLORE=Utility.getIstanza().getValoreByCampo("opzioni", "valori", "etichetta='PLANNING_CELLA_OPZIONE_2_COLORE'");
    
    PlanningCella cella=GestionePlanning.getIstanza().ricercaPlanningCelle(" planning.id="+id_cella).get(0);
    
    Risorsa risorsa=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+cella.getRisorsa()).get(0);
    
    String PLANNING_CELLA_OPZIONE=cella.getNote().substring(0,cella.getNote().indexOf("}")+1);
%>

<script type="text/javascript">
    function modifica_note_cella(){
        var new_valore=$("#note_cella").val();
        new_valore="<%=PLANNING_CELLA_OPZIONE%>"+new_valore;
        modifica_cella('<%=id_cella%>','note',new_valore);
    }
</script>


<div class="box">
    
    <div class="etichetta">Risorsa</div>
    <div class="valore"><span><%=risorsa.getCodice()%> <%=risorsa.getNome()%></span></div>
    
    <div class="etichetta">Orario</div>
    <div class="valore"><span><%=Utility.convertiDatetimeFormatoIT(cella.getInizio())%></span></div>
    
    <div class="height10"></div>
    
    <div class="etichetta"></div>
    <div class="valore">
        <%if(cella.getValore().equals("-1")){%>
            <button class="pulsante green" type="button" onclick="modifica_cella('<%=id_cella%>','valore','1')">Abilita</button>
        <%}%>
        <%if(cella.getValore().equals("1")){%>
            <button class="pulsante red" type="button" onclick="modifica_cella('<%=id_cella%>','valore','-1')">Disabilita</button>
        <%}%>
        
        <button class="pulsante" style="background-color: <%=PLANNING_CELLA_OPZIONE_1_COLORE%>"  onclick="modifica_cella('<%=id_cella%>','valore','PLANNING_CELLA_OPZIONE_1')"><%=PLANNING_CELLA_OPZIONE_1%></button>
        <button class="pulsante" style="background-color: <%=PLANNING_CELLA_OPZIONE_2_COLORE%>"  onclick="modifica_cella('<%=id_cella%>','valore','PLANNING_CELLA_OPZIONE_2')"><%=PLANNING_CELLA_OPZIONE_2%></button>
    </div>

    <%if(cella.getValore().equals("-1")){%>
        <div class="height10"></div>
        <div class="etichetta">Note</div>
        <div class="valore">
            <textarea id="note_cella" onchange="modifica_note_cella()"><%=Utility.standardizzaStringaPerTextArea(cella.stampa_note())%></textarea>
        </div>
    <%}%>
</div>