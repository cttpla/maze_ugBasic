'SCREEN #3
'BITMAP ENABLE (160,200,16)
CLS
POKE &H2076,0
POKE &H2019,PEEK(&H2019) OR 8
 
f1_p1_lw := LOAD IMAGE("maze/f1_p1_lw.bmp")
f1_p1_flw := LOAD IMAGE("maze/f1_p1_flw.bmp")
f1_p2_lw := LOAD IMAGE("maze/f1_p2_lw.bmp")
f1_p2_flw := LOAD IMAGE("maze/f1_p2_flw.bmp")
f1_p2_flbw := LOAD IMAGE("maze/f1_p2_flbw.bmp")
f1_p3_lw := LOAD IMAGE("maze/f1_p3_lw.bmp")
f1_p3_flbw := LOAD IMAGE("maze/f1_p3_flbw.bmp")

f1_p1_fw := LOAD IMAGE("maze/f1_p1_fw.bmp")
f1_p3_fw := LOAD IMAGE("maze/f1_p3_fw.bmp")

f1_p1_rw := LOAD IMAGE("maze/f1_p1_lw.bmp") FLIP X
f1_p1_frw := LOAD IMAGE("maze/f1_p1_flw.bmp") FLIP X
f1_p2_rw := LOAD IMAGE("maze/f1_p2_lw.bmp") FLIP X
f1_p2_frw := LOAD IMAGE("maze/f1_p2_flw.bmp") FLIP X
f1_p2_frbw := LOAD IMAGE("maze/f1_p2_flbw.bmp") FLIP X
f1_p3_rw := LOAD IMAGE("maze/f1_p3_lw.bmp") FLIP X
f1_p3_frbw := LOAD IMAGE("maze/f1_p3_flbw.bmp") FLIP X


'LABIRINTH LV1
'LOCATE 0,3:PRINT "Building labyrinth ..."
'
mapW=#9:mapH=#9:mX=#0
CONST north=0:CONST east=1:CONST south=2:CONST west=3
cntr=#0:curdir=#0
'
DIM map(9,9,1)
DIM lab(27)=#{ 7,7,7,4,4,5,6,6,5,4,2,5,6,0,1,4,5,5,5,1,5,5,2,1,7,7,7 }

VAR p AS BYTE
VAR dN AS BYTE
VAR iM AS BYTE

FOR y=0 TO 8
 FOR x=0 TO 2
   	dN = lab(iM)
   	INC iM
	map(mX,y,0)=-1*((dN AND 4) > 0)  
	INC mX
	map(mX,y,0)=-1*((dN AND 2) > 0)   
	INC mX
	map(mX,y,0)=-1*((dN AND 1) > 0)
	INC mX
	'PRINT x;" ";y;" ";dN
	'PRINT map(1,p,0);map(2,p,0);map(3,p,0)
 NEXT 
mX = 0
NEXT 

'X,Y,DIR ON LABYRINTH MAP
DIM coordX(9,9,4):DIM coordY(9,9,4):DIM movF(2,4):DIM movB(2,4)
'NORTH
coordX(0,0,north)=-1:coordX(2,0,north)=1:coordX(0,1,north)=-1:coordX(2,1,north)=1:coordX(0,2,north)=-1:coordX(2,2,north)=1
coordY(0,0,north)=-2:coordY(1,0,north)=-2:coordY(2,0,north)=-2:coordY(0,1,north)=-1:coordY(1,1,north)=-1:coordY(2,1,north)=-1
'EAST
coordX(0,0,east)=2:coordX(1,0,east)=2:coordX(2,0,east)=2:coordX(0,1,east)=1:coordX(1,1,east)=1:coordX(2,1,east)=1
coordY(0,0,east)=-1:coordY(2,0,east)=1:coordY(0,1,east)=-1:coordY(2,1,east)=1:coordY(0,2,east)=-1:coordY(2,2,east)=1
'SOUTH
coordX(0,0,south)=1:coordX(2,0,south)=-1:coordX(0,1,south)=1:coordX(2,1,south)=-1:coordX(0,2,south)=1:coordX(2,2,south)=-1
coordY(0,0,south)=2:coordY(1,0,south)=2:coordY(2,0,south)=2:coordY(0,1,south)=1:coordY(1,1,south)=1:coordY(2,1,south)=1
'WEST
coordX(0,0,west)=-2:coordX(1,0,west)=-2:coordX(2,0,west)=-2:coordX(0,1,west)=-1:coordX(1,1,west)=-1:coordX(2,1,west)=-1
coordY(0,0,west)=1:coordY(2,0,west)=-1:coordY(0,1,west)=1:coordY(2,1,west)=-1:coordY(0,2,west)=1:coordY(2,2,west)=-1
'
'MOVEMENTS ON GENERAL MAP
'0 = X, 1 = Y
movF(1,north)=-1:movB(1,north)=1:movF(1,south)=1:movB(1,south)=-1:movF(0,east)=1:movB(0,east)=-1:movF(0,west)=-1:movB(0,west)=1
bVal1=0
plrDir=north
plrPsx=1
plrPsy=7 

DIM tileView (3,3)
limX = mapW -1
limY = mapH -1 

GOSUB drawLab

' Main loop
DO

	k = INKEY$
	IF k <> "" THEN
	
	'Up
	IF ASC(k) == 11 THEN
	GOSUB movFwd 
	ENDIF
	'Down
	IF ASC(k) == 10 THEN
	GOSUB movBck
	ENDIF
	'Right
	IF ASC(k) == 9 THEN
	GOSUB trnEst
	ENDIF
	'Left
	IF ASC(k) == 8 THEN
	GOSUB trnWst
	ENDIF
	
	ENDIF
'

LOOP

