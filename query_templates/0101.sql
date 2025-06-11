 
select * from                              
(                                          
    -- 재원 (집계 종료일 기준 병실 점유자 - 집계 종료일 퇴원자 포함 
    select count(*) as IpThis from ME_MAN ,PB_GAMOKVIEW 
    where MANCANCEL = 0                    
    and MANADMFOR = 'A' and GMOCANCEL = 0
    and MANDISDTE = MANENDDTE              
    and MANDEPCOD = GMODEPCOD              
    and MANMLTCON = ''                   
  and ((GMOENDDTE = '9999-99-99') or (GMOENDDTE = '9999-12-31')) 

    and ManComDte <= '{DATE_TO}' 
    and ('{DATE_TO}' <= ManDisDte or ManDisDte = ''  ) )T1 , 
(                                          
    -- 퇴원                                
    select count(*) as IpOut from ME_MAN ,PB_GAMOKVIEW  
    where MANCANCEL = 0                    
    and MANADMFOR = 'A' and GMOCANCEL = 0
    and MANDISDTE = MANENDDTE              
    and MANDEPCOD = GMODEPCOD              
    and MANDISGUB = 'T'                  
    and MANMLTCON = ''                   
  and ((GMOENDDTE = '9999-99-99') or (GMOENDDTE = '9999-12-31')) 

    and MANDISDTE+MANDISTIM between '{DATETIME_FROM}' and '{DATETIME_TO}' ) T2, 
(                                           
    -- 입원                                 
    select count(*) as IpIn from ME_MAN ,PB_GAMOKVIEW    
    where MANCANCEL = 0                     
    and MANADMFOR = 'A' and GMOCANCEL = 0 
    and MANDISDTE = MANENDDTE               
    and MANDEPCOD = GMODEPCOD               
    and MANMLTCON = ''                   
  and ((GMOENDDTE = '9999-99-99') or (GMOENDDTE = '9999-12-31')) 

    and MANCOMDTE+MANADMTIM between '{DATETIME_FROM}' and '{DATETIME_TO}') T3,  
(                                           
    --외래                                  
    select count(*) as WpCnt from ME_MAN ,PB_GAMOKVIEW   
    where MANCANCEL = 0                     
    and MANADMFOR = 'F' and GMOCANCEL = 0 
  and ((GMOENDDTE = '9999-99-99') or (GMOENDDTE = '9999-12-31')) 
    and MANDEPCOD = GMODEPCOD               

    and MANCOMDTE+MANJUBTIM between '{DATETIME_FROM}' and '{DATETIME_TO}') T4, 
(                                          
    -- 현 입원자 (집계 종료일 기준 입원하고 있는 환자 - 집계 종료일 퇴원자 미 포함 
    select count(*) as IpReal from ME_MAN ,PB_GAMOKVIEW 
    where MANCANCEL = 0                    
    and MANADMFOR = 'A' and GMOCANCEL = 0
    and MANDISDTE = MANENDDTE              
    and MANDEPCOD = GMODEPCOD              
    and MANMLTCON = ''                   
  and ((GMOENDDTE = '9999-99-99') or (GMOENDDTE = '9999-12-31')) 

    and ManDisDte <> '{DATE_TO}' 
    and ManComDte <= '{DATE_TO}' 
    and ('{DATE_TO}' <= ManDisDte or ManDisDte = ''  ) )T5  

select isnull(MEYAOFGUB,'T') as MEYAOFGUB,                                                            
       sum(CONVERT(BIGINT,MEYTOTCHOAMT) ) as MEYTCHOAMT, --총진료비                                                      
       sum(CONVERT(BIGINT,MEYCHUAMT) ) as MEYCHUAMT ,  --   급여청구액                                                   
       sum(CONVERT(BIGINT,MEYBONAMT) ) as MEYBONAMT ,  -- 	급여본인부담금                                               
       sum(CONVERT(BIGINT,MEYBIGAMT) ) as MEYBIGAMT ,  -- 	비급여액                                                     
       sum(CONVERT(BIGINT,MEYSUNAMT) ) as MEYSUNAMT ,  -- 	수납액                                                       
                                                                                                        
       (sum(CONVERT(BIGINT,GiWonBi) 	 ) + sum(CONVERT(BIGINT,sanjun_GP) )) as GiWonBi	,  --   국책지원금                                 
                                                                                                        
       sum(CONVERT(BIGINT,SubTot) 	 ) as SubTot	,  --   차감금 총액                                                    
       sum(CONVERT(BIGINT,Halin_DC)  ) as Halin_DC  ,  -- 	할인액                                                       
       sum(CONVERT(BIGINT,Misu2_MB)  ) as Misu2_MB  ,  -- 	미수발생액                                                   
                                                                                                        
       sum(CONVERT(BIGINT,MisuIn_MH) )+sum(CONVERT(BIGINT,Bojung_B)  )+sum(CONVERT(BIGINT,A_Midd_M)  )+sum(CONVERT(BIGINT,F_Midd_M)  ) +                                    
       sum(CONVERT(BIGINT,GaToiw_G)  ) AS NotJinRyo, --진료외수입                                                        
       sum(CONVERT(BIGINT,MisuIn_MH) ) as MisuIn_MH ,  -- 	미수입금                                                     
       sum(CONVERT(BIGINT,Bojung_B)  ) as Bojung_B  ,  -- 	보증금                                                       
       sum(CONVERT(BIGINT,A_Midd_M)  )+sum(CONVERT(BIGINT,F_Midd_M)  ) as Midd_M  ,  -- 	중간입금                                         
       sum(CONVERT(BIGINT,GaToiw_G)  ) as GaToiw_G  ,  -- 	가퇴원금                                                     
                                                                                                        
       sum(CONVERT(BIGINT,MEYSUNAMT) )+sum(CONVERT(BIGINT,MisuIn_MH) )+sum(CONVERT(BIGINT,Bojung_B)  )+sum(CONVERT(BIGINT,A_Midd_M)  )   +                                  
       sum(CONVERT(BIGINT,F_Midd_M)  )+sum(CONVERT(BIGINT,GaToiw_G)  )-sum(CONVERT(BIGINT,SubTot)    )-sum(CONVERT(BIGINT,SunCha)    ) - sum(CONVERT(BIGINT,GiWonBi) ) -  sum(CONVERT(BIGINT,sanjun_GP) ) as InAmt,  --입금합계 
       sum(CONVERT(BIGINT,MEYSUNAMT) ) as MEYSUNAMT ,  -- 	수납액                                                       
       sum(CONVERT(BIGINT,MisuIn_MH) )+sum(CONVERT(BIGINT,Bojung_B)  )+sum(CONVERT(BIGINT,A_Midd_M)  )+sum(CONVERT(BIGINT,F_Midd_M)  ) +                                    
       sum(CONVERT(BIGINT,GaToiw_G)  ) as SumNotJin, --진료외수입                                                        
       sum(CONVERT(BIGINT,SubTot) 	 ) as SumSubTot	,  --   손실금 총액                                                  
       sum(CONVERT(BIGINT,SunCha) 	 ) as SunCha	,  --   기 선입금                                                      
                                                                                                        
       sum(CONVERT(BIGINT,MEYYUNAMT) ) as MEYYUNAMT ,  -- 	영수액                                                       
       sum(CONVERT(BIGINT,Cash_S) 	 ) as Cash_S	,  --   현금입금                                                       
       (sum(CONVERT(BIGINT,Card_C) 	 ) + sum(CONVERT(BIGINT,Mam_C) )) as Card_C	,  --   카드영수                                                       
       sum(CONVERT(BIGINT,Bank_B) 	 ) as Bank_B	,  --   은행입금                                                       
       sum(CONVERT(BIGINT,Cash_S+Card_C+Bank_B+Mam_C)  ) as InMoney  --   영수액                                               
  FROM ME_YUNGSUVIEW                                                                                    
 INNER JOIN PB_GAMOKVIEW                                                                                
    ON MEYDEPCOD = GMODEPCOD                                                                            
  	AND MEYRCTDTE BETWEEN GMOSTRDTE AND GMOENDDTE                                                        
  	AND GMOCANCEL = 0                                                                                    
                                                                                                        
where MEYINSDTM BETWEEN '{DATETIME_FROM}' and '{DATETIME_TO}' 

GROUP BY MEYAOFGUB with ROLLUP                                                                          
Order BY MEYAOFGUB