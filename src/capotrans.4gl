
#+ A simple program to show chord shape positions relative to capo.
#+ Also handle transposition.
#+
#+ shapes.txt format:
#+	Root Note
#+	name - = base / m = minor / M = Major / m7 = minor seveth etc
#+	position 0 = open
#+	score = difficulting rating
#+	variation 
#+	string fret number low E  -1 = don't play, 0 = open,  1 = 1st fret etc
#+	string fret number A
#+	string fret number D
#+	string fret number G
#+	string fret number B
#+	string fret number high E
#+
#+ Nexus Res:		1200x1824
#+ HTC Res:			720x1280
#+ Android Emu: 720x1184
#+ iPhone Emu:	320x480

IMPORT os
IMPORT FGL gl_lib

&include "capotrans.inc"

	DEFINE notes, notes2 DYNAMIC ARRAY OF STRING
	DEFINE chord_shapes DYNAMIC ARRAY OF RECORD
		root_note STRING,
		name STRING,
		pos SMALLINT,
		score SMALLINT,
		vari SMALLINT, -- low e
		str1 SMALLINT,
		str2 SMALLINT,
		str3 SMALLINT,
		str4 SMALLINT,
		str5 SMALLINT,
		str6 SMALLINT, -- high e
		dspnam STRING
	END RECORD
			
	DEFINE m_chords, m_new STRING
	DEFINE m_sharp BOOLEAN
	DEFINE m_lev, m_lev2 SMALLINT

	DEFINE alts DYNAMIC ARRAY OF RECORD
		pos SMALLINT,
		score SMALLINT,
		shapes STRING,
		desc STRING
	END RECORD

MAIN
	DEFINE l_keypad STRING

	CALL STARTLOG( base.Application.getResourceEntry( "ct.logfile" ) )

	CALL get_shapes("shapes2.txt") -- custom shapes, if exist
	CALL get_notes()

	IF fgl_getEnv("GST") = "1" THEN
		DISPLAY "FGLSERVER=",fgl_getEnv("FGLSERVER")
	END IF

&ifdef VER2
	OPEN FORM f FROM "capotrans2_leo"
&else
	OPEN FORM f FROM "capotrans"
&endif
	DISPLAY FORM f

	LET alts[8].desc = "" -- make sure there some rows in the table.
	LET m_lev = 0
	LET m_lev2 = m_lev
	LET m_chords = "Dm F Bb C Dm F Bb A"
	WHILE NOT int_flag
		DISPLAY "Start:",CURRENT
		DIALOG ATTRIBUTES(UNBUFFERED)
			INPUT BY NAME m_sharp, m_chords, m_lev, m_new, l_keypad ATTRIBUTES(WITHOUT DEFAULTS)
				ON CHANGE m_lev

				ON ACTION clr LET m_chords = ""
&ifdef VER2
				ON ACTION key01 DISPLAY "01" LET m_chords = m_chords.append(" A")
				ON ACTION key02 DISPLAY "02" LET m_chords = m_chords.append(" B")
				ON ACTION key03 DISPLAY "03" LET m_chords = m_chords.append(" C")
				ON ACTION key07 DISPLAY "07" LET m_chords = m_chords.append(" D")
				ON ACTION key08 DISPLAY "08" LET m_chords = m_chords.append(" E")
				ON ACTION key09 DISPLAY "09" LET m_chords = m_chords.append(" F")
				ON ACTION key13 DISPLAY "13" LET m_chords = m_chords.append(" G")

				ON ACTION key04 DISPLAY "04" LET m_chords = m_chords.append("m")
				ON ACTION key05 DISPLAY "05" LET m_chords = m_chords.append("5")
				ON ACTION key06 DISPLAY "06" LET m_chords = m_chords.append("sus4")

				ON ACTION key10 DISPLAY "10" LET m_chords = m_chords.append("M7")
				ON ACTION key11 DISPLAY "11" LET m_chords = m_chords.append("6")
				ON ACTION key12 DISPLAY "12" LET m_chords = m_chords.append("sus2")

				ON ACTION key14 DISPLAY "14" LET m_chords = m_chords.append("b")
				ON ACTION key15 DISPLAY "15" LET m_chords = m_chords.append("#")
				ON ACTION key16 DISPLAY "16" LET m_chords = m_chords.append("7")
				ON ACTION key17 DISPLAY "17" LET m_chords = m_chords.append("9")
				ON ACTION key18 DISPLAY "18" LET m_chords = ""
