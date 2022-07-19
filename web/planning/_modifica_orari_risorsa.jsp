
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    Risorsa r=GestioneRisorse.getIstanza().ricercaRisorse( "risorse.id="+risorsa).get(0);
    
    String planning_ultima_data=Utility.getIstanza().querySelect(" SELECT MAX(DATE(inizio)) AS planning_ultima_data FROM planning WHERE 1 ", "planning_ultima_data");
    

%>

<script type="text/javascript">
    function modifica_orari_risorsa(){
        
        var inizio="";
        var fine="";
        var inizio2="";
        var fine2="";
        
        var turno1_inizio_string=$("#turno1_inizio").val();
        var turno1_fine_string=$("#turno1_fine").val();
        var turno2_inizio_string=$("#turno2_inizio").val();
        var turno2_fine_string=$("#turno2_fine").val();        
        
        var turno1_inizio=99;
                
        turno1_inizio=parseInt(turno1_inizio_string);
        turno1_fine=parseInt(turno1_fine_string);
        
        var turno2_inizio=-1;
        if(turno2_inizio_string!=="-1")
            turno2_inizio=parseInt(turno2_inizio_string);
        
        var turno2_fine=-1;
        if(turno2_fine_string!=="-1")
            turno2_fine=parseInt(turno2_fine_string);
      
        var errore="";
      
        if(turno1_inizio<turno1_fine && turno1_inizio!==-1 && turno1_fine!==-1){
            
            if(turno2_inizio!==-1 && turno2_fine!==-1){
                if(turno1_fine<turno2_inizio && turno2_inizio<turno2_fine){
                    
                }else{
                    errore="Impossibile proseguire nella modifica.\nTurno 2 non correttamente configurato";
                }
            }            
        }else{
            errore="Impossibile proseguire nella modifica.\nTurno 1 non correttamente configurato";
        }
                
        if(errore!==""){
            alert(errore);    
            return;
        }else{
            if(confirm("Procedere alla modifica degli orari della risorsa?")){
                mostraloader("Operazione in corso...");
                var applica_sempre=$("#applica_sempre").is(":checked");                        
                inizio=calcola_ora(turno1_inizio);
                fine=calcola_ora(turno1_fine);
                inizio2=calcola_ora(turno2_inizio);
                fine2=calcola_ora(turno2_fine);            
                var planning_ultima_data=$("#planning_ultima_data").val();
                $.ajax({
                   type: "POST",
                   url: "<%=Utility.url%>/planning/__modifica_orari_risorsa.jsp",
                   data: "planning_ultima_data="+planning_ultima_data+"&risorsa=<%=risorsa%>&data=<%=data%>&campodamodificare=valore&newvalore=1&inizio="+inizio+"&fine="+fine+"&inizio2="+inizio2+"&fine2="+fine2+"&applica_sempre="+applica_sempre,
                   dataType: "html",
                   success: function(msg){
                       aggiornaplanning();
                   },
                   error: function(){
                       alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE disabilitarisorsa");
                       }
                   });
                }                        
            }
    }
    
    
    function calcola_ora(temp){
        var toReturn="";
        if(temp!==-1){
            if(temp%2!=0)
                toReturn=":30";
            else
                toReturn=":00";
            var tt=parseInt(temp/2);
            if(tt<10)
                tt="0"+tt;
            toReturn=tt+toReturn;
        }
        return toReturn;
    }
    
       
    function seleziona_orari(inizio,fine,inizio2,fine2){        
        $("#turno1_inizio").val(inizio);
        $("#turno1_fine").val(fine);
        $("#turno2_inizio").val(inizio2);
        $("#turno2_fine").val(fine2);
    }
       

    function disabilita_risorsa(){
        var risorsaselezionata="<%=risorsa%>";
        var data="<%=data%>";
        var applica_sempre=$("#applica_sempre").is(":checked");                        
        var planning_ultima_data=$("#planning_ultima_data").val();
        if(confirm("Procedere alla disabilitazione della risorsa?")){
            mostraloader("Operazione in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__modifica_orari_risorsa.jsp",
                data: "planning_ultima_data="+planning_ultima_data+"&risorsa="+risorsaselezionata+"&data="+data+"&campodamodificare=valore&newvalore=-1&applica_sempre="+applica_sempre,
                dataType: "html",
                success: function(msg){
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE disabilitarisorsa");
                }
            });
        }
    }
    
