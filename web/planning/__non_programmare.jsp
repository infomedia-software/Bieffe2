<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    
    Attivita attivita=GestionePlanning.getIstanza().get_attivita(id_attivita);
    
    String attivita_commessa=attivita.getCommessa().getId();
    
    String attivita_risorsa=attivita.getRisorsa().getId();
    
    double seq_double=attivita.getSeq();
    String attivita_connesse_id="";
 
    Utility.getIstanza().query(""
        + "UPDATE attivita SET "
            + "inizio="+Utility.isNull(Utility.dadefinire) +","
            + "fine="+Utility.isNull(Utility.dadefinire) +","
            + "risorsa='',"
            + "seq=0,"
            + "ritardo=0,"
            + "scostamento=0,"
            + "completata='',"
            + "attiva='',"
            + "attiva_infogest='',"
            + "errore='',"
            + "task='',"
            + "durata_tasks=0,"
            + "situazione='' "
        + "WHERE id="+id_attivita);

    Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore="+Utility.isNull(id_attivita));

    
    
    if(seq_double!=0){        
        int seq_successiva=((int)seq_double)+1;        
        attivita_connesse_id=Utility.eliminaNull(Utility.getIstanza().querySelect("SELECT GROUP_CONCAT(id) as attivita_connesse_id FROM attivita WHERE "
                + "seq>"+seq_double+" AND seq<"+seq_successiva+ " AND commessa="+Utility.isNull(attivita_commessa)+" AND id!="+id_attivita,"attivita_connesse_id"));                        
    }
        
    if(!attivita_connesse_id.equals("")){
        ArrayList<Attivita> attivita_connesse = GestionePlanning.getIstanza().ricercaAttivita(" attivita.id IN (" + attivita_connesse_id + ")");
        out.println("Alle seguenti attività è stata rimossa la precedenza con l'attività non programmata\n");
        for (Attivita attivita_connessa : attivita_connesse) {
            out.println(attivita_connessa.getDescrizione() + "\n"
            + "Inizio:  " + attivita_connessa.getInizio_it() + " - Fine:    " + attivita_connessa.getFine_it() + " - Durata:  " + Utility.elimina_zero(attivita_connessa.getDurata()) + "h\n"
            + "Risorsa: " + attivita_connessa.getRisorsa().getCodice() + " " + attivita_connessa.getRisorsa().getNome() + "\n");
        }                
        
        Utility.getIstanza().query("UPDATE attivita SET "           
            + "seq=seq-0.01 WHERE "
            + "id IN ("+attivita_connesse_id+")");
        Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore IN ("+attivita_connesse_id+")");
        Utility.getIstanza().query("UPDATE planning_old SET valore='1' WHERE valore IN ("+attivita_connesse_id+")");
    }
    
    GestionePlanning.getIstanza().riprogrammaRisorse(attivita_risorsa, "");    
%>