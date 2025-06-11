     select PCMCVALUE , New, Cho ,Jee ,Etc ,SumCnt,                                                               
     IpInCnt, IpOutCnt ,                                                                                          
     WpChoAmt    ,IpChoAmt    ,SumChoAmt   ,WpYunAmt,                                                             
     IpYunAmt    ,SumAmt      ,WpMisu2_MB  ,                                                                      
     WpMisuIn_MH ,IpMisu2_MB  ,IpMisuIn_MH ,                                                                      
     SumMisuIn_MH                                                                                                 
     from PB_CODEMAP                                                                                              
         Left outer join                                                                                          
         (                                                                                                        
             select ManInsCod,                                                                                    
             sum(New) as New ,                                                                                    
             sum(Cho) as Cho ,                                                                                    
             sum(Jee) as Jee ,                                                                                    
             sum(Etc) as Etc ,                                                                                    
             sum(Cho+Jee+Etc) as SumCnt                                                                           
             from                                                                                                 
             (                                                                                                    
                 select ManInsCod,                                                                                
                 case when PerNewDte is null then 0 else 1 end as New ,                                           
                 case when ManJinGub in ( -- 초진  2012.11.23 현재                                                
                                         '10','17','1T','1U','18',                                      
                                         '1V','1W','12','1P','1Q',                                      
                                         '16','1R','1S','15','11'                                       
                                         ) then 1 else 0 end as Cho,                                              
                 case when ManJinGub in (  -- 재진 2012.11.23 현재                                                
                                         '29','20','23','65','67',                                      
                                         '6T','6U','68','6V','6W',                                      
                                         '61','6P','6Q','62','66',                                      
                                         '6R','6S','60','27','2T',                                      
                                         '2U','28','2V','2W','22',                                      
                                         '2P','2Q','26','2R','2S',                                      
                                         '30','25','21'                                                     
                                        ) then 1 else 0 end as Jee,                                               
                 case when ManJinGub in ('00','2A',                                                           
                                         '31','32','33','34','35',                                      
                                         '36','37','38','39','3H',                                      
                                         '3A','3B','3G','3I','3J','3K','3L','3M','3N','3O',   
                                         '3C','3D','3E','3F',                                             
                                         '3M','3N'                                                            
                                         ) then 1 else 0 end as Etc  -- 기타 2012.11.23 현재                      
                 from ME_Man                                                                                      
  					left outer join PB_PERSON  --신환 환자 찾기                                                   
  					on ManChtNum = PerChtNum                                                                      
 					and MANCOMDTE = PERNEWDTE                                                                      
  					and PerNewDte between '{DATE_FROM}' and '{DATE_TO}'             
                    Inner join PB_GAMOKLAST                                                                       
                    on MANDEPCOD = GMODEPCOD                                                                      
                    and GMOCANCEL = 0                                                                             

                                                                                                                  
                 where ManCancel = 0                                                                              
                 and ManEndDte = ManDisDte                                                                        
               and((ManComDte > '{DATE_FROM}' and  ManComDte <  '{DATE_TO}' )       
               or ((ManComDte = '{DATE_FROM}' and  MANJUBTIM >= '{TIME_FROM}'  )      
      OR (ManComDte =  '{DATE_TO}' and  MANJUBTIM <= '{TIME_TO}'  )))    
             ) aaa                                                                                                
             group by ManInsCod                                                                                   
         ) WpMan                                                                                                  
         on PCMMGROUP =  WpMan.ManInsCod                                                                          
                                                                                                                  
         Left outer join                                                                                          
         (                                                                                                        
             select ManInsCod, count(ManChtNum) As IpInCnt                                                        
             from ME_Man                                                                                          
                    Inner join PB_GAMOKLAST                                                                       
                    on MANDEPCOD = GMODEPCOD                                                                      
                    and GMOCANCEL = 0                                                                             

             where ManCancel = 0                                                                                  
             and ManEndDte = ManDisDte                                                                            
             and ManAdmFor = 'A'                                                                                
               and((ManComDte > '{DATE_FROM}' and  ManComDte <  '{DATE_TO}' )       
               or ((ManComDte = '{DATE_FROM}' and  MANJUBTIM >= '{TIME_FROM}'  )      
      OR (ManComDte =  '{DATE_TO}' and  MANJUBTIM <= '{TIME_TO}'  )))    
             group by ManInsCod                                                                                   
         ) IpIn                                                                                                   
         on PCMMGROUP =  IpIn.ManInsCod                                                                           
                                                                                                                  
         Left outer join                                                                                          
         (                                                                                                        
             select ManInsCod, count(ManChtNum) as IpOutCnt                                                       
             from ME_Man                                                                                          
                    Inner join PB_GAMOKLAST                                                                       
                    on MANDEPCOD = GMODEPCOD                                                                      
                    and GMOCANCEL = 0                                                                             

             where ManCancel = 0                                                                                  
             and ManEndDte = ManDisDte                                                                            
             and ManAdmFor = 'A'                                                                                
               and((ManDisDte > '{DATE_FROM}' and  ManDisDte <  '{DATE_TO}' )       
               or ((ManDisDte = '{DATE_FROM}' and  MANDISTIM >= '{TIME_FROM}'  )      
      OR (ManDisDte =  '{DATE_TO}' and  MANDISTIM <= '{TIME_TO}'  )))    
             group by ManInsCod                                                                                   
         ) IpOut                                                                                                  
         on PCMMGROUP =  IpOut.ManInsCod                                                                          
                                                                                                                  
         Left outer join                                                                                          
         (                                                                                                        
             select MeyInsCod,                                                                                    
             Sum(WpChoAmt    ) as WpChoAmt    ,                                                                   
             Sum(IpChoAmt    ) as IpChoAmt    ,                                                                   
             Sum(SumChoAmt      ) as SumChoAmt,                                                                   
             Sum(WpYunAmt    ) as WpYunAmt    ,                                                                   
             Sum(IpYunAmt    ) as IpYunAmt    ,                                                                   
             Sum(SumAmt      ) as SumAmt      ,                                                                   
             Sum(WpMisu2_MB  ) as WpMisu2_MB  ,                                                                   
             Sum(WpMisuIn_MH ) as WpMisuIn_MH ,                                                                   
             Sum(IpMisu2_MB  ) as IpMisu2_MB  ,                                                                   
             Sum(IpMisuIn_MH ) as IpMisuIn_MH ,                                                                   
             Sum(SumMisuIn_MH) as SumMisuIn_MH                                                                    
             from                                                                                                 
             (                                                                                                    
                 select MeyInsCod,                                                                                
                 Sum(case when MeyAofGub = 'F' then MeyChoAmt+MEYBIGAMT else 0 end) as WpChoAmt,                
                 Sum(case when MeyAofGub = 'A' then MeyChoAmt+MEYBIGAMT else 0 end) as IpChoAmt,                
                 Sum(MeyChoAmt+MEYBIGAMT) as SumChoAmt,                                                           
                 Sum(case when MeyAofGub = 'F' then MeyYunAmt else 0 end) as WpYunAmt,                          
                 Sum(case when MeyAofGub = 'A' then MeyYunAmt else 0 end) as IpYunAmt,                          
                 Sum(MeyYunAmt) as SumAmt,                                                                        
                 Sum(case when MeyAofGub = 'F' then Misu2_MB  else 0 end) as WpMisu2_MB,                        
                 Sum(case when MeyAofGub = 'F' then MisuIn_MH else 0 end) as WpMisuIn_MH,                       
                 Sum(case when MeyAofGub = 'A' then Misu2_MB  else 0 end) as IpMisu2_MB,                        
                 Sum(case when MeyAofGub = 'A' then MisuIn_MH else 0 end) as IpMisuIn_MH,                       
                 Sum(MisuIn_MH) as SumMisuIn_MH                                                                   
                 from ME_YungsuView                                                                               
                    Inner join PB_GAMOKLAST                                                                       
                    on MEYDEPCOD = GMODEPCOD                                                                      
                    and GMOCANCEL = 0                                                                             

                 where MeyCancel = 0                                                                              
                 and MEYINSDTM between '{DATETIME_FROM}' and '{DATETIME_TO}'
                 group by MeyInsCod                                                                               
             ) as Yungsu1                                                                                         
             group by MeyInsCod                                                                                   
         ) Yungsu                                                                                                 
         on PCMMGROUP =  MeyInsCod                                                                                
 where PCMLGROUP = 'YUHYUNG'                                                                                    
 AND PCMCGUBUN = '00'                                                                                           
 Order by PCMCVALUE                                                                                               