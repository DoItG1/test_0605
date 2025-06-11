 select ManAdmFor, Me_Man.ManComDte,                     
 PerChtNum, ManAttend, PerZipAdr, PerPatNam, PerResNum   
 from ME_MAN                                             
 	                                                     
 	inner join PB_Person                                 
 	  on ManChtNum = PerChtNum                             
                                                         
 	INNER JOIN PB_GAMOKVIEW                              
 	ON MANDEPCOD = GMODEPCOD                             
 	AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE        
 	AND GMOCANCEL = 0                                    
 	                                                      
 	inner join (SELECT MAX(ManComDte) AS ManComDte, ManChtNum   
 	              FROM ME_MAN                                   
 	             WHERE ManCanCel = 0                            
                   AND ManEndDte = ManDisDte                    
 and ManComDte between '{DATE_FROM}' and '{DATE_TO}'
                 GROUP BY ManChtNum) AS ME_MAN2                 
            ON ME_MAN.ManComDte = ME_MAN2.ManComDte             
           AND ME_MAN.ManChtNum = ME_MAN2.ManChtNum             
 where ManCancel = 0                      
 and ManEndDte = ManDisDte                
 group by ManAdmFor, ME_MAN.ManComDte, PerChtNum, ManAttend, PerZipAdr, PerPatNam, PerResNum   
 order by PerZipAdr 