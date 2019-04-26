
function onICHostReady(version) {
	if ( version != 1.0 ) {
		alert('Invalid API version');
		return;
	}

	gICAPI.memorizedProps = ".";
	gICAPI.memorizedData = ".";
	gICAPI.redrawRequested = false;

	gICAPI.onData = function(data) {
		data1 = data.substring(0,6);
		data2 = data.substring(7,13);
		data3 = data.substring(14,20);
		data4 = data.substring(21,27);
		data5 = data.substring(28,34);
		data6 = data.substring(35,41);
		data7 = data.substring(42,48);
		data8 = data.substring(49,55);
		if ( data2 == "" ) data2 = "NC";
		if ( data3 == "" ) data3 = "NC";
		if ( data4 == "" ) data4 = "NC";
		if ( data5 == "" ) data5 = "NC";
		if ( data6 == "" ) data6 = "NC";
		if ( data7 == "" ) data7 = "NC";
		if ( data8 == "" ) data8 = "NC";
		/*alert("Data1:"+data1+" Data2:"+data2);*/
		document.getElementById('debug1').innerHTML="<B>"+data1.trim()+"</B>";
		document.getElementById('svg1').innerHTML=
			"<embed id='embed' src='diag_"+data1.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug2').innerHTML="<B>"+data2.trim()+"</B>";
		document.getElementById('svg2').innerHTML=
			"<embed id='embed' src='diag_"+data2.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug3').innerHTML="<B>"+data3.trim()+"</B>";
		document.getElementById('svg3').innerHTML=
			"<embed id='embed' src='diag_"+data3.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug4').innerHTML="<B>"+data4.trim()+"</B>";
		document.getElementById('svg4').innerHTML=
			"<embed id='embed' src='diag_"+data4.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug5').innerHTML="<B>"+data5.trim()+"</B>";
		document.getElementById('svg5').innerHTML=
			"<embed id='embed' src='diag_"+data5.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug6').innerHTML="<B>"+data6.trim()+"</B>";
		document.getElementById('svg6').innerHTML=
			"<embed id='embed' src='diag_"+data6.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug7').innerHTML="<B>"+data7.trim()+"</B>";
		document.getElementById('svg7').innerHTML=
			"<embed id='embed' src='diag_"+data7.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

		document.getElementById('debug8').innerHTML="<B>"+data8.trim()+"</B>";
		document.getElementById('svg8').innerHTML=
			"<embed id='embed' src='diag_"+data8.trim()+".svg' width='80px' height='110px' type='image/svg+xml' />";

	}

	gICAPI.onProperty = function(props) {
		if (props != gICAPI.memorizedProps) {
			gICAPI.memorizedProps = props;
			if (! gICAPI.redrawRequested) {
				gICAPI.redrawRequested = true;
				setTimeout(gICAPI.redrawDiag,10);
			}
		}
	}

	gICAPI.onFocus = function(polarity) {

	}

	gICAPI.redrawDiag = function() {
		gICAPI.redrawRequested = false;
		if (gICAPI.svgDoc == null) {
			var embed=document.getElementById("embed");
			gICAPI.svgDoc=embed != null ? embed.getSVGDocument() : null;
			if (gICAPI.svgDoc == null) {
				if (! gICAPI.redrawRequested) {
					gICAPI.redrawRequested = true;
					setTimeout(gICAPI.redrawDiag,10);
				}
				return;
			}
		}
	}
}
