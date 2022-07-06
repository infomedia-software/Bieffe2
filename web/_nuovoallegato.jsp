<%@page import="utility.Utility"%>

<%
    String idrif=Utility.eliminaNull(request.getParameter("idrif"));
    String rif=Utility.eliminaNull(request.getParameter("rif"));    
%>

<script type='text/javascript'>
    
      $(function () {
        $('#fileupload').fileupload({   
            done: function (e, data) {
                $.each(data.files, function (index, file) {
                    var nomefile=data.result;                        
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/__nuovo_allegato.jsp",
                        data: "idrif=<%=idrif%>&rif=<%=rif%>&url="+encodeURIComponent(String(nomefile)),
                        dataType: "html",
                        success: function(msg){
                            aggiorna_allegati();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE fileupload");
                        }
                    });
                });
            },
            disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator && navigator.userAgent),
            imageMaxWidth: 800,
            imageMaxHeight: 600,
            imageCrop: false,
            progressall: function (e, data) {
                mostraloader("Caricamento Allegato in corso...");                
            }
        }); 
    });
    
    function uploadclick(){
        document.getElementById('fileupload').click();
    }
</script>
    
<div class="box">
    <input id="fileupload" style='display:none' type="file" name="files[]" data-url="<%=Utility.url%>/__upload.jsp" multiple >

    <button class='pulsante' onclick="uploadclick();">       
        <img src="<%=Utility.url%>/images/add.png">
        Nuovo Allegato        
    </button>
</div>
<div class='height10'></div>