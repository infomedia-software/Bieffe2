<%@page import="java.util.Map"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Th"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%    
        
    String query_input=Utility.eliminaNull(request.getParameter("query"));
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));    
    String limit=Utility.eliminaNull(request.getParameter("limit"));
    
    String query=query_input;
    
    double numero_righe=0;
    double numero_pagine=0;
    
    ArrayList<Attivita> lista_attivita=GestionePlanning.getIstanza().ricercaAttivita(query+" ORDER BY "+ordinamento+" LIMIT "+limit+","+Utility.numero_righe_pagine);
    numero_righe=GestionePlanning.getIstanza().ricercaAttivita(query_input).size();   
    numero_pagine=(int)Math.ceil(numero_righe/Utility.numero_righe_pagine); 
   
    Map<String,Risorsa> risorse=GestioneRisorse.getIstanza().mappaRisorse(" risorse.stato='1' ");
    
    
    ArrayList<Th> lista_th=new ArrayList<Th>();
    
    Th intestazione=new Th();
        intestazione.setId("inizio");
        intestazione.setCampo_db("attivita.inizio");
        intestazione.setTesto("Inizio");
        intestazione.setTipo(Th.tipo_DATE);
        intestazione.setOrdinamento(0);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
      
    intestazione=new Th();
        intestazione.setId("durata");
        intestazione.setCampo_db("attivita.ore");
        intestazione.setTesto("Durata");
        intestazione.setTipo(Th.tipo_NUMBER);        
        intestazione.setOrdinamento(4);    
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
        
    intestazione=new Th();
        intestazione.setId("fine");
        intestazione.setCampo_db("attivita.fine");
        intestazione.setTesto("Fine");
        intestazione.setTipo(Th.tipo_DATE);
        intestazione.setOrdinamento(1);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
    
    intestazione=new Th();
        intestazione.setId("data_consegna");
        intestazione.setCampo_db("consegna.data_consegna");
        intestazione.setTesto("Data Consegna");
        intestazione.setTipo(Th.tipo_DATE);
        intestazione.setOrdinamento(1);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
        
    intestazione=new Th();
        intestazione.setId("cliente");
        intestazione.setCampo_db("soggetti.alias");
        intestazione.setTesto("Cliente");
        intestazione.setTipo(Th.tipo_TEXT);
        intestazione.setOrdinamento(2);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
    
    intestazione=new Th();
        intestazione.setId("commessa_numero");
        intestazione.setCampo_db("attivita.commessa");
        intestazione.setTesto("Commessa");
        intestazione.setTipo(Th.tipo_TEXT);        
        intestazione.setOrdinamento(2);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
                   
    intestazione=new Th();
        intestazione.setId("descrizione");
        intestazione.setCampo_db("attivita.descrizione");
        intestazione.setTesto("Descrizione");
        intestazione.setTipo(Th.tipo_TEXT);
        intestazione.setOrdinamento(2);
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
        
    intestazione=new Th();
        intestazione.setId("qta");
        intestazione.setCampo_db("commesse.note");
        intestazione.setTesto("Qta");
        intestazione.setTipo(Th.tipo_TEXT);
        intestazione.setOrdinamento(3);    
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);
        


    intestazione=new Th();
        intestazione.setId("note");
        intestazione.setCampo_db("attivita.note");
        intestazione.setTesto("Note");
        intestazione.setTipo(Th.tipo_TEXT);
        intestazione.setOrdinamento(3);    
        intestazione.setValore_iniziale(Utility.eliminaNull(request.getParameter(intestazione.getCampo_db())));
        lista_th.add(intestazione);

        

    String tabella="attivita";


