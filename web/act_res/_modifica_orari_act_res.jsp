<%@page import="java.util.Map"%>
<%@page import="gestioneDB.GestioneActCel"%>
<%@page import="beans.ActRes"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="utility.Utility"%>
<%
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    ActRes act_res=GestioneActRes.getIstanza().get_act_res(id_act_res);   

    Map<String,ActRes> mappa_ac_res=GestioneActRes.getIstanza().act_res_data(data);
    ActRes act_res_orari_data=mappa_ac_res.get(id_act_res);
    
    String max_data=Utility.getIstanza().querySelect("SELECT max(data) FROM act_cal ", "max_data");
%>

<script type="text/javascript">
    function function_modifica_orari_act_res(){
        mostraloader("Aggiornamento in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/act_res/__modifica_orari_act_res.jsp",
            data: $("#form_modifica_orari_act_res").serialize(),
            dataType: "html",
            success: function(msg){
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_orari_act_res");
            }
        });
    }
    
    function orari(inizio,fine){        
        for(var i=0;i<=47;i++){
            if(i>=inizio && i<=fine){
                $("#c"+i).prop('checked',true);
            }else{
                $("#c"+i).prop('checked',false);
            }
        }
    }
    
    function orari2(inizio,fine,inizio2,fine2){        
        for(var i=0;i<=47;i++){
            if(i>=inizio && i<=fine){
                $("#c"+i).prop('checked',true);
            }else{
                $("#c"+i).prop('checked',false);
            }
        }
        for(var i=inizio2;i<=47;i++){
            if(i>=inizio2 && i<=fine2){
                $("#c"+i).prop('checked',true);
            }else{
                $("#c"+i).prop('checked',false);
            }
        }
    }
    
    function disabilita_act_res(){
        if(confirm("Procedere alla disabilitazione della risorsa?")){
            $(".c_act_res").prop( "checked", false );
            function_modifica_orari_act_res();
        }
    }
    
</script>

 <div class="box">    
     
     <form id="form_modifica_orari_act_res">
        <input type="hidden" name="id_act_res" value="<%=id_act_res%>">
        <input type="hidden" name="data" value="<%=data%>">
               
        
        
        <div class="etichetta">Risorsa</div>
        <div class="valore"><span><%=act_res.toString()%></span></div>
        
        <div class="etichetta">Orari Standard</div>
        <div class="valore">
            <button class="pulsante_tabella" type="button" onclick="orari('10','25')">05:00/13:00</button>            
            <button class="pulsante_tabella" type="button" onclick="orari('26','41')">13:00/21:00</button>   
            
            <button class="pulsante_tabella" type="button" onclick="orari('16','31')">08:00/16:00</button>            
            <button class="pulsante_tabella" type="button" onclick="orari2('16','23','28','35');">08:00/12:00 - 14:00/18:00</button>            
            <!--button class="pulsante_tabella" type="button" onclick="orari('26','35')">13:00/18:00</button-->            
            <button class="pulsante_tabella red" type="button" onclick="disabilita_act_res()">Disabilita </button>            
        </div>
                        
        
       <%for(int i=0;i<=47;i++){%>
           <div style="width: fit-content;float: left;">
               <div class="etichetta" title="indice: <%=i%>"><%=GestioneActCel.calcola_orario_act_cel_from_indice(i)%> / <%=GestioneActCel.calcola_orario_act_cel_from_indice(i+1)%></div>
               <div class="valore">
                   <input type="checkbox" name="<%="c"+i%>" id="<%="c"+i%>"  class="c_act_res" value="attivo" <%if(act_res_orari_data.getCelle().get("c"+i).equals("")){%> checked="true" <%}%>>
               </div>
           </div>
       <%}%>        

       <div class="clear"></div>
       <div class="etichetta">Dal / Al </div>       
       <div class="valore">
           <input type="date" name="dal" value="<%=data%>" min="<%=Utility.dataOdiernaFormatoDB()%>">
           <input type="date" name="al" value="<%=data%>" max="<%=max_data%>">
       </div>

       <button class="pulsante float-right" type="button" onclick="function_modifica_orari_act_res()">Salva</button>
    </form>
</div>

