 select --입원, 외래                                                          
 CASE WHEN MANADMFOR = 'A' THEN 'IP'                                      
 ELSE 'WP' END AS IPWP,                                                     
 RTRIM(MANDEPCOD)+'.'+GMODEPNAM AS GName, MANJINGUB, MANADMFOR,             
 SUBSTRING(MANCOMDTE, 6,2) AS SetMonth, COUNT(MANCOMDTE) as SumCnt            
 from ME_MAN                                                                  
 	INNER JOIN PB_GAMOKVIEW                                                    
 	ON MANDEPCOD = GMODEPCOD                                                   
 	AND GMOCANCEL = 0                                                          
 	AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE                              
 WHERE MANCANCEL = 0                                                          
 AND MANDISDTE = MANENDDTE                                                    
 AND MANCOMDTE BETWEEN '{DATE_FROM}' and '{DATE_TO}'

 AND MANDEPCOD <> '' AND MANJINGUB <> ''                                  
 AND MANADMFOR <> ''                                                        
 GROUP BY MANDEPCOD,GMODEPNAM, MANJINGUB, MANADMFOR, SUBSTRING(MANCOMDTE, 6,2)
                                                                              
 UNION ALL                                                                    
 -- 퇴원                                                                      
 select 'OUT' AS IPWP, RTRIM(MANDEPCOD)+'.'+GMODEPNAM AS GName, MANJINGUB,
 MANADMFOR, SUBSTRING(MANDISDTE, 6,2), COUNT(MANDISDTE)                       
 from ME_MAN                                                                  
 	INNER JOIN PB_GAMOKVIEW                                                    
 	ON MANDEPCOD = GMODEPCOD                                                   
 	AND GMOCANCEL = 0                                                          
 	AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE                              
 WHERE MANCANCEL = 0                                                          
 AND MANDISDTE = MANENDDTE                                                    
 AND MANDISDTE BETWEEN '{DATE_FROM}' and '{DATE_TO}'

 AND MANDISGUB = 'T' AND MANADMFOR = 'A'                                  
 AND MANDEPCOD <> '' AND MANJINGUB <> ''                                  
 AND MANADMFOR <> ''                                                        
 GROUP BY MANDEPCOD,GMODEPNAM, MANJINGUB, MANADMFOR, SUBSTRING(MANDISDTE, 6,2)
                                                                              
 UNION ALL                                                                    
 -- 신환                                                                      
 select 'NEW' AS IPWP, RTRIM(MANDEPCOD)+'.'+GMODEPNAM AS GName, 'NEW',  
 'NEW', SUBSTRING(PERNEWDTE, 6,2) AS SetMonth, COUNT(PERNEWDTE) as SumCnt   
 FROM ME_MAN                                                                  
 	INNER JOIN PB_GAMOKVIEW                                                    
 	ON MANDEPCOD = GMODEPCOD                                                   
 	AND GMOCANCEL = 0                                                          
 	AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE                              
                                                                              
 	INNER JOIN PB_PERSON                                                       
 	ON MANCOMDTE =PERNEWDTE                                                    
 	AND MANCHTNUM = PERCHTNUM                                                  
 	AND MANCANCEL = 0                                                          
 	AND MANDISDTE = MANENDDTE                                                  
 WHERE PERNEWDTE  BETWEEN '{DATE_FROM}' and '{DATE_TO}'

 GROUP BY MANDEPCOD,GMODEPNAM, SUBSTRING(PERNEWDTE, 6,2)                      
                                                                              
 ORDER BY GName                                                               