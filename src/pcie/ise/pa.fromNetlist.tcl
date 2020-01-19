
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name ise -dir "F:/pcie_pro/dvb_ott_pcie_hardwarepcb_newpcie/HKADS-13-05B-IP-0208_taixin/ise/planAhead_run_1" -part xc7k325tffg900-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "F:/pcie_pro/dvb_ott_pcie_hardwarepcb_newpcie/HKADS-13-05B-IP-0208_taixin/ise/pcie_dma_ep_top_cs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {F:/pcie_pro/dvb_ott_pcie_hardwarepcb_newpcie/HKADS-13-05B-IP-0208_taixin/ise} {../modify} }
set_property target_constrs_file "pcie_dma_ep_top.ucf" [current_fileset -constrset]
add_files [list {pcie_dma_ep_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
