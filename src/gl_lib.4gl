
-- $Id: gl_lib.4gl 44 2014-04-14 12:52:51Z neilm $ 
IMPORT os

{
IMPORT Java java.lang.System
}

&include "capotrans.inc"

DEFINE
	gl_progname,
	gl_progdesc,
	gl_progauth,
	gl_cli_os,
	gl_cli_osver,
	gl_cli_res,
	gl_cli_dir,
	gl_cli_un,
	gl_os STRING

PUBLIC DEFINE m_logDir, m_logfile, m_dbnam,m_dbtyp, m_dbsrc, m_dbdrv, m_dbcon STRING
--------------------------------------------------------------------------------
#+ Dynamic About Window
#+
#+ @param gl_ver a version string
#+ @param l_progname a version string
#+ @param l_progdesc a version string
#+ @param l_progauth a version string
#+
#+ @return Nothing.
FUNCTION gl_about(l_ver, l_progdesc, l_progauth, l_dynamic) --{{{
	DEFINE l_ver STRING
	DEFINE l_progdesc STRING
	DEFINE l_progauth STRING
	DEFINE l_browser, l_user_agent STRING
	DEFINE r,f,n,g,w,hb om.DomNode
	DEFINE nl om.nodeList
	DEFINE l_cliver,l_gver, l_logname, l_info, l_txt, l_targ STRING
	DEFINE y,x SMALLINT
	DEFINE l_dbtyp, l_dbsrc, l_dbdrv, l_dbcon STRING
	DEFINE l_dynamic BOOLEAN

	IF NOT l_dynamic THEN
		OPEN WINDOW about WITH FORM "about"
		MENU "Static"
			ON ACTION close	EXIT MENU
			ON ACTION closeabout	EXIT MENU
		END MENU
		CLOSE WINDOW about
		RETURN
	END IF

	LET gl_progname = base.Application.getProgramName()
	LET gl_progdesc = l_progdesc
	LET gl_progauth = l_progauth

	IF gl_os IS NULL THEN
		CALL gl_dvmInfo() RETURNING l_gver, l_targ, gl_os
	END IF

	LET l_logname = fgl_getEnv("LOGNAME")
	IF l_logname IS NULL OR l_logname.getLength() < 2 THEN
		LET l_logname = fgl_getEnv("USERNAME")
	END IF
	IF l_logname IS NULL OR l_logname.getLength() < 2 THEN
		LET l_logname = "Unknown"
	END IF
	LET l_cliver = gl_feVer()

	CALL ui.interface.frontcall("standard","feinfo",[ "ostype" ], [ gl_cli_os ] )
	CASE ui.interface.getFrontEndName()
		WHEN "GDC"
			CALL ui.interface.frontcall("standard","feinfo",[ "osversion" ], [ gl_cli_osver ] )
			CALL ui.interface.frontCall("standard","feinfo",[ "screenresolution" ], [ gl_cli_res ])
			CALL ui.interface.frontCall("standard","feinfo",[ "fepath" ], [ gl_cli_dir ])
			CALL ui.interface.frontCall("standard","getenv","USERNAME",gl_cli_un)
			IF gl_cli_un IS NULL OR gl_cli_un.getLength() < 2 THEN
				CALL ui.interface.frontCall("standard","getenv","LOGNAME",gl_cli_un)
			END IF
		WHEN "GWC"
			LET l_user_agent = fgl_getEnv("FGL_WEBSERVER_HTTP_USER_AGENT")
			LET l_browser = "?"--chk_browser( l_user_agent )
		WHEN "GMA"
			CALL ui.interface.frontcall("standard","feinfo",[ "osversion" ], [ gl_cli_osver ] )
			CALL ui.interface.frontCall("standard","feinfo",[ "screenresolution" ], [ gl_cli_res ])
		WHEN "GMI"
			CALL ui.interface.frontcall("standard","feinfo",[ "osversion" ], [ gl_cli_osver ] )
			CALL ui.interface.frontCall("standard","feinfo",[ "screenresolution" ], [ gl_cli_res ])

	END CASE

	OPEN WINDOW about AT 1,1 WITH 1 ROWS, 1 COLUMNS ATTRIBUTE(STYLE="naked")
	LET r = gl_getWinNode(NULL)
	CALL r.setAttribute("text",gl_progdesc)
	LET f = gl_genForm("about")
	CALL r.setAttribute("image","capotrans.png")
	LET n = f.createChild("VBox")
	--CALL n.setAttribute("posY","0" )
	--CALL n.setAttribute("posX","0" )

	LET y = 0
	LET x = 23

	LET g = n.createChild("Grid")
	--CALL g.setAttribute("text","About")
	--CALL g.setAttribute("posY","10" )
	--CALL g.setAttribute("posX","0" )
	--CALL g.setAttribute("gridWidth",x*2)
	CALL f.setAttribute("width",64)
	CALL g.setAttribute("width",64)
	--CALL g.setAttribute("style","about")

	LET w = g.createChild("Image")
	CALL w.setAttribute("posY",y) LET y = y + 1
	CALL w.setAttribute("posX",0)
	CALL w.setAttribute("gridWidth",56)
	CALL w.setAttribute("image","capotrans.png")
	CALL w.setAttribute("name","logo")

	CALL gl_addLabel(g,1,y,"Program:","right",NULL)
	CALL gl_addLabel(g,x,y,gl_progname||" - "||l_ver,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Description:"),"right",NULL)
	CALL gl_addLabel(g,x,y,gl_progdesc,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Author:"),"right",NULL)
	CALL gl_addLabel(g,x,y,gl_progauth,NULL,NULL) LET y = y + 1

	LET w = g.createChild("HLine")
	CALL w.setAttribute("posY",y) LET y = y + 1
	CALL w.setAttribute("posX",0)
	CALL w.setAttribute("gridWidth",56)

	CALL gl_addLabel(g,1,y,LSTR("Genero RT:"),"right",NULL)
	CALL gl_addLabel(g,x,y,l_gver,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Platform:"),"right",NULL)
	CALL gl_addLabel(g,x,y,l_targ,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("ServerOS:"),"right",NULL)
	CALL gl_addLabel(g,x,y,gl_os,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("ServerUser:"),"right",NULL)
	CALL gl_addLabel(g,x,y,l_logname,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Date/Time:"),"right",NULL)
	CALL gl_addLabel(g,x,y,TODAY||" "||TIME,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("DBDate:"),"right",NULL)
	CALL gl_addLabel(g,x,y,fgl_getEnv("DBDATE"),NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("ProgramDir:"),"right",NULL)
	CALL gl_addLabel(g,x,y,base.Application.getProgramDir(),NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("FGLPROFILE:"),"right",NULL)
	CALL gl_addLabel(g,x,y,os.path.basename(fgl_getEnv("FGLPROFILE")),NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("XCF Name:"),"right",NULL)
	CALL gl_addLabel(g,x,y,fgl_getEnv("XCFNAME"),NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("ImagePath:"),"right",NULL)
	CALL gl_addLabel(g,x,y,fgl_getEnv("FGLIMAGEPATH"),NULL,NULL) LET y = y + 1

	LET w = g.createChild("HLine")
	CALL w.setAttribute("posY",y) LET y = y + 1
	CALL w.setAttribute("posX",0)
	CALL w.setAttribute("gridWidth",x*2)

	CALL gl_addLabel(g,1,y,LSTR("Cli OS:"),"right",NULL)
	CALL gl_addLabel(g,x,y,gl_cli_os||" / "||gl_cli_osver,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Cli Version:"),"right",NULL)
	CALL gl_addLabel(g,x,y,l_cliver,NULL,NULL) LET y = y + 1
	IF ui.interface.getFrontEndName() = "GWC" THEN
		CALL gl_addLabel(g,1,y,LSTR("Cli Browser:"),"right",NULL)
		CALL gl_addLabel(g,x,y,l_browser,NULL,NULL) LET y = y + 1
	ELSE
		CALL gl_addLabel(g, 0,y,LSTR("Cli Mobile:"),"right",NULL)
		CALL gl_addLabel(g,x,y, IIF((base.Application.isMobile()),"True","False"),NULL,NULL) LET y = y + 1

		CALL gl_addLabel(g,1,y,LSTR("Cli User:"),"right",NULL)
		CALL gl_addLabel(g,x,y,gl_cli_un,NULL,NULL) LET y = y + 1

		CALL gl_addLabel(g,1,y,LSTR("Cli Dir:"),"right",NULL)
		CALL gl_addLabel(g,x,y,gl_cli_dir,NULL,NULL) LET y = y + 1

		CALL gl_addLabel(g,1,y,LSTR("Cli Res:"),"right",NULL)
		CALL gl_addLabel(g,x,y,gl_cli_res,NULL,NULL) LET y = y + 1
	END IF

	LET w = g.createChild("HLine")
	CALL w.setAttribute("posY",y) LET y = y + 1
	CALL w.setAttribute("posX",0)
	CALL w.setAttribute("gridWidth",x*2)

	CALL gl_addLabel(g,1,y,LSTR("Database:"),"right",NULL)
	CALL gl_addLabel(g,x,y, gldb_getDBName(),NULL,NULL) LET y = y + 1
	CALL gldb_getDBInfo() RETURNING l_dbtyp, l_dbsrc, l_dbdrv, l_dbcon
	CALL gl_addLabel(g,1,y,LSTR("DB Driver:"),"right",NULL)
	CALL gl_addLabel(g,x,y, l_dbdrv,NULL,NULL) LET y = y + 1
--	CALL gl_addLabel(g,1,y,LSTR("DB Source:"),"right",NULL)
--	CALL gl_addLabel(g,x,y, l_dbsrc,NULL,NULL) LET y = y + 1
--	CALL gl_addLabel(g,1,y,LSTR("DB Con:"),"right",NULL)
--	CALL gl_addLabel(g,x,y, l_dbcon,NULL,NULL) LET y = y + 1

	CALL gl_addLabel(g,1,y,LSTR("Log Dir:"),"right",NULL)
	CALL gl_addLabel(g,x,y, m_logDir,NULL,NULL) LET y = y + 1
	CALL gl_addLabel(g,1,y,LSTR("Log File:"),"right",NULL)
	CALL gl_addLabel(g,x,y, m_logFile,NULL,NULL) LET y = y + 1
	CALL g.setAttribute("height",y)

	LET g = n.createChild("Grid")
	CALL g.setAttribute("width","58")
	CALL g.setAttribute("height","1")

	LET hb = g.createChild("HBox")
	CALL hb.setAttribute("posY",0)
	CALL hb.setAttribute("posX",1)
	CALL hb.setAttribute("gridWidth",56)
	LET w = hb.createChild("SpacerItem")

	IF UPSHIFT(ui.interface.getFrontEndName()) = "GDC" THEN
		LET w = hb.createChild("Button")
		CALL w.setAttribute("name","copyabout")
		CALL w.setAttribute("width",10)
		CALL w.setAttribute("text","Copy to Clipboard")
		CALL w.setAttribute("tabIndex",1)
	END IF

	IF UPSHIFT(ui.interface.getFrontEndName()) = "GMA" THEN
		LET w = hb.createChild("Button")
		CALL w.setAttribute("name","about")
		CALL w.setAttribute("width",10)
		CALL w.setAttribute("text","Client")
		CALL w.setAttribute("tabIndex",1)
	END IF

	LET w = hb.createChild("Button")
	CALL w.setAttribute("name","closeabout")
	CALL w.setAttribute("width",10)
	CALL w.setAttribute("text","Close")
	CALL w.setAttribute("tabIndex",2)

	LET w = hb.createChild("SpacerItem")

	CALL f.setAttribute("text","Dynamic")
	CALL f.setAttribute("height",y)

	CALL ui.Interface.refresh()

	CALL f.writeXml("about2.42f")

	LET nl = f.selectByTagName("Label")
	FOR y = 1 TO nl.getLength()
		LET w = nl.item( y )
		LET l_txt = w.getAttribute("text")
		IF l_txt IS NULL THEN LET l_txt = "(null)" END IF
		LET l_info = l_info.append( l_txt )
		IF NOT y MOD 2 THEN
			LET l_info = l_info.append( "\n" )
		END IF
		DISPLAY l_info
	END FOR

	MENU "Dynamic"
		ON ACTION close	EXIT MENU
		ON ACTION closeabout	EXIT MENU
		ON ACTION about
			CALL ui.interface.frontCall("Android","showAbout",[],[])
		--ON ACTION showenv CALL gl_showEnv()
		--ON ACTION copyabout CALL ui.interface.frontCall("standard","cbset",info,y )
	END MENU
	CLOSE WINDOW about

END FUNCTION --}}}
----------------------------------------------------------------------------------
#+ Format revision string
#+
#+ @param ver = String : a cvs revisions string ie : $Revision: 44 $
#+ @return String.
FUNCTION gl_verFmt( ver ) --{{{
	DEFINE ver STRING
	DEFINE x SMALLINT

	LET x = ver.getIndexOf(":",1)
	LET ver = ver.subString(x+1, ver.getLength() - 1 )
	RETURN ver.trim()
END FUNCTION --}}}
----------------------------------------------------------------------------------
#+ Return the node for a named window.
#+
#+ @param nam	name of window, if null current window node is returned.
#+ @return ui.Window.
FUNCTION gl_getWinNode(nam) --{{{
	DEFINE nam STRING
	DEFINE uiwin ui.Window

	IF nam IS NULL THEN
		LET uiwin = ui.Window.getCurrent()
		LET nam = "SCREEN"
	ELSE
		LET uiwin = ui.Window.forName(nam)
	END IF
	RETURN uiwin.getNode()

END FUNCTION --}}}
----------------------------------------------------------------------------------
#+ Dynamically generate a form object & return it's node.
#+
#+ @param nam	name of Form, Should not be NULL!
#+ @return ui.Form.
FUNCTION gl_genForm( nam ) --{{{
	DEFINE nam STRING
	DEFINE uiwin ui.Window
	DEFINE uifrm ui.Form

	LET uiwin = ui.Window.getCurrent()
	IF uiwin IS NULL THEN
		RETURN NULL
	END IF

	LET uifrm = uiwin.createForm( nam )
	IF uifrm IS NULL THEN
		RETURN NULL
	END IF

	RETURN uifrm.getNode()
END FUNCTION --}}}
--------------------------------------------------------------------------------
#+ Add a label to a grid/group
#+
#+ @param g Node of the Grid or Group
#+ @param x X position
#+ @param y Y Position
#+ @param txt Text for label
#+ @param j Justify : NULL, center or right
#+ @param s Style.
#+ @return TRUE/FALSE.	Success / Failed
FUNCTION gl_addLabel(g,x,y,txt,j,s) --{{{
	DEFINE g,l om.domNode
	DEFINE txt,j,s,w STRING
	DEFINE x,y SMALLINT

	LET w = txt.getLength()

	IF j = "right" THEN
		IF w < 20 THEN LET w = 20 END IF
	ELSE
		IF w < 34 THEN LET w = 34 END IF
	END IF

	LET l = g.createChild("Label")
	CALL l.setAttribute("name","lab"||(x USING "&&")||(y USING "&&"))
	CALL l.setAttribute("width", w)
	CALL l.setAttribute("text",txt)

	IF j IS NOT NULL THEN
		CALL l.setAttribute("justify",j)
	END IF
	IF s IS NOT NULL THEN
		CALL l.setAttribute("style",s)
	END IF

	CALL l.setAttribute("posY",y)
	CALL l.setAttribute("posX",x)

	CALL l.setAttribute("gridWidth",w)

END FUNCTION --}}}
----------------------------------------------------------------------------------
#+ Get FrontEnd type and Version String.
#+
#+ @return String.
FUNCTION gl_feVer() --{{{

	RETURN ui.interface.getFrontEndName()||" "||ui.interface.getFrontEndVersion()

END FUNCTION --}}}
--------------------------------------------------------------------------------
FUNCTION gl_dvmInfo()
	DEFINE c base.Channel
	DEFINE l_build,l_target,l_os, l_str STRING
	DEFINE x SMALLINT

	IF NOT base.Application.isMobile() THEN
		LET c = base.Channel.create()
		CALL c.openPipe("fglrun -V","r")
		LET l_build = c.readLine() -- build
		LET l_target = c.readLine() -- info
		LET l_target = c.readLine() -- target
		LET x = l_target.getIndexOf(" ",1)
		IF x > 1 THEN LET l_target = l_target.subString(x+1,l_target.getLength()) END IF
		CALL c.close()
	END IF

	{LET l_os = System.getProperty("os.name")

	IF l_target IS NULL THEN
		LET l_target =
					System.getProperty("os.arch")," ",
					System.getProperty("os.version")
	END IF}

	IF l_build IS NULL THEN 
		LET l_build = fgl_getVersion()
		LET l_str = base.Application.getFglDir()
		IF l_str.getIndexOf("com.fourjs.gma",1) > 0 THEN --Android
			CALL ui.interface.frontcall("standard","feinfo",[ "osversion" ], [ gl_cli_osver ] )
			LET l_os = "Android "||gl_cli_osver
		END IF
	END IF

	RETURN l_build,l_target,l_os
END FUNCTION --}}}
--------------------------------------------------------------------------------
FUNCTION gl_logIt(l_line)
	DEFINE l_line STRING
	DEFINE c base.Channel
	LET l_line = CURRENT,":",NVL( l_line,"NULL" )
	DISPLAY l_line
	IF m_logfile IS NULL THEN
		LET m_logDir = base.Application.getResourceEntry("gm.logdir") --fgl_getEnv("LOGDIR")
		IF m_logDir IS NULL THEN LET m_logDir = c_def_logdir END IF
		LET m_logfile = os.path.join( m_logDir, base.Application.getProgramName()||".log" )
	END IF
	LET c = base.Channel.create()
	CALL c.openFile(m_logfile,"a")
	CALL c.writeLine( l_line )
	CALL c.close()
END FUNCTION
----------------------------------------------------------------------------------
#+ Progressbar Routine.
#+
#+ @code 
#+ CALL gl_progBar(1,10,"Working...")   Open window and set max = 10
#+ FOR x = 1 TO 10
#+ 	CALL gl_progBar(2,x,NULL)  Move the bar to x position
#+ END FOR
#+ CALL gl_progBar(3,0,NULL)   Close the window
#+
#+ @param meth 1=Open Window / 2=Update bar / 3=Close Window
#+ @param curval 1=Max value for Bar / 2=Current value position for Bar / 3=Ignored.
#+ @param txt Text display below the bar in the window.
#+ @return Nothing.
FUNCTION gl_progBar(meth,curval,txt) --{{{

	DEFINE meth INTEGER
	DEFINE curval INTEGER
	DEFINE txt STRING
	DEFINE winnode, frm, g, frmf, pbar om.DomNode

	IF meth = 1 OR meth = 0 THEN
		OPEN WINDOW progbar WITH 1 ROWS, 50 COLUMNS
		LET winnode = gl_getWinNode(NULL)
		CALL winnode.setAttribute("style","naked")
		CALL winnode.setAttribute("width",45)
		CALL winnode.setAttribute("height",2)
		CALL winnode.setAttribute("text",txt)
		LET frm = gl_genForm("gl_progbar")
		CALL frm.setAttribute("text","ProgressBar")

		LET g = frm.createChild('Grid')

		LET frmf = g.createChild('FormField')
		CALL frmf.setAttribute("colName","progress")
		CALL frmf.setAttribute("value",0)
		LET pbar = frmf.createChild('ProgressBar')
		CALL pbar.setAttribute("width",40)
		CALL pbar.setAttribute("posY",1)
		CALL pbar.setAttribute("valueMax",curval)
		CALL pbar.setAttribute("valueMin",1)

		CALL gl_addLabel(g, 0,2,txt,NULL,NULL)
		IF meth = 0 THEN
			LET g = g.createChild('HBox')
			CALL g.setAttribute("posY",3)
			LET frmf = g.createChild('SpacerItem')
			LET frmf = g.createChild('Button')
			CALL frmf.setAttribute("name","cancel")
			LET frmf = g.createChild('SpacerItem')
		END IF
	END IF

	IF meth = 2 THEN
		DISPLAY curval TO progress
	END IF

	IF meth = 3 THEN
		CLOSE WINDOW progbar
	END IF
	DISPLAY "ProgBar:",meth," ",curval
	CALL ui.interface.refresh()
END FUNCTION --}}}
--------------------------------------------------------------------------------
FUNCTION gl_winMessage(l_titl,l_mess,l_icon)
	DEFINE l_titl,l_mess,l_icon STRING
	MENU l_titl
		ATTRIBUTES(STYLE="dialog",COMMENT=l_mess, IMAGE=l_icon)
		COMMAND "Continue"
	END MENU
END FUNCTION --}}}
--------------------------------------------------------------------------------
FUNCTION gldb_getDBName()
	RETURN m_dbnam
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION gldb_getDBInfo()
	RETURN m_dbtyp, m_dbsrc, m_dbdrv, m_dbcon
END FUNCTION