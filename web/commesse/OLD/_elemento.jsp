<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="beans.CommessaElemento"%>
<%
    String idelemento=Utility.eliminaNull(request.getParameter("idelemento"));
    
    CommessaElemento ce=GestioneCommesse.getIstanza().ricercaElementi(" id="+idelemento).get(0);
%>

<script type="text/javascript">
      function modificaelemento(inField){                
            var newvalore=inField.value;
            var campodamodificare=inField.id;
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/commesse/__modificaelemento.jsp",
                data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=idelemento%>",
                dataType: "html",
                success: function(msg){
                    aggiornaelementi();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacommessa()");
                }
            });
        }
</script>

<div class="etichetta">Codice</div>
<div class="valore">
    <input type="text" id="codice" value="<%=ce.getCodice()%>" onchange="modificaelemento(this);">
</div>

<div class="etichetta">Descrizione</div>
<div class="valore">
    <input type="text" id="descrizione" value="<%=ce.getDescrizione()%>" onchange="modificaelemento(this);">
</div>

<div class="etichetta">Note</div>
<div class="valore">
    <textarea id="note" onchange="modificaelemento(this);"><%=ce.getNote()%></textarea>
</div>