&else
				ON ACTION na LET m_chords = m_chords.append(" A")
				ON ACTION nb LET m_chords = m_chords.append(" B")
				ON ACTION nc LET m_chords = m_chords.append(" C")
				ON ACTION nd LET m_chords = m_chords.append(" D")
				ON ACTION ne LET m_chords = m_chords.append(" E")
				ON ACTION nf LET m_chords = m_chords.append(" F")
				ON ACTION ng LET m_chords = m_chords.append(" G")
				ON ACTION fl  LET m_chords = m_chords.append("b")
				ON ACTION sp  LET m_chords = m_chords.append("#")
				ON ACTION mn LET m_chords = m_chords.append("m")
				ON ACTION m7 LET m_chords = m_chords.append("M7")
				ON ACTION n7 LET m_chords = m_chords.append("7")
				ON ACTION n9 LET m_chords = m_chords.append("9")
				ON ACTION n6 LET m_chords = m_chords.append("6")
				ON ACTION s2 LET m_chords = m_chords.append("sus2")
				ON ACTION s4 LET m_chords = m_chords.append("sus4")
&endif
			END INPUT
			DISPLAY ARRAY alts TO arr.*
			END DISPLAY

			ON ACTION doit EXIT DIALOG

			ON ACTION editshapes
				CALL editShapes()
			ON ACTION defshapes
				CALL get_shapes("shapes.txt")
			ON ACTION custshapes
				CALL get_shapes("shapes2.txt")
			ON ACTION diag
				CALL getchords()
				CALL diag()
			ON ACTION about
				CALL gl_lib.gl_about(c_ver,"capoTrans", "Neil J Martin(danteuk@gmail.com)", TRUE)
			ON ACTION quit
				LET int_flag = TRUE
				EXIT DIALOG
			BEFORE DIALOG
				DISPLAY "In Dialog:",CURRENT
		END DIALOG
		DISPLAY "getChords:",CURRENT
		IF NOT int_flag THEN CALL getchords() END IF
		DISPLAY "End:",CURRENT
	END WHILE

