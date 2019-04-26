// This function is called by the Genero Client Container
// so the web component can initialize itself and initialize
// the gICAPI handlers
onICHostReady = function(version) {
	if ( version < 1.0 ) {
		alert('Invalid API version:'+version );
		return;
	}

	gICAPI.onFocus = function(polarity) {
	}
		
	gICAPI.onData = function(data) {
	}

	gICAPI.onProperty = function(property) {
	}
}

function checkKeyPad() {
	isDown = false;

	//dbg = document.getElementById('dbg');

	r01 = document.getElementById('but01');
	r02 = document.getElementById('but02');
	r03 = document.getElementById('but03');
	r04 = document.getElementById('but04');
	r05 = document.getElementById('but05');
	r06 = document.getElementById('but06');
	r07 = document.getElementById('but07');
	r08 = document.getElementById('but08');
	r09 = document.getElementById('but09');
	r10 = document.getElementById('but10');
	r11 = document.getElementById('but11');
	r12 = document.getElementById('but12');
	r13 = document.getElementById('but13');
	r14 = document.getElementById('but14');
	r15 = document.getElementById('but15');
	r16 = document.getElementById('but16');
	r17 = document.getElementById('but17');
	r18 = document.getElementById('but18');

	r01.addEventListener('mousedown', down, false);
	r01.addEventListener('mouseup', up, false);
	r02.addEventListener('mousedown', down, false);
	r02.addEventListener('mouseup', up, false);
	r03.addEventListener('mousedown', down, false);
	r03.addEventListener('mouseup', up, false);
	r04.addEventListener('mousedown', down, false);
	r04.addEventListener('mouseup', up, false);
	r05.addEventListener('mousedown', down, false);
	r05.addEventListener('mouseup', up, false);
	r06.addEventListener('mousedown', down, false);
	r06.addEventListener('mouseup', up, false);
	r07.addEventListener('mousedown', down, false);
	r07.addEventListener('mouseup', up, false);
	r08.addEventListener('mousedown', down, false);
	r08.addEventListener('mouseup', up, false);
	r09.addEventListener('mousedown', down, false);
	r09.addEventListener('mouseup', up, false);
	r10.addEventListener('mousedown', down, false);
	r10.addEventListener('mouseup', up, false);
	r11.addEventListener('mousedown', down, false);
	r11.addEventListener('mouseup', up, false);
	r12.addEventListener('mousedown', down, false);
	r12.addEventListener('mouseup', up, false);
	r13.addEventListener('mousedown', down, false);
	r13.addEventListener('mouseup', up, false);
	r14.addEventListener('mousedown', down, false);
	r14.addEventListener('mouseup', up, false);
	r15.addEventListener('mousedown', down, false);
	r15.addEventListener('mouseup', up, false);
	r16.addEventListener('mousedown', down, false);
	r16.addEventListener('mouseup', up, false);
	r17.addEventListener('mousedown', down, false);
	r17.addEventListener('mouseup', up, false);
	r18.addEventListener('mousedown', down, false);
	r18.addEventListener('mouseup', up, false);
}

function isTouchEvent(e) {
	return e.type.match(/^touch/);
}

function down(e) {
	// Make sure has the 4gl focus if user clicks inside
	// dbg.innerHTML = "dn:"+e.target.getAttribute("id");
	gICAPI.SetFocus();

	isDown = true;
	if (isTouchEvent(e)) e.preventDefault();
	/*gICAPI.SetData( e.target.getAttribute("val") );*/
	gICAPI.Action(e.target.getAttribute("id"));
}

function up(e) {
	isDown = false; 
	if (isTouchEvent(e)) e.preventDefault();
	// dbg.innerHTML = "up:"+e.target.getAttribute("id");
}