%>
<script type="text/javascript">
    
     function ricerca(){        
        var query="";
        <%for(Th th:lista_th){
            if(th.getTipo().equals(Th.tipo_TEXT)){%>
                var id="<%=th.getId()%>";
                var campo_db="<%=th.getCampo_db()%>";
                var valore=$("#"+id).val();                                
                var valore_temp=valore.split(' ').join(".+");
                if(valore!=="")
                    query=query+" "+campo_db+" REGEXP  '("+valore_temp+")' AND ";         
            <%}%>
                
            <%if(th.getTipo().equals(Th.tipo_NUMBER)){%>
                var id="<%=th.getId()%>";                
                var campo_db="<%=th.getCampo_db()%>";
                var condizione=$("#"+id+"_condizione").val();                
                var valore=$("#"+id).val();                
                if(valore!=="")
                    if(id==="durata"){
                        var ore=Math.floor(valore);
                        var minuti=valore%1;
                        query=query+" ore "+condizione+" "+ore+" AND ";                
                        if(minuti>0){
                            minuti="30";
                            query=query+" minuti>="+minuti+" AND ";                
                        }
                    }else{
                        query=query+" "+campo_db+" "+condizione+" "+valore+" AND ";                
                    }
            <%}%>
                
                
            <%if(th.getTipo().equals(Th.tipo_SELECT)){%>
                var id="<%=th.getId()%>";
                var campo_db="<%=th.getCampo_db()%>";
                var valore=$("#"+id).val();                
                if(valore!=="")
                    query=query+" "+campo_db+"='"+valore+"' AND ";                
            <%}%>
                
            <%if(th.getTipo().equals(Th.tipo_DATE)){%>
                var id="<%=th.getId()%>";
                var campo_db="<%=th.getCampo_db()%>";
                var valore_dal=$("#"+id+"_dal").val();                
                var valore_al=$("#"+id+"_al").val();                
                if(valore_dal!=="")
                    query=query+" "+campo_db+" >='"+valore_dal+"' AND ";                                                    
                if(valore_al!=="")
                    query=query+" "+campo_db+" <='"+valore_al+"' AND ";
            <%}%>                
        <%}%>
            
        query=query+" <%=tabella%>.stato='1' ";
        var ordinamento=$("#ordinamento").val();        
        var limit=$("#limit").val();
        mostraloader("Ricerca in corso...");
        $("#tabella_tbody").load("<%=Utility.url%>/attivita/_lista_attivita.jsp?query="+encodeURIComponent(String(query))+"&ordinamento="+encodeURIComponent(String(ordinamento))+"&limit="+encodeURIComponent(String(limit))+" #tabella_tbody tr",
            function(){nascondiloader();}
        );
    }
    
    function cambia_pagina(numero_pagina){              
        var query=$("#query").val();        
        var ordinamento=$("#ordinamento").val();        
        var limit=<%=Utility.numero_righe_pagine%>*numero_pagina;        
        mostraloader("Cambio pagina in corso...");
        $("#tabella_tbody").load("<%=Utility.url%>/attivita/_lista_attivita.jsp?query="+encodeURIComponent(String(query))+"&ordinamento="+encodeURIComponent(String(ordinamento))+"&limit="+encodeURIComponent(String(limit))+" #tabella_tbody tr",
            function(){nascondiloader();}
        );        
    }
    function cambia_ordinamento(inField,new_ordinamento){              
        $(".pulsante_ordinamento").removeClass("colore");
        $(inField).addClass("colore");
        $("#limit").val(0);
        $("#ordinamento").val(new_ordinamento);
        ricerca();
    }
    
    function stampa_lista_attivita(){
        var query=$("#query").val();
        window.open("<%=Utility.url%>/attivita/_stampa_lista_attivita.jsp?query="+encodeURIComponent(String(query)),"_blank");
    }
   
</script>


<div class="box">
    <button class="pulsante" onclick="stampa_lista_attivita()">Stampa</button>
</div>

<div class="height10"></div>

