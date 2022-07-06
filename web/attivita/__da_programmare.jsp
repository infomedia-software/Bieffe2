<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    String fase_input=Utility.eliminaNull(request.getParameter("fase_input"));
    String durata_input=Utility.eliminaNull(request.getParameter("durata"));
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    String scostamento=Utility.eliminaNull(request.getParameter("scostamento"));
    if(scostamento.equals(""))
        scostamento="0";
    String note=Utility.eliminaNull(request.getParameter("note"));
    String prezzo_ordine_fornitore=Utility.eliminaNull(request.getParameter("prezzo_ordine_fornitore"));
    if(prezzo_ordine_fornitore.equals(""))
        prezzo_ordine_fornitore="0";
    String qta_ordine_fornitore=Utility.eliminaNull(request.getParameter("qta_ordine_fornitore"));
    if(qta_ordine_fornitore.equals(""))
        qta_ordine_fornitore="0";
    
    double seq=0.00;
    /****************************************
     *          PRECEDENTE
     ****************************************/    
    String precedente_tipo=Utility.eliminaNull(request.getParameter("precedente_tipo"));
    String precedente_attivita=Utility.eliminaNull(request.getParameter("precedente_attivita"));    
    
    if(precedente_tipo.equals("escludi"))
        seq=0;
    if(precedente_tipo.equals("primo")){
        double precedente_max=Utility.getIstanza().querySelectDouble("SELECT CAST(max(seq) as UNSIGNED) as max_seq FROM attivita WHERE commessa="+id_commessa+" AND stato='1'", "max_seq");
        seq=precedente_max+1;
    }
    if((precedente_tipo.equals("dopo") || precedente_tipo.equals("insieme")) && !precedente_attivita.equals("") ){
        double precedente_seq=Utility.getIstanza().querySelectDouble("SELECT seq FROM attivita WHERE id="+precedente_attivita, "seq");
        seq=precedente_seq+0.01;
    }
    
    if(precedente_tipo.equals("insieme") && !precedente_attivita.equals("")){
        double precedente_seq=Utility.getIstanza().querySelectDouble("SELECT seq FROM attivita WHERE id="+precedente_attivita, "seq");
        seq=precedente_seq+0.01;       
        // Imposto campo libero7=id_precedente in attività appena configurata
        Utility.getIstanza().query("UPDATE attivita SET libero7="+Utility.isNull(precedente_attivita)+" WHERE id="+id_attivita);
    }
    
    
    /*** Calcolo ore e minuti***/
    String ore="";
    String minuti="";
    if(durata_input.contains(".")){
        String[] durata=durata_input.split("\\.");
        ore=durata[0];
        minuti=durata[1];
        if(minuti.equals("5") || minuti.equals("50"))
            minuti="30";
    }else{
        ore=durata_input;
        minuti="0";
    }
    
    Utility.getIstanza().query("UPDATE attivita SET "
            + "descrizione="+Utility.isNull(descrizione)+","
            + "fase_input="+Utility.isNull(fase_input)+","                            
            + "ore="+ore+","
            + "minuti="+minuti+","
            + "risorsa="+Utility.isNull(risorsa)+","
            + "seq="+seq+","
            + "scostamento="+scostamento+","
            + "situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+","                    
            + "qta_ordine_fornitore="+qta_ordine_fornitore+","                    
            + "prezzo_ordine_fornitore="+prezzo_ordine_fornitore+","                    
            + "note="+Utility.isNull(note)+" "                    
            + "WHERE "
            + "id="+id_attivita);
   
    
    // Verifico se viene inficiata la fase di stampa o allestimento
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita).get(0);
    if(attivita.getFase_input().getStampa().equals("si")){          
        String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita.getCommessa().getId(),"stampa");
        Utility.getIstanza().query("UPDATE commesse SET stampa="+Utility.isNull(colore)+" WHERE id="+attivita.getCommessa().getId());           
    }
    if(attivita.getFase_input().getAllestimento().equals("si")){    
        String colore=GestioneCommesse.getIstanza().verifica_fase_commessa(attivita.getCommessa().getId(),"allestimento");
        Utility.getIstanza().query("UPDATE commesse SET allestimento="+Utility.isNull(colore)+" WHERE id="+attivita.getCommessa().getId());           
    }
    
            
    String attivita_programmate=Utility.getIstanza().getValoreByCampo("attivita", "id", " "
            + "attivita.commessa="+Utility.isNull(id_commessa) +" AND "
            + "attivita.stato='1' AND "
            + "attivita.situazione='programmata'");
    if(attivita_programmate.equals("")){
        Utility.getIstanza().query("UPDATE commesse SET situazione='programmata' WHERE id="+Utility.isNull(id_commessa));
    }
%>