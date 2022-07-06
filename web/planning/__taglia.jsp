<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String idattivita=Utility.eliminaNull(request.getParameter("idattivita"));
    
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
    
    String start_riprogramma_risorsa="";
    
    if(attivita.is_in_planning())
        start_riprogramma_risorsa=attivita.getInizio();
    
    double sequenza_min=attivita.getSeq();
    int sequenza_max=((int)sequenza_min)+1;
    
    Utility.getIstanza().query("UPDATE attivita SET "
            + "inizio="+Utility.isNull(Utility.dadefinire)+","
            + "fine="+Utility.isNull(Utility.dadefinire)+","
            + "stato='taglia' "            
            + "WHERE id="+idattivita);                         
    Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore="+Utility.isNull(idattivita));      
    
    String id_coinvolte=Utility.eliminaNull(Utility.getIstanza().querySelect(" "
            + "SELECT GROUP_CONCAT(id) as lista FROM attivita WHERE "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+"AND "
            + "attivita.seq>="+sequenza_min+" AND "
            + "attivita.seq<"+sequenza_max+" AND "
            + "attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
            + "attivita.stato='1' AND "
            + "attivita.id!="+idattivita+" "
            + "ORDER BY attivita.seq ASC","lista"));

    
    if(id_coinvolte.length()>0){
        String prima_data_planning=GestionePlanning.getIstanza().prima_data_planning();
        Utility.getIstanza().query("UPDATE attivita SET "
                + "inizio="+Utility.isNull(Utility.dadefinire)+","
                + "fine="+Utility.isNull(Utility.dadefinire)+","
                + "situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+" "
                + "WHERE id IN ("+id_coinvolte+")");                      
        Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore IN ("+id_coinvolte+")");        // Aggiorna il planning svuotando lo spazio occupato dalle attività        
        
        String start_riprogramma_risorsa_coinvolte=Utility.getIstanza().querySelect("SELECT min(inizio) as valore "
                + "FROM attivita WHERE id IN ("+id_coinvolte+") AND DATE(inizio)>="+Utility.isNull(prima_data_planning), "valore");
        
        if(!start_riprogramma_risorsa.equals("") && !Utility.viene_prima(start_riprogramma_risorsa, start_riprogramma_risorsa_coinvolte))
            start_riprogramma_risorsa=start_riprogramma_risorsa_coinvolte;
    }
    
    
    String id_risorsa=attivita.getRisorsa().getId();
    // Riprogramma a partire dall'attività     
    if(!start_riprogramma_risorsa.equals(""))
        GestionePlanning.getIstanza().riprogrammaRisorse(id_risorsa, start_riprogramma_risorsa);
%>