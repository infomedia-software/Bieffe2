<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%@page import="utility.Utility"%>
<%    
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    String inizio=Utility.eliminaNull(request.getParameter("inizio"));
    String fine=Utility.eliminaNull(request.getParameter("fine"));
    String inizio2=Utility.eliminaNull(request.getParameter("inizio2"));
    String fine2=Utility.eliminaNull(request.getParameter("fine2"));
    String applica_sempre=Utility.eliminaNull(request.getParameter("applica_sempre"));
    
    
    
    /*** *** *** *** *** *** *** *** *** *** *** *** 
     *          Disabilita la risorsa
     *** *** *** *** *** *** *** *** *** *** *** ***/
    if(newvalore.equals("-1")){
        inizio="23:30";
        fine="23:30";
    }
    
    //System.out.println(newvalore+"=>"+inizio+"=>"+fine);
    
    /*** *** *** *** *** *** *** *** *** *** *** *** 
     *          Abilita solo dopo linea temporale (tasto Riprogramma dopo linea temporale su risorsa)
     *** *** *** *** *** *** *** *** *** *** *** ***/
    if(newvalore.equals("1") && inizio.equals("") && fine.equals("")){        
        
        int ora_corrente=Utility.ora_corrente();
        int minuti_corrente=Utility.minuti_corrente();
        
        if(minuti_corrente>30){
            ora_corrente++;
            minuti_corrente=0;
        }else{
            minuti_corrente=30;
        }
        inizio=Utility.formattaOrario(ora_corrente, minuti_corrente)+":00";
        fine=Utility.getIstanza().getValoreByCampo("planning", "inizio", " "
                + " valore='-1' AND "
                + " risorsa="+Utility.isNull(risorsa)+" AND "
                + " inizio>="+Utility.isNull(data+" "+inizio)+" AND inizio<="+Utility.isNull(data+" 23:30:00")
                + " ORDER BY inizio ASC LIMIT 0,1");
        fine=fine.substring(11,16);
        
    }
    
    String query_abilita="";
    String query_disabilita="";
    
    if(campodamodificare.equals("valore") && !data.equals("") && !inizio.equals("") && applica_sempre.equals("false")){
        
        
        query_disabilita=" UPDATE planning "
            + " SET "+campodamodificare+"="+Utility.isNull("-1")+" "
            + " WHERE "
            + " risorsa="+Utility.isNull(risorsa)+" AND "
            + "("
                + " (inizio>="+Utility.isNull(data+" 00:00:00") +" AND inizio<="+Utility.isNull(data+" 23:30:00")+") "
            + ")";
        Utility.getIstanza().query(query_disabilita);
        
        if(!inizio.equals("") && !fine.equals("") && newvalore.equals("1")){
            
            query_abilita=" UPDATE planning "
                + " SET "+campodamodificare+"="+Utility.isNull("1")+" "
                + " WHERE "
                + " risorsa="+Utility.isNull(risorsa)+" AND "
                + " ((inizio>="+Utility.isNull(data+" "+inizio)+" AND "
                + " fine<="+Utility.isNull(data+" "+fine)+") ";       
            if(!inizio2.equals("") && !fine2.equals("")){
                query_abilita=query_abilita+" OR (inizio>="+Utility.isNull(data+" "+inizio2)+" AND "
                + " fine<="+Utility.isNull(data+" "+fine2)+") ";       
            }            
            query_abilita=query_abilita+")";
            Utility.getIstanza().query(query_abilita);
        }
        
        String start_riprogramma_risorsa=data+" 00:00:00";
        Attivita prima_attivita_risorsa=null;
        if(newvalore.equals("-1"))
            prima_attivita_risorsa=GestionePlanning.getIstanza().prima_attivita_risorsa(risorsa,data+" 00:00:00");
        else
            prima_attivita_risorsa=GestionePlanning.getIstanza().prima_attivita_risorsa(risorsa,data+" "+inizio+":00");
            
        
        if(prima_attivita_risorsa!=null)
            start_riprogramma_risorsa=prima_attivita_risorsa.getInizio();        
        
        GestionePlanning.getIstanza().riprogrammaRisorse(risorsa,start_riprogramma_risorsa);
    }
    

    // Applica per tutti i giorni a partire dalla data selezionata
    if(campodamodificare.equals("valore") && !data.equals("") && !inizio.equals("") && applica_sempre.equals("true")){        
        
        Utility.getIstanza().query(" UPDATE planning SET valore='-1' WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)>="+Utility.isNull(data)+"");
        
        Utility.getIstanza().query(" UPDATE planning SET valore='1' WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)>="+Utility.isNull(data)+" AND TIME(inizio)>="+Utility.isNull(inizio)+" AND TIME(inizio)<"+Utility.isNull(fine)+" AND DAYOFWEEK(DATE(inizio))!=1 AND  DAYOFWEEK(DATE(inizio))!=7  ");
        if(!inizio2.equals("") && !fine2.equals("")){
            Utility.getIstanza().query(" UPDATE planning SET valore='1' WHERE risorsa="+Utility.isNull(risorsa)+" AND DATE(inizio)>="+Utility.isNull(data)+" AND TIME(inizio)>="+Utility.isNull(inizio2)+" AND TIME(inizio)<"+Utility.isNull(fine2)+" AND DAYOFWEEK(DATE(inizio))!=1 AND  DAYOFWEEK(DATE(inizio))!=7  ");
        }
        
        
        String start_riprogramma_risorsa=data+" 00:00:00";
        Attivita prima_attivita_risorsa=null;
        if(newvalore.equals("-1"))
            prima_attivita_risorsa=GestionePlanning.getIstanza().prima_attivita_risorsa(risorsa,data+" 00:00:00");
        else
            prima_attivita_risorsa=GestionePlanning.getIstanza().prima_attivita_risorsa(risorsa,data+" "+inizio+":00");
                   
        if(prima_attivita_risorsa!=null)
            start_riprogramma_risorsa=prima_attivita_risorsa.getInizio();    
        
        GestionePlanning.getIstanza().riprogrammaRisorse(risorsa,start_riprogramma_risorsa);
    }

%>