END MAIN
--------------------------------------------------------------------------------
FUNCTION get_notes()
	LET notes[ notes.getLength() + 1 ] = "A"
	LET notes[ notes.getLength() + 1 ] = "A#"
	LET notes[ notes.getLength() + 1 ] = "B"
	LET notes[ notes.getLength() + 1 ] = "C"
	LET notes[ notes.getLength() + 1 ] = "C#"
	LET notes[ notes.getLength() + 1 ] = "D"
	LET notes[ notes.getLength() + 1 ] = "D#"
	LET notes[ notes.getLength() + 1 ] = "E"
	LET notes[ notes.getLength() + 1 ] = "F"
	LET notes[ notes.getLength() + 1 ] = "F#"
	LET notes[ notes.getLength() + 1 ] = "G"
	LET notes[ notes.getLength() + 1 ] = "G#"

	LET notes2[ notes2.getLength() + 1 ] = "A"
	LET notes2[ notes2.getLength() + 1 ] = "Bb"
	LET notes2[ notes2.getLength() + 1 ] = "B"
	LET notes2[ notes2.getLength() + 1 ] = "C"
	LET notes2[ notes2.getLength() + 1 ] = "Dd"
	LET notes2[ notes2.getLength() + 1 ] = "D"
	LET notes2[ notes2.getLength() + 1 ] = "Eb"
	LET notes2[ notes2.getLength() + 1 ] = "E"
	LET notes2[ notes2.getLength() + 1 ] = "F"
	LET notes2[ notes2.getLength() + 1 ] = "Gb"
	LET notes2[ notes2.getLength() + 1 ] = "G"
	LET notes2[ notes2.getLength() + 1 ] = "Ab"
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION get_shapes(l_file)
	DEFINE c base.channel
	DEFINE l_file STRING
	LET c = base.channel.create()

	CALL chord_shapes.clear()

	IF NOT os.Path.exists( l_file ) THEN
		LET l_file = "shapes.txt" -- defaults
		IF NOT os.Path.exists( l_file ) THEN
			CALL gl_winMessage("Error","Failed to find "||l_file||"\npwd: "||os.path.pwd(),"exclamation")
			EXIT PROGRAM
		END IF
	END IF

	CALL c.openFile(l_file,"r")
	WHILE TRUE
		IF c.isEof() THEN EXIT WHILE END IF
		IF c.read( chord_shapes[ chord_shapes.getLength() + 1 ] ) = 0 THEN
			EXIT WHILE
		END IF
		IF chord_shapes[chord_shapes.getLength()].NAME = "-" THEN
			LET chord_shapes[chord_shapes.getLength()].dspnam = chord_shapes[chord_shapes.getLength()].root_note CLIPPED
		ELSE
			LET chord_shapes[chord_shapes.getLength()].dspnam = 
				chord_shapes[chord_shapes.getLength()].root_note CLIPPED,
				chord_shapes[chord_shapes.getLength()].NAME
		END IF
		IF chord_shapes[chord_shapes.getLength()].vari > 0 THEN
			LET chord_shapes[chord_shapes.getLength()].dspnam = chord_shapes[chord_shapes.getLength()].dspnam CLIPPED,
 "   Alternative:",chord_shapes[chord_shapes.getLength()].vari
		END IF
	END WHILE
	CALL c.close()
	IF chord_shapes[chord_shapes.getLength()].name IS NULL THEN 
		CALL chord_shapes.deleteElement( chord_shapes.getLength() ) 
	END IF

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getchords()
	DEFINE c STRING
	DEFINE x SMALLINT

	LET m_new = ""
	LET m_chords = m_chords.trim()||" "

	CALL alts.clear()

	FOR x = 1 TO m_chords.getLength()
		IF m_chords.getCharAt(x) != " " THEN
			LET c = c.append(m_chords.getCharAt(x))
		ELSE
			CALL transpose( c.trim() )
			LET c = " "
		END IF
	END FOR	

	FOR x = alts.getLength() TO 1 STEP -1
		LET alts[x].desc = "Pos: ",(alts[x].pos USING "<#"),"  Rating:",(alts[x].score USING "<#")
		--DISPLAY "Remove invalid:",x," :",alts[x].score
		IF alts[x].score = -1 THEN 
			CALL alts.deleteElement( x )
		END IF
	END FOR
	LET alts[8].desc = "" -- make sure there some rows in the table.
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION autoFix(c)
	DEFINE c,n STRING
	DEFINE x,exp SMALLINT

	LET c = c.trim()
	LET exp = TRUE
	FOR x = 1 TO c.getLength()
		IF c.getCharAt(x) MATCHES "[ABCDEFG]" THEN
		END IF
	END FOR
	RETURN n
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION transpose(c)
	DEFINE n,c,e,s STRING
	DEFINE l SMALLINT

	LET c = c||" "
	--DISPLAY "c:",c

	LET e = "x"
	LET l = c.getLength()
	IF c.getCharAt(2) != "b" AND c.getCharAt(2) != "#" THEN 
		LET e = c.subString(2,l)
		LET c = c.subString(1,1)
	ELSE
		LET e = c.subString(3,l)
		LET c = c.subString(1,2)
	END IF

	--DISPLAY "c:",c," e:",e
	LET n = transpose_note( c, m_lev )

	LET s = n||NVL(e," ")
	LET m_new = m_new.append( s||" " )
	--DISPLAY "n:",n, " nn:",n, " e:", e, " s:",s
	CALL best_shape( n, e )

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION transpose_note( n, l_lev )
	DEFINE n STRING
	DEFINE l_lev, x SMALLINT
	DEFINE done BOOLEAN

	LET done = FALSE
	IF m_sharp THEN
		FOR x = 1 TO notes.getLength()
			IF n = notes[x] THEN
				LET x = x + l_lev
				IF x > 12 THEN LET x = x - 12 END IF
				IF x < 1 THEN LET x = x + 12 END IF
				LET n = notes[x]
				LET done = TRUE
				EXIT FOR
			END IF
		END FOR
	ELSE
		FOR x = 1 TO notes2.getLength()
			IF n = notes2[x] THEN
				LET x = x + l_lev
				IF x > 12 THEN LET x = x - 12 END IF
				IF x < 1 THEN LET x = x + 12 END IF
				LET n = notes2[x]
				LET done = TRUE
				EXIT FOR
			END IF
		END FOR
	END IF
	RETURN n