</script>


<div class="box">

    
    <input type="hidden" readonly="true" id="planning_ultima_data" tabindex="-1" value="<%=planning_ultima_data%>">
    
    <div class="width50 float-left">    
        <div class="etichetta">Risorsa</div>
        <div class="valore"><input type="text" readonly="true" tabindex="-1" value="<%=r.getNome()%>"></div>

        <div class="etichetta">Data</div>
        <div class="valore"><input type="text" readonly="true" tabindex="-1" value="<%=Utility.convertiDataFormatoIT(data)%>"></div>                
    </div>
    
    
    <div class="valore" style="margin-left: 120px">
        <button class="pulsante" onclick="seleziona_orari('19','39','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 09:30 - 19:30
        </button>
         <button class="pulsante" onclick="seleziona_orari('14','24','26','33')" style="width: 200px;margin: 5px;">
            Abilita 07:00 - 12:00 / 13:00 - 16:30
        </button> 
        
        <button class="pulsante" onclick="seleziona_orari('12','27','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 06:00 - 13:30
        </button>
        <button class="pulsante" onclick="seleziona_orari('27','42','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 13:30 - 21:00
        </button>                  
        <button class="pulsante" onclick="seleziona_orari('12','46','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 06:00 - 23:00
        </button>             
        <button class="pulsante" onclick="seleziona_orari('12','42','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 06:00 - 21:00
        </button>             
        <button class="pulsante" onclick="seleziona_orari('16','24','27','35')" style="width: 200px;margin: 5px;">
            Abilita 08:00 - 12:00 / 13:30 - 17:30
        </button>             
        <button class="pulsante" onclick="seleziona_orari('16','24','24','34')" style="width: 200px;margin: 5px;">
            Abilita 08:00 - 12:00 / 13:00 - 17:00
        </button>  
        <button class="pulsante" onclick="seleziona_orari('0','47','-1','-1')" style="width: 200px;margin: 5px;">
            Abilita 00:00 - 23:30
        </button>  
        <button class="pulsante float-left red fit-content" onclick="disabilita_risorsa()" style="width: 200px;margin: 5px;">
            <img src="<%=Utility.url%>/images/stop.png" class="custom-menu-icon">
            Disabilita Risorsa
        </button>    
    </div>

    <div class="height10"></div>
        
    <div class="etichetta">Turno 1</div>
    <div class="valore">
        <select id="turno1_inizio" name="turno1_inizio" style="width: 100px">
            <%    
            int ora=0;
            for(int i=0;i<48;i++){%>
                <option value="<%=i%>"><%=ora%>:<%if(i%2==0){%>00<%}else{ora++;%>30<%}%></option>
            <%}%>
        </select>    
        -     
        <select id="turno1_fine" name="turno1_fine" style="width: 100px">
            <%ora=0;
            for(int i=0;i<48;i++){%>
                <option value="<%=i%>"><%=ora%>:<%if(i%2==0){%>00<%}else{ora++;%>30<%}%></option>
            <%}%>
        </select>    
    </div>


    <div class="etichetta">Turno 2</div>
    <div class="valore">
        <select id="turno2_inizio" name="turno2_inizio" style="width: 100px">
            <option value="-1"></option>
            <%ora=0;
            for(int i=0;i<48;i++){%>
                <option value="<%=i%>"><%=ora%>:<%if(i%2==0){%>00<%}else{ora++;%>30<%}%></option>
            <%}%>
        </select>    
        -     
        <select id="turno2_fine" name="turno2_fine" style="width: 100px">
            <option value="-1"></option>
            <%ora=0;
            for(int i=0;i<48;i++){%>
                <option value="<%=i%>"><%=ora%>:<%if(i%2==0){%>00<%}else{ora++;%>30<%}%></option>
            <%}%>
        </select>    
    </div>

    <div class="etichetta"></div>
    <div class="valore">
        <input type="checkbox" id="applica_sempre"> Applica per tutti i giorni a partire dal <%=Utility.convertiDataFormatoIT(data)%> al <%=Utility.convertiDataFormatoIT(planning_ultima_data)%>
    </div>        
    <button class="pulsante float-right" type="button" onclick="modifica_orari_risorsa();">Conferma</button>
</div>
