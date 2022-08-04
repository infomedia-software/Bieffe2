<%@page import="server.ws.WsServer"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="beans.Attivita"%>
<%@page import="beans.PlanningCella"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String idattivita=Utility.eliminaNull(request.getParameter("idattivita"));    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
   
    String situazione=Utility.getIstanza().getValoreByCampo("attivita", "situazione", "id="+idattivita);
    
    String id_attivita_insieme=Utility.getIstanza().getValoreByCampo("attivita", "id", "libero7="+Utility.isNull(idattivita));            
    
    
    String query="";
 
    
     // Modifica del ritardo    
    if(campodamodificare.equals("ritardo")){
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
        String query_aggiorna_ritardo="UPDATE attivita SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+idattivita+" OR libero7="+idattivita;
        Utility.getIstanza().query(query_aggiorna_ritardo);        
        campodamodificare="durata";        
        double ritardo_double=Utility.convertiStringaInDouble(newvalore);
        double new_durata=ritardo_double+attivita.getDurata()-attivita.getRitardo();
        newvalore=new_durata+"";
    }
    
    String ore="";
    String minuti="";
    
    if(campodamodificare.equals("durata")){
        
        if(newvalore.contains(".")){
            String[] durata=newvalore.split("\\.");
            ore=durata[0];
            minuti=durata[1];
            if(minuti.equals("5") || minuti.equals("50"))
                minuti="30";
        }else{
            ore=newvalore;
            minuti="0";
        }
    
        if(!ore.equals("0") || !minuti.equals("0")){
            query="UPDATE attivita "
                + " SET ore="+Utility.isNull(ore)+",minuti="+Utility.isNull(minuti)+" "
                + " WHERE id="+idattivita;                
        }
    }else{
        query="UPDATE attivita SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+idattivita;        
    }
    
    if(campodamodificare.equals("stato") && newvalore.equals("1")){
       query="UPDATE attivita SET stato='1',situazione='da programmare' WHERE id="+idattivita;        
    }
    
    if(!query.equals(""))
        Utility.getIstanza().query(query);    
    
    // Verifica se sono state completate tutte le fasi di stampa o allestimento
    
    if(campodamodificare.equals("completata") || campodamodificare.equals("situazione")){
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
        
        
        if(attivita.getFase_input().getStampa().equals("si")){          
            String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita.getCommessa().getId(),"stampa");
            Utility.getIstanza().query("UPDATE commesse SET stampa="+Utility.isNull(colore)+" WHERE id="+attivita.getCommessa().getId());           
        }
        if(attivita.getFase_input().getAllestimento().equals("si")){    
            String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita.getCommessa().getId(),"allestimento");
            Utility.getIstanza().query("UPDATE commesse SET allestimento="+Utility.isNull(colore)+" WHERE id="+attivita.getCommessa().getId());           
        }
    }
    
    if(!id_attivita_insieme.equals("") && !campodamodificare.equals("situazione")){
        String query_attivita_insieme="UPDATE attivita SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+id_attivita_insieme;        
        if(campodamodificare.equals("durata")){
            query_attivita_insieme="UPDATE attivita SET "                
                + "ore="+ore+","
                + "minuti=-"+minuti+","
                + "scostamento=-"+newvalore+" "
            + "WHERE "
                + "id="+id_attivita_insieme;   
        }
        Utility.getIstanza().query(query_attivita_insieme);
    }
    
    
    // Imposto da programmare la situazione
    if(campodamodificare.equals("situazione") && newvalore.equals("da programmare")){        
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
        
        Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore="+idattivita+"");       
        Utility.getIstanza().query("UPDATE attivita SET "
                    + "inizio='"+Utility.dadefinire+"',"                    
                    + "fine='"+Utility.dadefinire+"',"                    
                    + "situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+" "
                + "WHERE "
                    + "id="+idattivita);       
        
        
        double sequenza_min=attivita.getSeq();
        int sequenza_max=((int)sequenza_min)+1;
        
        String id_coinvolte=Utility.eliminaNull(Utility.getIstanza().querySelect(" SELECT GROUP_CONCAT(id) as lista FROM attivita WHERE "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "attivita.seq>="+sequenza_min+" AND "
            + "attivita.seq<"+sequenza_max+" AND "
            + "attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
            + "attivita.stato='1' AND "
            + "attivita.id!="+idattivita+" "
            + "ORDER BY attivita.seq ASC","lista"));
        if(id_coinvolte.length()>0){
            Utility.getIstanza().query("UPDATE attivita SET "
                    + "inizio="+Utility.isNull(Utility.dadefinire)+","
                    + "fine="+Utility.isNull(Utility.dadefinire)+","
                    + "situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+" "
                    + "WHERE id IN ("+id_coinvolte+")");                      
            Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore IN ("+id_coinvolte+")");      // Aggiorna il planning svuotando lo spazio occupato dalle attività

        }

        
    }
    
    // Imposto a vuoto la situazione
    if(campodamodificare.equals("situazione") && newvalore.equals("")){        
        
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
        
        Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore="+idattivita+"");      
        Utility.getIstanza().query("UPDATE attivita SET inizio='3001-01-01 00:00:00',fine='3001-01-01 00:00:00',risorsa='',seq=0,situazione='' WHERE id="+idattivita);               
        
        double sequenza_min=attivita.getSeq();
        int sequenza_max=((int)sequenza_min)+1;
        
        String id_coinvolte=Utility.eliminaNull(Utility.getIstanza().querySelect(" SELECT GROUP_CONCAT(id) as lista FROM attivita WHERE "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "attivita.seq>="+sequenza_min+" AND "
            + "attivita.seq<"+sequenza_max+" AND "            
            + "attivita.stato='1' AND "
            + "attivita.id!="+idattivita+" "
            + "ORDER BY attivita.seq ASC","lista"));
        if(id_coinvolte.length()>0){
            Utility.getIstanza().query("UPDATE attivita SET inizio="+Utility.isNull(Utility.dadefinire)+",fine="+Utility.isNull(Utility.dadefinire)+",situazione='',risorsa='',seq=0 WHERE id IN ("+id_coinvolte+")");                      
            Utility.getIstanza().query("UPDATE planning SET valore='1' WHERE valore IN ("+id_coinvolte+")");
        }
        String id_commessa=Utility.getIstanza().getValoreByCampo("attivita", "commessa", "id="+idattivita);
        
        int attivita_programmate=(int)Utility.getIstanza().querySelectDouble("SELECT count(id) as attivita_programmate FROM attivita "
                + "WHERE  situazione='programmata' AND stato='1' AND commessa="+Utility.isNull(attivita.getCommessa().getId()),"attivita_programmate" );
        if(attivita_programmate>0)
            Utility.getIstanza().query("UPDATE commesse SET situazione='programmata' WHERE id="+Utility.isNull(id_commessa));        
        if(attivita_programmate==0)
            Utility.getIstanza().query("UPDATE commesse SET situazione='daprogrammare' WHERE id="+Utility.isNull(id_commessa));        
    }
    
    
    
    
    
    /************************************************************************************
     * Riprogramma le risorse solo se l'attività è in programmazione    
     ************************************************************************************/
    if(situazione.equals(Attivita.INPROGRAMMAZIONE) && (campodamodificare.equals("durata") || campodamodificare.equals("ritardo") || campodamodificare.equals("situazione") || campodamodificare.equals("scostamento"))){                                   
        
        String riprogramma_risorsa_inizio="";
        // se modifico durata oppure importo un ritardo -> drop
        if(campodamodificare.equals("durata") || campodamodificare.equals("ritardo")){                                         
            Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita).get(0);
            Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(idattivita)+", "+Utility.isNull(attivita.getInizio())+","+Utility.isNull(attivita.getRisorsa().getId())+")");
            riprogramma_risorsa_inizio=attivita.getInizio().substring(0,19);
        }
                
        String risorsa=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+idattivita);      
        //System.out.println("risorsa=>"+risorsa);
        //System.out.println("riprogramma_risorsa_inizio=>"+riprogramma_risorsa_inizio);
        if(!risorsa.equals(""))                                                         // se la risorsa non è settata non effettua riprogrammazione
            GestionePlanning.getIstanza().riprogrammaRisorse(risorsa, riprogramma_risorsa_inizio);
    }
    
    
    if(campodamodificare.equals("completata") && newvalore.equals("si")){
        Utility.getIstanza().query("UPDATE attivita SET attiva_infogest='' WHERE id="+idattivita);        
    }
    
    if(campodamodificare.equals("attiva_infogest") || campodamodificare.equals("completata")){
        WsServer.sendAll("aggiorna_planning");
    }

%>