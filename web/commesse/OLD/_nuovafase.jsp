<%
    String commessa=Utility.eliminaNull(request.getParameter("commessa"));
    String elemento=Utility.eliminaNull(request.getParameter("elemento"));
%>


<%@page import="utility.Utility"%>
<script type="text/javascript">
    function nuovafase(){
       var descrizione=$("#descrizione").val();
       var durata=$("#descrizione").val();

       if(descrizione==="" || durata===""){
           alert("Impossibile inserire la fase.\nInserisci correttamente descrizione e durata.");
           return;
       }
       mostraloader("Operazione in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/commesse/__nuovafase.jsp",
            data: $("#form_nuovafase").serialize(),
            dataType: "html",
            success: function(msg){
                $.when(aggiornaelementi()).then(
                    function(){
                        nascondipopup();
                    });
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovafase()");
            }
        });
		
    }
</script>

<form id="form_nuovafase">

    <input type="hidden" name="commessa" value="<%=commessa%>">
    <input type="hidden" name="elemento" value="<%=elemento%>">
    
    <div class="etichetta">Descrizione</div>
    <div class="valore"><input type="text" id="descrizione" name="descrizione"></div>

    <div class="etichetta">Durata</div>
    <div class="valore"><input type="number" id="durata" name="durata"></div>

    <div class="etichetta">Note</div>
    <div class="valore">
        <textarea id="note" name="note"></textarea>
    </div>

    <button class="pulsante float-right" type="button" onclick="nuovafase();">Conferma</button>
    <div class="clear"></div>
</form>