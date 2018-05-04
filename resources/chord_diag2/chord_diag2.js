

function drawBar(wh,s1) {
	if (gICAPI.svgDoc == null) {
		alert("drawBar: No svgDoc");
		return;
	}
	var x = gICAPI.svgDoc.getElementsByTagName("g")

	for (var i = 0; i <x.length; i++) {
		att = x.item(i).attributes.getNamedItem("id");
		if ( att.value == "Shape") {
			fin = document.createElementNS("http://www.w3.org/2000/svg", "line");
			x1 = 5;
			if ( s1 == "X" ) x1 = 20;
			if ( wh == 1 ) y = 22;
			if ( wh == 2 ) y = 52;
			if ( wh == 3 ) y = 78;
			fin.setAttribute("x1",x1);
			fin.setAttribute("x2",75);
			fin.setAttribute("y1",y);
			fin.setAttribute("y2",y);
			fin.setAttribute("style","fill:#f6f8f6;fill-opacity:1;stroke:#fafaf4;stroke-width:10");
			x.item(i).appendChild(fin);
			/*alert("in drawBar, String:"+st+" Pos:"+wh+" X:"+((13*st)-5)+" Y:"+y);*/
		}
	}
}

function addFinger(st, wh) {
    if (gICAPI.svgDoc == null) {
			alert("addFinger: No svgDoc");
			return;
    }
		var x = gICAPI.svgDoc.getElementsByTagName("g")

		for (var i = 0; i <x.length; i++) {
			att = x.item(i).attributes.getNamedItem("id");
/*			alert("proc item "+i.toString()+" what:"+x[i].toString()+" Att:"+att.value); */
			if ( att.value == "Shape") {
				fin = document.createElementNS("http://www.w3.org/2000/svg", "circle");
				if ( wh == 0 ) y = -3;
				if ( wh == 1 ) y = 22;
				if ( wh == 2 ) y = 52;
				if ( wh == 3 ) y = 78;
				if ( wh == 4 ) y = 100;
				fin.setAttribute("cx",(13*st)-5);
				fin.setAttribute("cy",y);
				fin.setAttribute("r",6);
				fin.setAttribute("style","fill:#f6f8f6;fill-opacity:1;stroke:#fafaf4;stroke-width:1");
				x.item(i).appendChild(fin);
				/*alert("in addFinger, String:"+st+" Pos:"+wh+" X:"+((13*st)-5)+" Y:"+y);*/
			}
		}
}

function setX(wh) {
    if (gICAPI.svgDoc == null) {
			alert("setX: No svgDoc");
			return;
    }
/*		alert("in setX");*/
		var x = gICAPI.svgDoc.getElementsByTagName("g")

		for (var i = 0; i <x.length; i++) {
			att = x.item(i).attributes.getNamedItem("id");
/*			alert("proc item "+i.toString()+" what:"+x[i].toString()+" Att:"+att.value); */
			if ( att.value == wh ) {
/*				alert("Found "+wh); */
				x[i].setAttributeNS(null,"style","display:inline"); 
			}
		}
}

function onICHostReady(version) {
	if ( version != 1.0 ) {
		alert('Invalid API version');
		return;
	}

	gICAPI.redrawRequested = false;

	gICAPI.onData = function(data) {
		gICAPI.redrawRequested = true;
    /*document.getElementById('svg1').innerHTML=
      "<embed id='diag1' src='diag.svg' width='80px' height='110px' type='image/svg+xml' />"; */
		data1 = data.substring(0,1);
		data2 = data.substring(1,2);
		data3 = data.substring(2,3);
		data4 = data.substring(3,4);
		data5 = data.substring(4,5);
		data6 = data.substring(5,6);
		barp = data.substring(6,7);
		/*alert("Data:"+data1+" :"+data2+" :"+data3+" :"+data4+" :"+data5+" :"+data6+" Bar:"+barp);*/
		document.getElementById('debug1').innerHTML="<B>"+data1+data2+data3+data4+data5+data6+"</B>";
		var embed=document.getElementById("diag1");
		gICAPI.svgDoc=embed.getSVGDocument();
		if ( gICAPI.svgDoc != null ) {
			if ( data1 == "X" ) { setX("X1") } else { addFinger( 1, data1 ) };
			if ( data2 == "X" ) { setX("X2") } else { addFinger( 2, data2 ) };
			if ( data3 == "X" ) { setX("X3") } else { addFinger( 3, data3 ) };
			if ( data4 == "X" ) { setX("X4") } else { addFinger( 4, data4 ) };
			if ( data5 == "X" ) { setX("X5") } else { addFinger( 5, data5 ) };
			if ( data6 == "X" ) { setX("X6") } else { addFinger( 6, data6 ) };
			if ( barp != "0" ) drawBar( barp, data1 );
		} else {
			alert("onData: svgDoc is null!");
		}
	}

	gICAPI.onProperty = function(props) {
	}

	gICAPI.onFocus = function(polarity) {
	}

	gICAPI.redrawDiag = function() {
		gICAPI.redrawRequested = false;
		var embed=document.getElementById("diag1");
		gICAPI.svgDoc=embed.getSVGDocument();
		if (gICAPI.svgDoc == null) {
			if (! gICAPI.redrawRequested) {
				gICAPI.redrawRequested = true;
				setTimeout(gICAPI.redrawDiag,10);
			}
			return;
		}
	}
}