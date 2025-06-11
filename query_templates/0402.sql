 select MANCHTNUM, PERPATNAM, PERRESNUM, MANROMNUM,MANDEPCOD,                          
 '['+rtrim(BYUDISCOD)+']'+BYUDISNAM AS DISEASE , MANCOMDTE,                        
 CAST (GETDATE() - CAST(MANCOMDTE AS DATETIME) AS INT) AS Days,                        
 RTRIM(MANINSCOD)+RTRIM(MANINSSUB) AS YUHYUNG,                                         
 RTRIM(PERTEL001)+'-'+RTRIM(PERTEL002)+'-'+RTRIM(PERTEL003) AS PERTELNUM,          
 RTRIM(PERCEL001)+'-'+RTRIM(PERCEL002)+'-'+RTRIM(PERCEL003) AS PERCELNUM,          
 RTRIM(PERZIPADR)+' '+RTRIM(PERDTLADR) AS PERADDRES, MANROMCHA, PCMCVALUE,           
 MANDISDTE                                                                             
 FROM ME_MAN                                                                           
                                                                                       
 	LEFT OUTER JOIN ME_BYUNG                                                             
 	ON MANATTEND = BYUATTEND                                                            
 	AND BYUCANCEL = 0                                                                   
 	AND BYUMAJYON = 'Y'                                                               
 	                                                                                    
 	INNER JOIN PB_PERSON                                                                
 	ON MANCHTNUM = PERCHTNUM                                                            
                                                                                       
 	INNER JOIN PB_CODEMAP                                                                
 	   ON PCMLGROUP ='YUHYUNG'                                                         
 	  AND PCMMGROUP = MANINSCOD                                                          
 	  AND PCMCGUBUN = MANINSSUB                                                          
                                                                                       
 WHERE MANCANCEL = 0                                                                   
 AND MANADMFOR = 'A'                                                                 
 AND MANDISDTE = MANENDDTE                                                             
 AND MANDISGUB = ''                                                                  
 AND MANMLTCON = ''                                                             
 ORDER BY MANCHTNUM,MANINSCOD,MANINSSUB                                                