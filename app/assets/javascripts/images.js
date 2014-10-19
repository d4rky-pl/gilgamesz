$(document).ready(function(){
    Dropzone.autoDiscover = false;

    $(".dropzone").dropzone({
        maxFilesize: 3,
        paramName: "image[file]",
        addRemoveLinks: true,
        success: function(file, response){
            $(file.previewTemplate).find('.dz-remove').attr('id', response.fileID);
            $(file.previewElement).addClass("dz-success");
        },
        removedfile: function(file){
            var id = $(file.previewTemplate).find('.dz-remove').attr('id');
            $.ajax({
                type: 'DELETE',
                url: '/images/' + id,
                success: function(data){
                    console.log(data.message);
                }
            });
        }
    });
});