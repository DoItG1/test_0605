--외래 초진환자수                                                               
select Count(ManAttend) as ManCount , PcmCValue, ManInsCod, 'WpChoCnt' as Gubun    
from me_Man                                                                          
	Inner join PB_CodeMap                                                             
	on ManInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on ManDepCod = GmoDepCod                                                          
	and ManComDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where ManCancel = 0 and ManAdmFor = 'F'                                            
and ManJinGub in ('10','11','15') -- 초진만                                 
and ManEndDte = ManDisDte                                                            
and ManInsCod <> 'G'                                                               
and ManComDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, ManInsCod                                                        
Union all                                                                            
-- 외래 연환자수(총방문횟수)                                              
select Count(ManAttend) as ManCount , PcmCValue, ManInsCod, 'WpYunCnt' as Gubun    
from me_Man                                                                          
	Inner join PB_CodeMap                                                             
	on ManInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on ManDepCod = GmoDepCod                                                          
	and ManComDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where ManCancel = 0 and ManAdmFor = 'F'                                            
and ManEndDte = ManDisDte                                                            
and ManInsCod <> 'G'                                                               
and ManComDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, ManInsCod                                                        
Union all                                                                            
-- 입원 실환자수(DRG포함)                                                    
select Count(ManAttend) as ManCount, PcmCValue, ManInsCod, 'IpManCnt' as Gubun     
from me_Man                                                                          
	Inner join PB_CodeMap                                                             
	on ManInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on ManDepCod = GmoDepCod                                                          
	and ManComDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where ManCancel = 0 and ManAdmFor = 'A'                                            
and ManEndDte = ManDisDte                                                            
and ManInsCod <> 'G'                                                               
and ManComDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, ManInsCod                                                        
Union all                                                                            
--입원연환자수(총재원일수)                                                
select                                                                               
Sum(cast( Cast(case when Len(ManDisDte) < 10 then '2025-02-28' else ManDisDte end as DateTime) - cast(ManComDte as DateTime) as Int)) as ManCount 
, PcmCValue, ManInsCod, 'IpYunCnt' as Gubun                                        
from me_Man                                                                          
	Inner join PB_CodeMap                                                             
	on ManInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on ManDepCod = GmoDepCod                                                          
	and ManComDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where ManCancel = 0 and ManAdmFor = 'A'                                            
and ManEndDte = ManDisDte                                                            
and ManInsCod <> 'G'                                                               
and ManComDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, ManInsCod                                                        
Union all                                                                            
select                                                                               
--DRG(연환자수)                                                                  
Sum(cast( Cast(case when Len(ManDisDte) < 10 then '2025-02-28' else ManDisDte end as DateTime) - cast(ManComDte as DateTime) as Int)) as ManCount 
, PcmCValue, ManInsCod, 'IpDrgCnt' as Gubun                                        
from me_Man                                                                          
	Inner join PB_CodeMap                                                             
	on ManInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on ManDepCod = GmoDepCod                                                          
	and ManComDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where ManCancel = 0 and ManAdmFor = 'A'                                            
and ManDrgGub = 'D'                                                                
and ManEndDte = ManDisDte                                                            
and ManInsCod <> 'G'                                                               
and ManComDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, ManInsCod                                                        
Union all                                                                            
-- 외래수익                                                                      
select Sum(MeyChoAmt) as ManCount ,                                             
PcmCValue, MeyInsCod, 'WpSumAmt' as Gubun                                          
from me_YungsuView                                                                   
	Inner join PB_CodeMap                                                             
	on MeyInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on MeyDepCod = GmoDepCod                                                          
	and MeyRctDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where MeyCancel = 0 and MeyAofGub = 'F'                                            
and MeyInsCod <> 'G'                                                               
and MeyRctDte between '{DATE_FROM}' and '{DATE_TO}'                              
group by PcmCValue, MeyInsCod                                                        
Union all                                                                            
-- 입원수익                                                                      
select Sum(MeyChoAmt) as ManCount ,                                             
PcmCValue, MeyInsCod, 'IpSumAmt' as Gubun                                          
from me_YungsuView                                                                   
	Inner join PB_CodeMap                                                             
	on MeyInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on MeyDepCod = GmoDepCod                                                          
	and MeyRctDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

where MeyCancel = 0 and MeyAofGub = 'A'                                            
and MeyInsCod <> 'G'                                                               
and MeyRctDte between '{DATE_FROM}' and '{DATE_TO}'
group by PcmCValue, MeyInsCod                                                        
Union all                                                                            
-- DRG수익                                                                         
select Sum(MeyChoAmt) as ManCount ,                                             
PcmCValue, MeyInsCod, 'IpDrgAmt' as Gubun                                          
from me_YungsuView                                                                   
	Inner join PB_CodeMap                                                             
	on MeyInsCod = PcmMGroup and PCMLGroup = 'YUHYUNG' and PcmCGubun = '00'       
	Inner join Pb_GamokView                                                           
	on MeyDepCod = GmoDepCod                                                          
	and MeyRctDte between GmoStrDte and GmoEndDte                                     
	and GmoCancel = 0                                                                 

                                                                                     
	Inner join Me_Man                                                                 
	On MeyAttend = ManAttend                                                          
	and ManCancel = 0                                                                 
	and ManDrgGub = 'D'                                                             
where MeyCancel = 0 and MeyAofGub = 'A'                                            
and ManEndDte = ManDisDte                                                            
and MeyInsCod <> 'G'                                                               
and MeyRctDte between '{DATE_FROM}' and '{DATE_TO}'
group by PcmCValue, MeyInsCod                                                        
                                                                                     
order by ManInsCod                                                                   
