<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<title>jQuery File Upload Example</title>

<!-- Importazioni Base-->
<script src="js/jquery.js"></script>
<script src="js/vendor/jquery.ui.widget.js"></script>
<script src="js/jquery.iframe-transport.js"></script>
<script src="js/jquery.fileupload.js"></script>

<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="js/load-image.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="js/canvas-to-blob.min.js"></script>
<!-- The File Upload processing plugin -->
<script src="js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="js/jquery.fileupload-image.js"></script>

<style>
    #button_fileupload{
        background-color:#0083b9;
        color:white;
        font-size:20px;    
        height: 50px;
        width: 100px;
        text-align: center;
        position: absolute;
        top: 5px;
        left: 5px;
        margin: 0;
        cursor: pointer;
    }
    #button_fileupload input{
        position: absolute;
        top: 5px;
        left: 5px;
        margin: 0;
        height: 50px;
        width: 100px;
        font-size: 12px;
        direction: ltr;
        opacity: 0;
        -ms-filter: 'alpha(opacity=0)';
        cursor: pointer;
    }
</style>


<script>
$(function () {
    $('#fileupload').fileupload({   
        done: function (e, data) {
        },
        disableImageResize: /Android(?!.*Chrome)|Opera/
        .test(window.navigator && navigator.userAgent),
        imageMaxWidth: 800,
        imageMaxHeight: 600,
        imageCrop: false // Force cropped images
    });
});
</script>
</head>
<body>
    <div id="button_fileupload" >
        Aggiungi Foto
        <input id="fileupload" type="file" name="files[]" data-url="uploadFoto_admin.jsp" multiple>
    </div>

</body> 
</html>