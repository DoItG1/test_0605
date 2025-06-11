 SELECT BYUDISCOD, BYUDISNAM, 
 SUM(IpCnt) AS IpCnt,         
 SUM(WpCnt) AS WpCnt,         
 SUM(IpCnt)+SUM(WpCnt) AS TotCnt 
 FROM(                           
 	SELECT BYUDISCOD, BYUDISNAM,MANADMFOR,  
 	CASE WHEN MANADMFOR = 'A' THEN COUNT(BYUDISCOD) ELSE 0 END AS IpCnt, 
 	CASE WHEN MANADMFOR = 'F' THEN COUNT(BYUDISCOD) ELSE 0 END AS WpCnt  
 	FROM ME_BYUNG                
        
 		INNER JOIN ME_MAN        
 		ON BYUATTEND = MANATTEND 
 		AND MANCANCEL = 0        
     AND MANDISDTE = MANENDDTE                           
        
       inner join PB_GAMOKVIEW                       
       ON BYUDEPCOD = GMODEPCOD                      
       AND MANCOMDTE BETWEEN GMOSTRDTE AND GMOENDDTE 
       AND GMOCANCEL = 0                             
        
 	WHERE BYUCANCEL = 0          

   and MANCOMDTE between '{DATE_FROM}' and '{DATE_TO}'
 	GROUP BY BYUDISCOD, BYUDISNAM, MANADMFOR 
 ) T1                                       
 GROUP BY BYUDISCOD, BYUDISNAM              
 ORDER BY BYUDISCOD, BYUDISNAM                           