movFwd:
'IF BETM(3)=1 AND ETMVL1(ETMS(PLRPSX,PLRPSY,PLRDIR,1))=1 THEN CLS:RETURN 'EXIT DUNGEON
'check wall
IF map(plrPsx+movF(0,plrDir),plrPsy+movF(1,plrDir),0)=1 THEN 
'OUCH!
RETURN
ENDIF
ADD plrPsx, movF(0,plrDir)
ADD plrPsy, movF(1,plrDir)
GOSUB drawLab
RETURN

movBck:
'check wall
IF map(plrPsx+movB(0,plrDir),plrPsy+movB(1,plrDir),0)=1 THEN 
'OUCH!
RETURN
ENDIF
ADD plrPsx, movB(0,plrDir)
ADD plrPsy, movB(1,plrDir)
GOSUB drawLab
RETURN

trnEst: 
IF plrDir==west THEN 
plrDir=north 
ELSE
INC plrDir
ENDIF
GOSUB drawLab
RETURN

trnWst: 
IF plrDir==north THEN 
plrDir=west 
ELSE
DEC plrDir
ENDIF
GOSUB drawLab
RETURN


drawLab:

'ERASE
CLS

'*********** Select labyrinth view
FOR y=0 TO 2
	FOR x=0 TO 2
		tilX=plrPsx+coordX(x,y,plrDir)
		IF tilX<0 OR tilX>limX THEN 
			tilX=0 
		ENDIF
		'
		tilY=plrPsy+coordY(x,y,plrDir)
		IF tilY<0 OR tilY>limY THEN 
			tilY=0 
		ENDIF  
		'
		tileView(x,y)=map(tilX,tilY,0)
		'PRINT tileView(x,y)
	NEXT 
NEXT 


'debug view
'tileView(0,0) = 1
'tileView(1,0) = 1
'tileView(2,0) = 1
'tileView(0,1) = 1
'tileView(1,1) = 0
'tileView(2,1) = 1
'tileView(0,2) = 1
'tileView(1,2) = 0
'tileView(2,2) = 1


 ' ************
 ' * DRAW LAB *
 ' ************
 ' far,med,close
 ' ************
 IF tileView(0,0) == 1 THEN 
 	GOSUB cSideFarL 
 ENDIF
 IF tileView(1,0) == 1 THEN 
 	GOSUB cWallFar 
 ENDIF
 IF tileView(2,0) == 1 THEN 
 	GOSUB cSideFarR 
 ENDIF
 IF tileView(0,1) == 1 THEN 
 	GOSUB cSideMedL 
 ENDIF
 IF tileView(1,1) == 1 THEN 
 	GOSUB cWallClose 
 ENDIF
 IF tileView(2,1) == 1 THEN 
 	GOSUB cSideMedR 
 ENDIF
 IF tileView(0,2) == 1 THEN 
 	GOSUB cSideCloseL 
 ENDIF
 IF tileView(1,2) == 1 THEN 
 	GOSUB cWallClose 
 ENDIF
 IF tileView(2,2) == 1 THEN 
 	GOSUB cSideCloseR 
 ENDIF
 
RETURN


 '+++++++++++++++++++
 '+ LABIRINTH TILES +
 '+++++++++++++++++++
cWallClose:
 ' *** WALL : " * "
 ' *** CLOSE VIEW
 PUT IMAGE f1_p1_fw AT 33, 39
 RETURN
 
cWallMed: 
 '******* MEDIUM VIEW
  PUT IMAGE f1_p2_flw AT 25, 40
 RETURN
 
cWallFar: 
 '******* FAR VIEW
 IF tileView(1,1)<> 1 THEN
    PUT IMAGE f1_p3_fw AT 54, 51
 ENDIF    
 'IF betM(2)=1 THEN BOX(84,58)-(96,70),COLR ELSE IF betM(2)=2 THEN BOXF(85,65)-(95,73),CCHEST ELSE IF betM(2)=4 THEN BOXF(88,60)-(93,73),COLR
 RETURN
 
cSideCloseL: 
 ' *** SIDE WALLS : "* *"
 ' *** CLOSE VIEW
 'PARETESX "*  ": PARETEDX "  *"
  PUT IMAGE f1_p1_lw AT 0, 24
 RETURN

cSideCloseR: 
  PUT IMAGE f1_p1_rw AT 98, 24
 RETURN
 
 ' ******* MEDIUM VIEW
cSideMedL: 
 'pareteSX
 IF tileView(1,1)<>1 THEN 
 	PUT IMAGE f1_p2_lw AT 33, 40
 ENDIF
 IF tileView(0,2)<>1 THEN
 	PUT IMAGE f1_p1_flw AT 0, 39
 ENDIF
 RETURN
 
cSideMedR:  
 'pareteDX
 IF tileView(1,1)<>1 THEN
 	PUT IMAGE f1_p2_rw AT 73, 40
 ENDIF
 IF tileView(2,2)<>1 THEN
 	PUT IMAGE f1_p1_frw AT 98, 39
 ENDIF
 RETURN

cSideFarL:  
 ' ******* FAR VIEW
 'pareteSX
 IF tileView(0,0)==1 THEN
 	 PUT IMAGE f1_p3_lw AT 56, 52
 ENDIF
 IF tileView(1,1)<>1 OR tileView(1,0)<>1 THEN
 	PUT IMAGE f1_p3_flbw AT 0, 51
 ENDIF 
 RETURN

cSideFarR:  
 'pareteDX
 IF tileView(2,0)==1 AND tileView(1,0)==0 THEN
 	 PUT IMAGE f1_p3_rw AT 64, 52
 ENDIF
 IF tileView(1,1)<>1 OR tileView(1,0)<>1 THEN
 	PUT IMAGE f1_p3_frbw AT 73, 51
 ENDIF
 RETURN