END FUNCTION
--------------------------------------------------------------------------------
-- n = root note
-- t = type of chord ( m 7 m7 etc )
FUNCTION best_shape( n, t )
	DEFINE n, cs, nr, t, s STRING
	DEFINE capo,x,p,score SMALLINT
	
	--DISPLAY "N:",n," T:",t
	FOR capo = 1 TO 8
		IF t IS NULL OR t = " " THEN LET t = "-" END IF
		LET cs = "?"
		LET score = 0
		LET p = -1
		FOR x = 1 TO chord_shapes.getLength()
			LET nr = transpose_note( chord_shapes[ x ].root_note , capo )
			IF nr = n THEN
				IF chord_shapes[ x ].name = t THEN
					--DISPLAY "Capo:",capo, " POS:",chord_shapes[ x ].pos," N:",chord_shapes[ x ].root_note," CS:",nr, " Name:",chord_shapes[ x ].name
--					IF chord_shapes[ x ].pos = 0 THEN
						LET cs = chord_shapes[ x ].root_note
						LET p = chord_shapes[ x ].pos
						LET score = chord_shapes[ x ].score
--					END IF
				ELSE
					--DISPLAY "  Capo:",capo," N:",chord_shapes[ x ].root_note," Trans:",nr, " Name:",chord_shapes[ x ].name," WRONG TYPE:",t
				END IF
			ELSE
				--DISPLAY "  Capo:",capo," N:",chord_shapes[ x ].root_note," Trans:",nr," NOT EQUAL"
			END IF
		END FOR
	
		IF t = "-" THEN LET t = NULL END IF
		IF alts[capo].score IS NULL THEN LET alts[capo].score = 0 END IF
		IF alts[capo].score > -1 THEN LET alts[capo].score = alts[capo].score + score END IF
		IF p < 0 THEN LET alts[capo].score = -1 END IF
		LET alts[capo].pos = capo
		IF p > 0 THEN
			LET s = cs.trim(),t.trim(),"  " --,(p USING("<&")),"ft  "
		ELSE
			LET s = cs,t,"  "
		END IF
--		IF cs = "?" THEN
--			LET alts[capo].shapes = 
--		ELSE
			LET alts[capo].shapes = alts[capo].shapes.append( s )
--		END IF

	END FOR
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION editShapes()
	DEFINE ch_no SMALLINT
	DEFINE wc CHAR(7)
	OPEN WINDOW shapes WITH FORM "shapes"
	LET int_flag = FALSE
	LET ch_no = 1
	DISPLAY BY NAME chord_shapes[ ch_no ].*
	IF chord_shapes[ ch_no ].str1 = -1 THEN DISPLAY " " TO str1 END IF
	IF chord_shapes[ ch_no ].str2 = -1 THEN DISPLAY " " TO str2 END IF
	LET wc = buildWC(ch_no)
	WHILE NOT int_flag
		INPUT BY NAME ch_no,wc ATTRIBUTES(UNBUFFERED,WITHOUT DEFAULTS)
			ON CHANGE ch_no
				DISPLAY BY NAME chord_shapes[ ch_no ].*
				IF chord_shapes[ ch_no ].str1 = -1 THEN DISPLAY " " TO str1 END IF
				IF chord_shapes[ ch_no ].str2 = -1 THEN DISPLAY " " TO str2 END IF
				LET wc = buildWC(ch_no)
			ON ACTION newshape
				CALL edit_shape(chord_shapes.getLength() + 1 )
				LET wc = buildWC(ch_no)
			ON ACTION save
				CALL save()
		END INPUT
		IF int_flag THEN EXIT WHILE END IF
		CALL edit_shape( ch_no )
	END WHILE
	LET int_flag = FALSE
	CLOSE WINDOW shapes
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION buildWC(ch_no)
	DEFINE ch_no SMALLINT
	DEFINE wc CHAR(7)
  LET wc = "XXXXXX0"
	IF chord_shapes[ ch_no ].str1	>= 0 THEN LET wc[1] = chord_shapes[ ch_no ].str1 END IF
	IF chord_shapes[ ch_no ].str2	>= 0 THEN LET wc[2] = chord_shapes[ ch_no ].str2 END IF
	IF chord_shapes[ ch_no ].str3	>= 0 THEN LET wc[3] = chord_shapes[ ch_no ].str3 END IF
	IF chord_shapes[ ch_no ].str4	>= 0 THEN LET wc[4] = chord_shapes[ ch_no ].str4 END IF
	IF chord_shapes[ ch_no ].str5	>= 0 THEN LET wc[5] = chord_shapes[ ch_no ].str5 END IF
	IF chord_shapes[ ch_no ].str6	>= 0 THEN LET wc[6] = chord_shapes[ ch_no ].str6 END IF
	LET wc[7] = chord_shapes[ ch_no ].pos
	RETURN wc
