 SELECT MEYYUNGSU,PCMCVALUE, MeyAofGub,    
 SUM( MEY1MTAMT+MEY1ATAMT ) as TotAmt 
 FROM ME_YUNGSU YM                   
                                     
   Inner join PB_GamokView           
   on MeyDepCod = GmoDepCod          
   and MeyRctDte between GmoStrDte and GmoEndDte 
   and GmoCancel = 0                 
                                     
 	INNER JOIN ME_YUNGSUITEM YI       
 	ON YI.MEYCANCEL = 0               
 	AND YM.MEYATTEND = YI.MEYATTEND   
     AND YM.MEYRCTDTE = YI.MEYRCTDTE 
     AND YM.MEYRCTNUM = YI.MEYRCTNUM 
                                     
   RIGHT JOIN PB_CODEMAP             
 	ON PCMLGROUP = 'YUNGUB'   
 	AND YI.MEYYUNGSU = PCMCGUBUN      
                                     
 WHERE YM.MEYCANCEL = 0              
 and YM.MEYINSDTE between '{DATE_FROM}' and '{DATE_TO}'
and MeyInsCod <> 'G'               
 and GMOHGUBUN IN ('1','2') 
 GROUP BY MEYYUNGSU, PCMCVALUE,MeyAofGub 
 ORDER BY MEYYUNGSU                  