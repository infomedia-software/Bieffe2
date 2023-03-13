
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneActCel"%>

<script type="text/javascript">
    
    function new_act_res(){
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/act_res/__new_act_res.jsp",
            data: $("#form_new_act_res").serialize(),
            dataType: "html",
            success: function(msg){
                location.reload();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE new_act_res");
            }
        });
    }
		
</script>

<div class="box">
    <form id="form_new_act_res">
        
        <div class="etichetta">Codice</div>
        <div class="valore">
            <input type="text" name="codice" id="codice">
        </div>

        <div class="etichetta">Nome</div>
        <div class="valore">
            <input type="text" name="nome" id="nome">
        </div>

        <%for(int i=0;i<=47;i++){%>
            <div style="width: fit-content;float: left;">
                <div class="etichetta"><%=GestioneActCel.calcola_orario_act_cel_from_indice(i)%> / <%=GestioneActCel.calcola_orario_act_cel_from_indice(i+1)%></div>
                <div class="valore">
                    <input type="checkbox" name="<%="c"+i%>" class="c_act_res" value="attivo" >
                </div>
            </div>
        <%}%>        

        <button class="pulsante float-right nuovo" type="button" onclick="new_act_res()">Conferma</button>
    </form>
    
</div>