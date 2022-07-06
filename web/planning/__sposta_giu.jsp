<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    
    String attivita_inizio=Utility.getIstanza().getValoreByCampo("attivita", "inizio", "id="+id_attivita);
    String attivita_risorsa=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+id_attivita);
    
    
    String idcella=Utility.getIstanza().getValoreByCampo("planning", "id", " inizio="+Utility.isNull(attivita_inizio)+" AND risorsa="+Utility.isNull(attivita_risorsa));
    String newvalore="-1";
    Utility.getIstanza().query("UPDATE planning SET valore="+Utility.isNull(newvalore)+" WHERE planning.id="+idcella);

    String id_risorsa=Utility.getIstanza().getValoreByCampo("planning", "risorsa", "id="+idcella);

    String inizio_cella=Utility.getIstanza().getValoreByCampo("planning", "inizio", "id="+idcella);

    String inizio_riprogramma_risorsa="";
    if(Utility.confrontaTimestamp(inizio_cella, Utility.dataOraCorrente_String())<0){
        inizio_riprogramma_risorsa=inizio_cella;
    }

    GestionePlanning.getIstanza().riprogrammaRisorse(id_risorsa, inizio_riprogramma_risorsa);
   
    newvalore="1";
    Utility.getIstanza().query("UPDATE planning SET valore="+Utility.isNull(newvalore)+" WHERE planning.id="+idcella);
%>