<table class="tabella" style="table-layout: fixed">
    <thead>
        <tr>
            <th style="width: 50px"></th>
            <%
            double totale=0;    
            for(Th th:lista_th){%>
                <th style="width: <%=th.getWidth()%>">

                    <div style="position: absolute;margin-right: 2px;margin-top: 2px;">
                        <button class="pulsante_ordinamento <%if(ordinamento.contains(th.getCampo_db()+" DESC")){%>colore<%}%>" onclick="cambia_ordinamento(this,'<%=th.getCampo_db()%> DESC')" >
                                 <img src="<%=Utility.url%>/images/up.png" >
                         </button>
                         <button class="pulsante_ordinamento <%if(ordinamento.contains(th.getCampo_db()+" ASC")){%>colore<%}%>" onclick="cambia_ordinamento (this,'<%=th.getCampo_db()%> ASC')">
                                 <img src="<%=Utility.url%>/images/down.png" >
                         </button>
                    </div>

                    
                    <div style="text-align: center;">
                        <%=th.getTesto()%>                        
                    </div>

                    <%if(th.getTipo().equals(Th.tipo_TEXT)){%>
                        <input type="text" id="<%=th.getId()%>" onchange="ricerca()" value="<%=th.getValore_iniziale()%>">
                    <%}%>
                    <%if(th.getTipo().equals(Th.tipo_NUMBER)){%>
                        <select id="<%=th.getId()%>_condizione" onchange="ricerca()" style="width: 50px;">
                            <option value=''></option>
                            <option value="<"><</option>
                            <option value=">">></option>
                            <option value="<="><=</option>
                            <option value=">=">>=</option>
                        </select>
                        <input type="number" id="<%=th.getId()%>" onchange="ricerca()">
                    <%}%>
                    <%if(th.getTipo().equals(Th.tipo_DATE)){%>
                        <input type="date" id="<%=th.getId()%>_dal" onchange="ricerca()" value="<%=th.getValore_iniziale()%>">
                        <div class="clear"></div>
                        <input type="date" id="<%=th.getId()%>_al" onchange="ricerca()" value="">
                    <%}%>

                    <%if(th.getTipo().equals(Th.tipo_SELECT)){
                        if(th.getCampo_db().equals("attivita.risorsa")){%>
                            <select id="<%=th.getId()%>" onchange="ricerca()">
                            <option value=""></option>
                                <%for(String opzione:th.getOpzioni()){%>
                                    <option value="<%=opzione%>" <%if(th.getValore_iniziale().equals(opzione)){%>selected="true"<%}%>><%=risorse.get(opzione).getNome()%></option>
                                <%}%>
                            </select>
                        <%}else{%>
                        <select id="<%=th.getId()%>" onchange="ricerca()">
                            <option value=""></option>
                            <%for(String opzione:th.getOpzioni()){%>
                                <option value="<%=opzione%>" <%if(th.getValore_iniziale().equals(opzione)){%>selected="true"<%}%>><%=opzione%></option>
                            <%}%>
                        </select>
                        <%}%>
                    <%}%>

              
                </th>
            <%}%>
        </tr>
    </thead>
    <tbody id="tabella_tbody">
        <%if(!query.equals("")){%>
            <%for(Attivita attivita:lista_attivita){%>
            <%

            totale=totale+attivita.getDurata();
            %>
            <tr>
                <td>                        
                    <button class='pulsantesmall' onclick="mostrapopup('<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita.getId()%>','Attività ID:<%=attivita.getId()%>')">                            
                        <img src="<%=Utility.url%>/images/edit.png">
                    </button>
                </td>
                <td style="height: 22px">                                                
                    <%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%>                                                
                </td>
                <td>
                    <div class="tagsmall"><%=Utility.formatta_durata(attivita.getDurata())%> h</div>
                    
                </td>
                <td>                                                
                    <%=Utility.convertiDatetimeFormatoIT(attivita.getFine())%>                        
                </td>          
                <td>                                                
                    <%if(!attivita.getCommessa().getData_consegna().contains("0001")){
                        out.println(Utility.convertiDatetimeFormatoIT(attivita.getCommessa().getData_consegna()));
                    }%>                        
                </td>          
                <td>
                    <%=attivita.getCommessa().getSoggetto().getAlias()%>
                </td>
                <td>
                    <div class="tag" style="background-color:<%=attivita.getCommessa().getColore()%>;">
                        <%=attivita.getCommessa().getNumero()%>
                    </div>
                </td>   
                <td>
                    <%=attivita.getDescrizione()%>
                </td>
                <td>
                    <%=attivita.getCommessa().getNote()%>
                </td>
                <td>
                    <%if(!attivita.getNote().equals("null")){
                        out.println(attivita.getNote());                        
                    }%>
                </td>  
            </tr>                
        <%}%>
        <tr>
            <td colspan='2'></td>
            <td>
                <div class="tagsmall"><%=Utility.elimina_zero(totale)%> h</div>
            </td>
            <td colspan="7"></td>
        </tr>
        <%}%>                   
        <tr>
            <td colspan="<%=lista_th.size()+1%>">

                <input type='hidden' id='query' value="<%=query%>" style="width: 100%;">
                <input type='hidden' id='ordinamento' value="<%=ordinamento%>" style="width: 100%;">
                <input type='hidden' id='limit' value="<%=limit%>" style="width: 100%;">

                <div class="height10"></div>
                Sono state trovate <%=(int)numero_righe%> righe su <%=(int)numero_pagine%> pagine
                <div class="height10"></div>
                 <%                       
                    int pagina_corrente=Utility.convertiStringaInInt(limit)/Utility.numero_righe_pagine;                    
                    for(int i=0;i<numero_pagine;i++){%>
                        <button class="float-left pulsantesmall eee<%if(pagina_corrente==i){%>colore<%}%>" onclick="cambia_pagina('<%=i%>');"><%=i+1%></button>
                <%}%>

            </td>
        </tr>
    </tbody>

</table>


