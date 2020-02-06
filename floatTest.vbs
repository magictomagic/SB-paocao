
dim event_name
event_name=Request.Form("event_name")
select case event_name
case "click"
call click()
end select