 select ManChtNum,ManPatNam,GMODEPNAM,PCMCVALUE,ManComDte, ManDisDte, ManAdmFor,      
 sum(GubAmt+BigAmt) as DatTotAmt, sum(GubAmt) as GubAmt, sum(BigAmt) as BigAmt,       
 sum(MEYTOTCHOAMT) as MEYTOTCHOAMT ,sum(MEYCHOAMT   ) as MEYCHOAMT    ,               
 sum(MEYCHUAMT   ) as MEYCHUAMT    ,sum(MEYBONAMT   ) as MEYBONAMT    ,               
 sum(MEYBONORG   ) as MEYBONORG    ,sum(MEYBIGAMT   ) as MEYBIGAMT    ,               
 sum(MEYJANAMT   ) as MEYJANAMT    ,sum(CashYe      ) as CashYe       ,               
 sum(CashNo      ) as CashNo       ,sum(MEYSUNAMT   ) as MEYSUNAMT    ,               
 sum(MEYPREAMT   ) as MEYPREAMT    ,sum(MEYYUNAMT   ) as MEYYUNAMT    ,               
 sum(MEYMIDAMT   ) as MEYMIDAMT    ,sum(Gigan_T     ) as Gigan_T      ,               
 sum(Bojung_B    ) as Bojung_B     ,sum(GaToiw_G    ) as GaToiw_G     ,               
 sum(MisuIn_MH   ) as MisuIn_MH    ,sum(MEYUSEAMT   ) as MEYUSEAMT    ,               
 sum(SubTot      ) as SubTot       ,sum(Misu2_MB    ) as Misu2_MB     ,               
 sum(Halin_DC    ) as Halin_DC     ,sum(GiWonBi     ) as GiWonBi      ,               
 sum(GunSan_GG   ) as GunSan_GG    ,sum(SangHa_GL   ) as SangHa_GL    ,               
 sum(SanJun_GP   ) as SanJun_GP    ,sum(Bohun_GB    ) as Bohun_GB     ,               
 sum(Witak_GW    ) as Witak_GW     ,sum(Jange_GJ    ) as Jange_GJ     ,               
 sum(Hegui_GH    ) as Hegui_GH     ,sum(Card_C      ) as Card_C       ,               
 sum(Bank_B      ) as Bank_B       ,sum(Cash_S      ) as Cash_S       ,               
 sum(SunIm       ) as SunIm        ,sum(SunCha      ) as SunCha       ,               
 sum(ChaGam      ) as ChaGam       ,sum(Middile_M) AS Middile_M                       
 from me_Man                                                                          
   Left outer join                                                                            
   (	select DatAttend,                                                                     
   	    sum(cast(DatTotAmt as int)) as DatTotAmt,                                             
   	    sum(case                                                       
   	             when DatPayGub =  '1' and                           
   	                (                                                  
   	                	DatLagCod = '14' or                          
   	                   (DatLagCod = '02' and DatMidCod = '10') or  
   	                   (DatLagCod = '02' and DatMidCod = '10') or  
   	                   (DatLagCod = '02' and DatMidCod = '10') or  
   	                   (DatLagCod = '02' and DatMidCod = '07') or  
   	                    DAtOdrCod = 'Y1111'                      or  
   	                    DAtOdrCod = 'AB001'                      or  
   	                    DAtOdrCod = 'AB002'                          
   	                )                                                  
   	             and cast(Cast( (case when ManDisDte = '' then '{DATE_TO}' else ManDisDte end) as DateTime) - cast(ManComDte as DateTime) as Int)+1 > 6 
   	             then cast(DatTotAmt as int)                           
                                                                       
   	             when DatPayGub =  '1'                               
   	             and cast(Cast( (case when ManDisDte = '' then '{DATE_TO}' else ManDisDte end) as DateTime) - cast(ManComDte as DateTime) as Int)+1 <= 6 
   	             then cast(DatTotAmt as int)                           
   	        else 0 end) as GubAmt ,                                    
                                                                                      
   	    sum(case when DatPayGub <> '1' then cast(DatTotAmt as int) else 0 end) as BigAmt    
   	    from me_datSimsa                                                                      
            Inner join ME_Man                                                                 
            on DatAttend = ManAttend                                                          
            and ManCancel = 0                                                                 
            and ManEndDte = ManDisDte                                                         
   	    where DatCancel = 0                                                                   
   	    and DatOdrDte between '{DATE_FROM}' and (case when ManAdmFor = 'A' and ManDisGub = 'T' then ManDisDte else '{DATE_TO}' End) 
   	    group by DatAttend                                                                    
   ) TDat                                                                                     
   on ManAttend = DatAttend                                                                   
                                                                                      
   Left outer join                                                                    
   (	select MeyAttend,                                                             
       sum(MEYTOTCHOAMT) as MEYTOTCHOAMT ,sum(MEYCHOAMT   ) as MEYCHOAMT    ,         
       sum(MEYCHUAMT   ) as MEYCHUAMT    ,sum(MEYBONAMT   ) as MEYBONAMT    ,         
       sum(MEYBONORG   ) as MEYBONORG    ,sum(MEYBIGAMT   ) as MEYBIGAMT    ,         
       sum(MEYJANAMT   ) as MEYJANAMT    ,sum(CashYe      ) as CashYe       ,         
       sum(CashNo      ) as CashNo       ,sum(MEYSUNAMT   ) as MEYSUNAMT    ,         
       sum(MEYPREAMT   ) as MEYPREAMT    ,sum(MEYYUNAMT   ) as MEYYUNAMT    ,         
       sum(MEYMIDAMT   ) as MEYMIDAMT    ,sum(Gigan_T     ) as Gigan_T      ,         
       sum(Bojung_B    ) as Bojung_B     ,sum(GaToiw_G    ) as GaToiw_G     ,         
       sum(MisuIn_MH   ) as MisuIn_MH    ,sum(MEYUSEAMT   ) as MEYUSEAMT    ,         
       sum(SubTot      ) as SubTot       ,sum(Misu2_MB    ) as Misu2_MB     ,         
       sum(Halin_DC    ) as Halin_DC     ,sum(GiWonBi     ) as GiWonBi      ,         
       sum(GunSan_GG   ) as GunSan_GG    ,sum(SangHa_GL   ) as SangHa_GL    ,         
       sum(SanJun_GP   ) as SanJun_GP    ,sum(Bohun_GB    ) as Bohun_GB     ,         
       sum(Witak_GW    ) as Witak_GW     ,sum(Jange_GJ    ) as Jange_GJ     ,         
       sum(Hegui_GH    ) as Hegui_GH     ,sum(Card_C      ) as Card_C       ,         
       sum(Bank_B      ) as Bank_B       ,sum(Cash_S      ) as Cash_S       ,         
       sum(SunIm       ) as SunIm        ,sum(SunCha      ) as SunCha       ,         
       sum(ChaGam      ) as ChaGam       ,sum(A_Midd_M+F_Midd_M) AS Middile_M         
   	    from ME_YUNGSUVIEW                                                            
   	   where MeyCancel = 0                                                            
   	   and MEYINSDTM between '{DATETIME_FROM}' and '{DATETIME_TO}' 
   	   group by MeyAttend                                                             
   ) TMey                                                                             
   on ManAttend = MeyAttend                                                           
                                                                                      
  	LEFT OUTER JOIN PB_GAMOKVIEW                                                      
  	ON  ManDepCod = GMODEPCOD AND GMOCANCEL = 0                                       
  	AND ManComDte BETWEEN GMOSTRDTE AND GMOENDDTE                                     
                                                                                      
  	LEFT OUTER JOIN PB_CODEMAP                                                        
  	ON  ManInsCod = PCMMGROUP                                                         
  	AND PCMLGROUP = 'YUHYUNG' and PCMCGUBUN = '00'                                
                                                                                      
 where ManCancel = 0                                                                  
 and ManEndDte = ManDisDte                                                            
 and (                                                                                
      (ManAdmFor = 'A' and (ManDisDte >= '{DATE_FROM}' or ManDisDte = '' ))      
   or (ManAdmFor = 'F' and (ManComDte between '{DATE_FROM}' and '{DATE_TO}' ))  
 )                                                                                    

 --and DatTotAmt is not null                                                          
                                                                                      
 group by ManChtNum,ManPatNam,GMODEPNAM,PCMCVALUE,ManComDte, ManDisDte, ManAdmFor     