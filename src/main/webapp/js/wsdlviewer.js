/* http://stackoverflow.com/questions/22084698/how-to-export-source-content-within-div-to-text-html-file */
function downloadInnerHtml(filename, elId, mimeType) {
    var elHtml = document.getElementById(elId).innerHTML;
    var link = document.createElement('a');
    mimeType = mimeType || 'text/plain';

    link.setAttribute('download', filename);
    link.setAttribute('href', 'data:' + mimeType  +  ';charset=utf-8,' + encodeURIComponent(elHtml));
    document.body.appendChild(link);
    link.click(); 
    document.body.removeChild(link);
}

function expand(object){
	var listItem = object.parentNode;
	if(listItem.hasChildNodes()){
		var messagePart = listItem.childNodes[2];
		if(messagePart != null){
			if(listItem.className == "fechado"){
				listItem.className = "aberto";
			} else {
				listItem.className = "fechado";
			}
		}
	}
}

function expandAll(){
	var listItems = $("li.fechado");
	listItems.removeClass("fechado");
	listItems.addClass("aberto");
}

function collapseAll(){
	var listItems = $("li.aberto");
	listItems.removeClass("aberto");
	listItems.addClass("fechado");
}

function refreshDisplay(detailLevel) {
	var hideElements, showElements;
	
	var uiElements = ["div.documentation", ".range", ".element-type", ".restriction", ".nillable", ".full-detail"];
	
	for(var i = 0; i < uiElements.length; i++) {
		if(i < detailLevel) {
			$(uiElements[i]).show();
		} else {
			$(uiElements[i]).hide();
		}
	}
}

$(document).ready(function(){
	var slider = $("#detail-slider");
	slider.on("slideStop", function(slideEvt) {
		refreshDisplay(slideEvt.value);
	});
	refreshDisplay(slider.slider('getValue'));

	$('#downloadWsdl').click(function(event){
		var filename = $(this).data('filename');
	    downloadInnerHtml(filename, 'wsdl','text/xml');
	    event.preventDefault();
	});
});