END FUNCTION

FUNCTION edit_shape(ch_no)
	DEFINE ch_no SMALLINT

	INPUT BY NAME chord_shapes[ ch_no ].* ATTRIBUTES(UNBUFFERED,WITHOUT DEFAULTS)
		BEFORE INPUT
			IF chord_shapes[ ch_no ].dspnam IS NULL THEN
				LET chord_shapes[ ch_no ].str1 = -1
				LET chord_shapes[ ch_no ].str2 = -1
				LET chord_shapes[ ch_no ].str3 = -1
				LET chord_shapes[ ch_no ].str4 = -1
				LET chord_shapes[ ch_no ].str5 = -1
				LET chord_shapes[ ch_no ].str6 = -1
				LET chord_shapes[ ch_no ].vari = 1
				LET chord_shapes[ ch_no ].score = 0
				LET chord_shapes[ ch_no ].pos = 0
			ELSE
				CALL dialog.setFieldActive( "formonly.root_note", FALSE )
				CALL dialog.setFieldActive( "formonly.name", FALSE )
			END IF
			CALL dialog.setFieldActive( "formonly.dspnam", FALSE )
	END INPUT
	IF NOT int_flag THEN
-- Save?
	ELSE
		CALL chord_shapes.deleteElement( ch_no )
	END IF
	LET int_flag = FALSE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION cb_chordno(cb)
	DEFINE cb ui.ComboBox
	DEFINE x SMALLINT
	FOR x = 1 TO chord_shapes.getLength()
		CALL cb.addItem( x, chord_shapes[x].dspnam )
	END FOR
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION save()
	DEFINE c base.channel
	DEFINE x SMALLINT
	DEFINE l_file STRING
	LET c = base.channel.create()

	LET l_file = "shapes2.txt"
	CALL c.openFile(l_file,"w")
	FOR x = 1 TO chord_shapes.getLength()
		CALL c.write( chord_shapes[ x ] )
	END FOR
	CALL c.close()
	CALL gl_winMessage("Information","Shapes saved\nUse 'Default Shapes' options to reset","information")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION diag()
	DEFINE wc STRING
	DEFINE chord CHAR(7)
	DEFINE x SMALLINT
	DEFINE st base.StringTokenizer
	OPEN WINDOW diag WITH FORM "diag"
--          1234567
	LET st = base.StringTokenizer.create( m_new, " " )
	WHILE st.hasMoreTokens()
		LET chord = st.nextToken()
		IF chord[2] = "#" THEN LET chord[2] = "s" END IF
		IF NOT os.path.exists("chord_diag/diag_"||chord CLIPPED||".svg" ) THEN
			LET chord = "ND"
		END IF
		LET wc = wc,chord
	END WHILE
	DISPLAY wc
	INPUT BY NAME wc ATTRIBUTES(WITHOUT DEFAULTS, UNBUFFERED )
		BEFORE INPUT
			CALL DIALOG.setActionHidden("cancel",TRUE)
			CALL DIALOG.setActionActive("cancel",FALSE)
		ON ACTION close EXIT INPUT
	END INPUT
	CLOSE WINDOW diag
END FUNCTION
