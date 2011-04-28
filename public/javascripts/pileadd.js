function pileadd(){
    var sles=document.getElementsByName("community_box");
    var checked_ids = new Array();
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) {
            checked_ids.push(sles[i].value);
        }
    }
    document.getElementById("pass_form_pass_all").value = checked_ids;
}
function buttoncontrol(){
   
    var sles=document.getElementsByName("community_box");
    for (var i=0;i<sles.length;i++) {
        if (sles[i].checked) 
        document.getElementById("pass_form_submit").disabled=false;
    else
       document.getElementById("pass_form_submit").disabled=true;
    }

    
   
}