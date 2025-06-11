 select PERCHTNUM, PERPATNAM, PERRESNUM, DATODRDTE,          
 case when MANADMFOR = 'A' THEN '입원' ELSE '외래' END AS MANADMFOR, 
 GMODEPNAM,DATOUTNUM, DATODRCOD, DATODRNAM,                  
 DATTOTQTY,DATODRDAY,                                        
 CAST(DATTOTQTY AS FLOAT)*CAST(DATODRDAY AS FLOAT) AS UseCnt 
 FROM ME_DAT                                         
                                                             
    INNER join PB_GAMOKVIEW                                  
    ON DATDEPCOD = GMODEPCOD                                 
    AND DATODRDTE BETWEEN GMOSTRDTE AND GMOENDDTE            
    AND GMOCANCEL = 0                                        
                                                             
    INNER JOIN ME_MAN                                        
    ON DATATTEND = MANATTEND                                 
    AND MANDISDTE = MANENDDTE                                
    AND MANCANCEL = 0                                        
                                                             
    INNER JOIN PB_PERSON                                     
    ON DATCHTNUM = PERCHTNUM                                 
                                                             
 WHERE DATPAYGUB IN ('A','B','C','F','G')          
 AND DATCANCEL = 0                                           
 AND DATODRDTE BETWEEN '{DATE_FROM}' and '{DATE_TO}'

 ORDER BY DATODRDTE, DATOUTNUM                    