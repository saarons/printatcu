// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require cookie
//= require bootstrap
//= require_tree .

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-3441642-13', 'printatcu.com');
ga('send', 'pageview');

var _gauges = _gauges || [];
(function() {
  var t   = document.createElement('script');
  t.type  = 'text/javascript';
  t.async = true;
  t.id    = 'gauges-tracker';
  t.setAttribute('data-site-id', '5025b7d9613f5d7b4700000b');
  t.src = '//secure.gaug.es/track.js';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(t, s);
})();

var OX_731328f5e6 = OX();
OX_731328f5e6.addPage("536870958");
OX_731328f5e6.fetchAds();

function checkFileType(files){
  if(files == undefined){
    showPDFWarning(false);
    return;
  }
  else{
    var length = files.length;
    var allPDF = true;
    while(length-- && allPDF){
      allPDF = isPDF(files[length].filename);
    }
    showPDFWarning(!allPDF);
  }
}

function showPDFWarning(toShow){
  if(toShow){
    $('.pdf-warning').removeClass('hidden');
  }
  else{
    $('.pdf-warning').addClass('hidden');
  }
}

function isPDF(fileName){
  return fileName.substr(fileName.length - 3).toUpperCase() === "PDF";
}

function changePrinters(){
  var statusMap = {
    "red" : "danger",
    "yellow" : "warning",
    "green" : "success",
  }
  console.log("test");
  var building = $("select#print_building");
  var printers = gon.printers[building.val()];
  var lastIndex = printers.length - 1;
  var index = 0;
  var printer = $(".printer-group");
  printer.empty();
  while(index <= lastIndex){
    var printerName = printers[index];
    var printerStatus = gon.status[printerName];
    if(index == 0){
      var radio = $("<input type=\"radio\" name=\"printer\" checked value="+printerName+">");
      var ele = $("<label></label>").addClass("btn btn-" + statusMap[printerStatus] + " active printer-button").append(radio).append(printerName);
    }
    else {
      var radio = $("<input type=\"radio\" name=\"printer\" value="+printerName+">");
      var ele = $("<label></label>").addClass("btn btn-" + statusMap[printerStatus] + " printer-button").append(radio).append(printerName);
    }
    //ele.addClass(gon.status[printerName] + "Status");
    printer.append(ele);
    index++;
  }
}

$("select#print_building").ready( changePrinters );