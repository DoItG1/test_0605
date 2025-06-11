SELECT PBRWARDNO,MANDEPCOD,GMODEPNAM,COUNT(*) AS CNT FROM ME_MAN 
	LEFT OUTER JOIN PB_ROOMVIEW                                       
	ON MANROMNUM = PBRROOMNO                                      
	AND PBRCANCEL = 0                                             
                                                                 
	LEFT OUTER JOIN PB_GAMOKVIEW                                  
	ON MANDEPCOD = GMODEPCOD                                      
	AND MANSTADTE BETWEEN GMOSTRDTE AND GMOENDDTE                 
	AND GMOCANCEL = 0                                             
WHERE MANCANCEL = 0                                              
AND  MANCOMDTE <= '{DATE}'                           
AND ((MANDISGUB='T' AND ('{DATE}' BETWEEN MANSTADTE AND MANENDDTE) AND MANDISDTE > '{DATE}')       
OR  (MANDISGUB='' AND (('{DATE}' BETWEEN MANSTADTE AND MANENDDTE) OR (MANENDDTE = '' AND MANSTADTE <='{DATE}'))))  
AND MANMLTCON = ''                                             
AND MANADMFOR = 'A'                                            
GROUP BY MANDEPCOD,GMODEPNAM,PBRWARDNO                           

SELECT MANINSCOD,MANDEPCOD, GMODEPNAM,MANDEPCOD,COUNT(*) AS CNT FROM ME_MAN 
	LEFT OUTER JOIN PB_GAMOKVIEW                                             
	ON MANDEPCOD = GMODEPCOD                                                 
	AND MANSTADTE BETWEEN GMOSTRDTE AND GMOENDDTE                            
	AND GMOCANCEL = 0                                                        
WHERE MANCANCEL = 0                                                       
AND  MANCOMDTE <= '{DATE}'                           
AND ((MANDISGUB='T' AND ('{DATE}' BETWEEN MANSTADTE AND MANENDDTE) AND MANDISDTE > '{DATE}')       
OR  (MANDISGUB='' AND (('{DATE}' BETWEEN MANSTADTE AND MANENDDTE) OR (MANENDDTE = '' AND MANSTADTE <='{DATE}')))) 
AND MANMLTCON = ''                                             
AND MANADMFOR = 'A'                                                       
GROUP BY MANDEPCOD,GMODEPNAM,MANINSCOD                                      