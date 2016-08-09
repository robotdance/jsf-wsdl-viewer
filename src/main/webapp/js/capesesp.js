$(document).ready(function(){
	$("a.cape-link").click(function(event){
		$(document.getElementById("wsdl:url")).val($(this).attr("href"));
		$(document.getElementById("wsdl:type-wsdl")).click();
		event.preventDefault();
	});
});