	
<%@page import="beans.Task"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="utility.Th"%>

<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
	
<%
    String query_input=Utility.eliminaNull(request.getParameter("query"));
    if(query_input.equals(""))
		query_input=" tasks.stato='1'";
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));    
	if(ordinamento.equals(""))
		ordinamento=" tasks.inizio ASC";
    String limit=Utility.eliminaNull(request.getParameter("limit"));
	if(limit.equals(""))
		limit="0";
	String ricerca=Utility.eliminaNull(request.getParameter("ricerca"));
    
    String query=query_input+" ORDER BY "+ordinamento+" LIMIT "+limit+","+Utility.numero_righe_pagine;
    
    double numero_righe=0;
    double numero_pagine=0;
    
       
    numero_righe=GestioneTasks.getIstanza().ricerca(query_input).size();   
    numero_pagine=(int)Math.ceil(numero_righe/Utility.numero_righe_pagine); 
   
    String tabella="tasks";
    
    ArrayList<Th> lista_th=new ArrayList<Th>();
    
	
    Th temp=new Th();
        temp.setId("id");
        temp.setCampo_db("tasks.id");
        temp.setTesto("ID Task");
        temp.setTipo(Th.tipo_TEXT);
        temp.setWidth("100px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
  
     
    temp=new Th();
        temp.setId("risorsa");
        temp.setCampo_db("risorse.nome");
        temp.setTesto("Risorsa");
        temp.setTipo(Th.tipo_TEXT);        
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
          
    temp=new Th();
        temp.setId("commessa");
        temp.setCampo_db("tasks.commessa");
        temp.setTesto("Commessa");
        temp.setTipo(Th.tipo_TEXT);        
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        temp.setWidth("400px");
        lista_th.add(temp);
        
             
    temp=new Th();
        temp.setId("cliente");
        temp.setCampo_db("clienti.alias");
        temp.setTesto("Clienti");
        temp.setTipo(Th.tipo_TEXT);        
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
        
        
    temp=new Th();
        temp.setId("attivita");
        temp.setCampo_db("attivita.descrizione");
        temp.setTesto("Attività");
        temp.setTipo(Th.tipo_TEXT);        
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
        
   temp=new Th();
        temp.setId("inizio");
        temp.setCampo_db("tasks.inizio");
        temp.setTesto("Inizio");
        temp.setTipo(Th.tipo_DATE);
        temp.setWidth("150px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
                
    // Data
   temp=new Th();
        temp.setId("fine");
        temp.setCampo_db("tasks.fine");
        temp.setTesto("Fine");
        temp.setTipo(Th.tipo_DATE);
        temp.setWidth("150px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);

    temp=new Th();
        temp.setId("attivo");
        temp.setCampo_db("tasks.attivo");
        temp.setTesto("Attivo");
        temp.setTipo(Th.tipo_SELECT);       
            temp.getOpzioni().add("si");                
        temp.setWidth("100px");
        temp.setValore_iniziale(Utility.eliminaNull(request.getParameter(temp.getCampo_db())));
        lista_th.add(temp);
    
    ArrayList<Task> lista=new ArrayList<Task>();
    if(!query.equals(""))
        lista=GestioneTasks.getIstanza().ricerca(query);
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
        
        $("#tabella_tbody").load("<%=Utility.url%>/tasks/_tasks.jsp?query="+encodeURIComponent(String(query))+"&ordinamento="+encodeURIComponent(String(ordinamento))+"&limit="+encodeURIComponent(String(limit))+" #tabella_tbody tr",
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
	
</script>




    
    <table class="tabella">
        <thead>
            <tr>
                <%for(Th th:lista_th){%>
                    <th style="width: <%=th.getWidth()%>">
                        
                        <%=th.getTesto()%>
                        
                        <div class="clear"></div>                        
                        
						     
                        <%if(!ricerca.equals("no")){%>			
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
                        <%}%>
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
        <tr>
            <td colspan="<%=lista_th.size()%>" >                     
                <input type='hidden' id='query' value="<%=query%>" style="width: 100%;">
                <input type='hidden' id='ordinamento' value="<%=ordinamento%>" style="width: 100%;">
                <input type='hidden' id='limit' value="<%=limit%>" style="width: 100%;">

                <div class="float-left" style="line-height: 40px;margin-right: 10px">
                    Sono state trovate <%=(int)numero_righe%> righe su <%=(int)numero_pagine%> pagine
                </div>
                <div class="float-left">
                    <%                       
                       int pagina_corrente=Utility.convertiStringaInInt(limit)/Utility.numero_righe_pagine;                    
                       for(int i=0;i<numero_pagine;i++){%>
                           <button class="float-left pulsantesmall eee<%if(pagina_corrente==i){%>colore<%}%>" onclick="cambia_pagina('<%=i%>');"><%=i+1%></button>
                   <%}%>
                </div>

            </td>
        </tr>        
        <tbody id="tabella_tbody">
            <%if(!query.equals("")){%>
			
                <%for(Task task:lista){%>
                    <tr>
                        <td><%=task.getId()%></td>
                        <td><%=task.getRisorsa().getCodice()%> <%=task.getRisorsa().getNome()%></td>
                        <td>
                            <%if(!task.getCommessa().getId().equals("")){%>
                                <div class="tagsmall float-left" style="background-color: <%=task.getCommessa().getColore()%>">
                                </div>
                                <div class="float-left" style="line-height: 22px;margin-left: 5px;">
                                    <%=task.getCommessa().getNumero()%> <%=task.getCommessa().getDescrizione()%>
                                </div>
                            <%}%>
                        </td>
                        <td>
                            <%if(!task.getCommessa().getId().equals("")){%>
                                <%=task.getCommessa().getSoggetto().getAlias()%>
                            <%}%>
                        </td>
                        <td><%=task.getAttivita().getId()%> <%=task.getAttivita().getDescrizione()%></td>
                        <td><%=Utility.convertiDatetimeFormatoIT(task.getInizio())%></td>
                        <td><%=Utility.convertiDatetimeFormatoIT(task.getFine())%></td>
                        <td>
                          
                            <a target='_blank' href='<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=task.getId_esterno()%>' class='pulsantesmall task float-left'>
                                <img src="<%=Utility.url%>/images/task.png">
                            </a>
                            <%if(task.getAttivo().equals("si")){%>
                                <div class="pulsantesmall green float-left">
                                    <img src="<%=Utility.url%>/images/v.png">
                                </div>
                            <%}%>
                        </td>
                    </tr>
                <%}%>									
				
            <%}%>
        
        </tbody>

    </table>


			

    