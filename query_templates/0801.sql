  SELECT MANCOMDTE as SetMonth,                                            
  count(MANATTEND) SumCnt , MAge, PERSEXTYP                                
  from (                                                                   
      SELECT MANATTEND, SUBSTRING(MANCOMDTE,6,2) as MANCOMDTE,             
 	 case SUBSTRING(PERRESNUM,8,1) WHEN '1' THEN 'M'                    
 		 WHEN '3' THEN 'M' ELSE 'F' END AS PERSEXTYP,                 
 	PERRESNUM,PERBIRDTE,                                                    
     datediff(yy,                                                          
              REPLACE(PERBIRDTE,'-',''),                               
              convert(char(8),CAST(MANCOMDTE AS DATETIME),112)) AS  age,   
     datediff(MM,                                                          
              REPLACE(PERBIRDTE,'-',''),                               
              convert(char(8),CAST(MANCOMDTE AS DATETIME),112)) AS  MAge   
      FROM ME_MAN                                                          
                                                                           
         INNER JOIN PB_PERSON                                              
         ON MANCHTNUM = PERCHTNUM                                          
                                                                           
         inner join PB_GAMOKVIEW                                           
         ON MANDEPCOD = GMODEPCOD AND GMOCANCEL = 0                        
         AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE                     
                                                                           
      WHERE MANCANCEL = 0
      AND MANDISDTE = MANENDDTE
      and len(PERBIRDTE)=10
      and LEN(mancomdte)=10
      and MANCOMDTE <> '' and MANCOMDTE is not null
      and PERBIRDTE <> '' and PERBIRDTE is not null
      AND MANCOMDTE BETWEEN  '{DATE_FROM}' and '{DATE_TO}'
      and SUBSTRING(PERBIRDTE,6,2) between '01' and '12'            
      and SUBSTRING(PERBIRDTE,9,2) between '01' and '31'            

  ) T1                              
  group by MANCOMDTE,PERSEXTYP,MAge 
  order by MANCOMDTE,PERSEXTYP,MAge 
