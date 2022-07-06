

<%@page import="utility.Th"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%    
        
    String query_input=Utility.eliminaNull(request.getParameter("query"));
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));    
    String limit=Utility.eliminaNull(request.getParameter("limit"));
    
    String query=query_input+" ORDER BY "+ordinamento+" LIMIT "+limit+","+Utility.numero_righe_pagine;
    
    double numero_righe=0;
    double numero_pagine=0;
    
       
    numero_righe=GestioneCommesse.getIstanza().ricerca(query_input).size();   
    numero_pagine=(int)Math.ceil(numero_righe/Utility.numero_righe_pagine); 
   
    String tabella="commesse";
    
    ArrayList<Th> lista_th=new ArrayList<Th>();
    
    Th temp=new Th();
        temp.setId("numero");
        temp.setCampo_db("commesse.numero");
        temp.setTesto("Codice");
        temp.setTipo(Th.tipo_TEXT);
        temp.setOrdinamento(0);
        temp.setWidth("135px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
      
    temp=new Th();
        temp.setId("cliente");
        temp.setCampo_db("soggetti.alias");
        temp.setTesto("Clienti");
        temp.setTipo(Th.tipo_TEXT);
        temp.setOrdinamento(1);
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
        
        
    temp=new Th();
        temp.setId("descrizione");
        temp.setCampo_db("commesse.descrizione");
        temp.setTesto("Descrizione");
        temp.setTipo(Th.tipo_TEXT);
        temp.setOrdinamento(1);
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);

        
    temp=new Th();
        temp.setId("note");
        temp.setCampo_db("commesse.note");
        temp.setTesto("Note");
        temp.setTipo(Th.tipo_TEXT);
        temp.setOrdinamento(1);
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);   
        
    temp=new Th();
        temp.setId("situazione");
        temp.setCampo_db("commesse.situazione");
        temp.setTesto("Situazione");
        temp.setTipo(Th.tipo_SELECT);        
            temp.getOpzioni().add("programmata");
            temp.getOpzioni().add("daprogrammare");
            temp.getOpzioni().add("conclusa");
        temp.setOrdinamento(4);    
        temp.setWidth("135px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
        

    ArrayList<Commessa> commesse=GestioneCommesse.getIstanza().ricerca(query);

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
                    query=query+" "+campo_db+" "+condizione+" "+valore+" AND ";                
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
        $("#tabella_tbody").load("<%=Utility.url%>/commesse/_commesse.jsp?query="+encodeURIComponent(String(query))+"&ordinamento="+encodeURIComponent(String(ordinamento))+"&limit="+encodeURIComponent(String(limit))+" #tabella_tbody tr",
            function(){nascondiloader();}
        );
    }
    
    function cambia_pagina(numero_pagina){      
        $("#limit").val(<%=Utility.numero_righe_pagine%>*numero_pagina);
        ricerca();
    }
    function cambia_ordinamento(inField,new_ordinamento){              
        $(".pulsante_ordinamento").removeClass("colore");
        $(inField).addClass("colore");
        $("#limit").val(0);
        $("#ordinamento").val(new_ordinamento);
        ricerca();
    }
    
    
    function cancellacommessa(idcommessa){
         if(confirm('Procedere alla cancellazione della commessa?')){
            var newvalore="-1";
            var campodamodificare="stato";
            mostraloader("Cancellazione in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/commesse/__modificacommessa.jsp",
                data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id="+idcommessa,
                dataType: "html",
                success: function(msg){
                    location.href='<%=Utility.url%>/commesse/commesse.jsp';
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacommessa()");
                }
            });
            }
    }
</script>



<div class="height10"></div>

    
    
    <table class="tabella" style="table-layout: fixed">
        <thead>
            <tr>
                <th style="width: 50px"></th>
                <%for(Th th:lista_th){%>
                    <th style="width: <%=th.getWidth()%>">
                        
                        <%=th.getTesto()%>
                        
                        <div class="clear"></div>                        
                            <div class="float-left" style="width: calc(100% - 20px)">
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
                                <input type="text" id="<%=th.getId()%>" onchange="ricerca()">
                            <%}%>
                            <%if(th.getTipo().equals(Th.tipo_DATE)){%>
                                <input type="date" id="<%=th.getId()%>_dal" onchange="ricerca()">
                                <input type="date" id="<%=th.getId()%>_al" onchange="ricerca()">
                            <%}%>
                            
                            <%if(th.getTipo().equals(Th.tipo_SELECT)){%>
                                <select id="<%=th.getId()%>" onchange="ricerca()">
                                    <option value=""></option>
                                    <%for(String opzione:th.getOpzioni()){%>
                                        <option value="<%=opzione%>" <%if(th.getValore_iniziale().equals(opzione)){%>selected="true"<%}%>><%=opzione%></option>
                                    <%}%>
                                </select>
                            <%}%>
                            </div>
                            <div class="float-right">
                                <button class="pulsante_ordinamento <%if(ordinamento.contains(th.getCampo_db()+" DESC")){%>colore<%}%>" onclick="cambia_ordinamento(this,'<%=th.getCampo_db()%> DESC')" >
                                    <img src="<%=Utility.url%>/images/up.png" >
                                </button>
                                <button class="pulsante_ordinamento <%if(ordinamento.contains(th.getCampo_db()+" ASC")){%>colore<%}%>" onclick="cambia_ordinamento (this,'<%=th.getCampo_db()%> ASC')">
                                    <img src="<%=Utility.url%>/images/down.png" >
                                </button>
                            </div>
                        
                    </th>
                <%}%>
            </tr>
        </thead>
        <tbody id="tabella_tbody">
            <%if(!query.equals("")){%>
                <%for(Commessa c:commesse){%>
                    <tr>
                        <td style='width: 50px;'>
                            <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=c.getId()%>' class='pulsanteimg'>
                                <img src="<%=Utility.url%>/images/edit.png" alt='' >
                            </a>
                        </td>
                        <td>
                            <div class="tag" style="background-color:<%=c.getColore()%>"><%=c.getNumero()%></div></td>
                        <td>
                            <%
                            if(!c.getSoggetto().getId().equals(""))
                                out.print(c.getSoggetto().getAlias());                        
                            %>
                        </td>
                        <td><%=c.getDescrizione()%></td>                        
                        <td><%=c.getNote()%></td>                        
                        <td>
                            <%if(c.getSituazione().equals("programmata")){%>
                                <div class='tag green'>Programmata</div>
                            <%}%>
                            <%if(c.getSituazione().equals("daprogrammare")){%>
                                <div class='tag yellow'>Da Programmare</div>
                            <%}%>
                            <%if(c.getSituazione().equals("conclusa")){%>
                                <div class='tag commessa'>Conclusa</div>
                            <%}%>
                        </td>                       
                    </tr>
                <%}%>        
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


      