//= require jquery3
//= require jquery_ujs
//= require_tree .

/*
$(document).ready(function(){
    $('.className').on('click', function(){
        console.log("inside js click listener");

       $.post('superman', { field1: "hello", field2 : "hello2"}, 
       function(returnedData){
            console.log(returnedData);
       });
        
    });
});
*/
$(document).ready(function(){
    $('#button_to_be_clicked').on('click', function(){
        console.log("inside js click listener");
        // ajax request 
        
        $.ajax({
            url: "/superman",
            type: "POST",
            data : {
                value1: "hello",
                value2: "hello2"            
            },
            dataType: "script",
            success: function(data){
                console.log("successfull ajax.");
                console.log(data);
                document.getElementById("change_this").innerHTML = data;
            },
        }); //ajax request over

   })
});

function onLoadConfigPress(url){
    console.log("onLoadConfigPress, data=", url);
    //get substring id from url //https://www.discogs.com/Ash-Deja-Vu/release/5298910
    //get index of first slash '/' counting backwards
    var firstSlashIndex = 0;
    var i = 0;
    var count = 0;
    for (i = url.length - 1; i >= 0; i--){
        count++;
        //console.log("i = ", i, ". url[i] = ", url[i], ". firstSlashIndex = ", firstSlashIndex);
        if(firstSlashIndex == 0 && url[i] == "/"){
            firstSlashIndex = count;  
        }
    }
    var url_release_id = url.substr(url.length - firstSlashIndex+1);
    console.log("url_release_id = ", url_release_id);
    //make ajax request with url
    $.ajax({
        url: "/superman",
        type: "POST",
        data : {
            value1: url_release_id,
            value2: "hello2"            
        },
        dataType: "script",
        success: function(data){
            console.log("successfull ajax.");
            console.log(data);
            document.getElementById("change_this").innerHTML = data;
        },
    }); //ajax request over


    return false;
}

function parseURL(data){
    console.log("inside parseURL function, data = ", data);
    return "tempReturn"

}

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
