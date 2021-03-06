;----------------------------------------------------------------------
; WRF_xy_1.ncl
;
; Concepts illustrated:
;   - Plotting WRF data
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"

begin
;---Open file; substitute your own WRF output file here
  f = addfile ("wrfout_d02_2019-09-22_18:00:00","r")

;
; Read character variable Times 
; Convert to units of "hours since" for plotting purposes
;
  times = f->Times
  Time   = wrf_times_c(f->Times, 0)  ; convert to "hours since"
  print(Time)

;
; Import time series of perturbation geopotential (PH)
; at a (arbitrarily) specified grid point
;
  y     = f->T2(:,1,1)           ; (Time, bottom_top, south_north, west_east)
  print(y)
;---Subtract the initial value to create anomalies
  yAnom             = y-y(0)             ; anomalies from init time
  yAnom@description = "Anomalies from initial Time" 
  yAnom@units       = y@units
  print(yAnom)
;---For plot label, read the lat/lon location     
  lat   = f->XLAT(1,1,1)
  lon   = f->XLONG(1,1,1)
  print(lat)
;---Create three plots with slight variations.  
  wks = gsn_open_wks("png","WRF_xy_temp")

  res                       = True            ; plot mods desired
  res@gsnMaximize           = True            ; maximize plot size
  res@tiMainString          = lat+"N  "+fabs(lon)+"W"
 
  plot                      = gsn_csm_xy(wks,Time,y,res)

  res@tiXAxisString         = Time@units      ; label bottom axis with units
  res@xyLineThicknessF      = 3.0             ; make a bit thicker           
  res@gsnYRefLine           = 0.0             ; draw a reference line
  plot                      = gsn_csm_xy(wks,Time,yAnom,res)

  res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  plot                      = gsn_csm_xy(wks,Time,yAnom,res)
end
