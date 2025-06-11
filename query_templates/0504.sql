 select                                                              
 case when (MANADMFOR = 'A' and DatPayGub >  '9' )THEN '입원 원외' 
 	  when (MANADMFOR = 'A' and DatPayGub <= '9' )THEN '입원 원내' 
 	  when (MANADMFOR = 'F' and DatPayGub >  '9' )THEN '외래 원외' 
 	  when (MANADMFOR = 'F' and DatPayGub <= '9' )THEN '외래 원내' 
 ELSE '기타' END AS AdmFor,                                     
 case when PDOMAYGUB = 'H' then '향정'                        
      when PDOMAYGUB = 'M' then '마약'                        
 ELSE '기타' END AS MayGub,                                     
 '0' as DatCancel, PDOODRCOD, PDOKORNAM,                                   
 sum(CAST(DATTOTQTY AS FLOAT)*CAST(DATODRDAY AS FLOAT)) AS UseCnt   
 FROM ME_DAT with (index = ix_ME_Dat_Stats)                 
                                                                    
    inner JOIN PB_DoView                                            
    ON DATODRCOD = PDOODRCOD                                        
    AND PDOCANCEL = 0                                               
    and PDOMAYGUB IN ('H','M')                            
                                                                    
    INNER join PB_GAMOKVIEW                                         
    ON DATDEPCOD = GMODEPCOD                                        
    AND DATODRDTE BETWEEN GMOSTRDTE AND GMOENDDTE                   
    AND GMOCANCEL = 0                                               
                                                                    
    INNER JOIN ME_MAN                                               
    ON DATATTEND = MANATTEND                                        
    AND MANDISDTE = MANENDDTE                                       
    AND MANCANCEL = 0                                               
                                                                    
 where DATYANHAN = 'Y'                                            
 and DatIiiGub = '1'                                              
 and DatCodGub = '3'                                              
 and DATENDDEP > '0'                                              
 AND DATODRDTE BETWEEN '{DATE_FROM}' and '{DATE_TO}'         
 AND ISNUMERIC(DATTOTQTY) = 1                                       
 AND ISNUMERIC(DATODRDAY) = 1                                        

                                                                        
 group by ManAdmFor, PDOMAYGUB, PDOODRCOD, PDOKORNAM,DatPayGub            
                                                                        
 union all                                                             
 select                                                              
 case when (MANADMFOR = 'A' and DatPayGub >  '9' )THEN '입원 원외' 
 	  when (MANADMFOR = 'A' and DatPayGub <= '9' )THEN '입원 원내' 
 	  when (MANADMFOR = 'F' and DatPayGub >  '9' )THEN '외래 원외' 
 	  when (MANADMFOR = 'F' and DatPayGub <= '9' )THEN '외래 원내' 
 ELSE '기타' END AS AdmFor,                                     
 case when PDOMAYGUB = 'H' then '향정'                        
      when PDOMAYGUB = 'M' then '마약'                        
 ELSE '기타' END AS MayGub,                                     
 '1' as DatCancel, PDOODRCOD, PDOKORNAM,                                   
 sum(CAST(DATTOTQTY AS FLOAT)*CAST(DATODRDAY AS FLOAT)) AS UseCnt   
 FROM ME_DAT with (index = ix_ME_Dat_Stats)                 
                                                                    
    inner JOIN PB_DoView                                            
    ON DATODRCOD = PDOODRCOD                                        
    AND PDOCANCEL = 0                                               
    and PDOMAYGUB IN ('H','M')                            
                                                                    
    INNER join PB_GAMOKVIEW                                         
    ON DATDEPCOD = GMODEPCOD                                        
    AND DATODRDTE BETWEEN GMOSTRDTE AND GMOENDDTE                   
    AND GMOCANCEL = 0                                               
                                                                    
    INNER JOIN ME_MAN                                               
    ON DATATTEND = MANATTEND                                        
    AND MANDISDTE = MANENDDTE                                       
    AND MANCANCEL = 0                                               
                                                                    
 where DATYANHAN = 'Y'                                            
 and DatIiiGub = '1'                                              
 and DatCodGub = '3'                                              
 AND DATCANCEL = 1                                               
 and DATENDDEP > '0'                                              
 AND DATODRDTE BETWEEN '{DATE_FROM}' and '{DATE_TO}'      
 AND ISNUMERIC(DATTOTQTY) = 1                                       
 AND ISNUMERIC(DATODRDAY) = 1                                       

                                                                        
 group by ManAdmFor, PDOMAYGUB, PDOODRCOD, PDOKORNAM,DatPayGub            
                                                                        
 order by PDOKORNAM,PDOODRCOD,DatCancel                                 