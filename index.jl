using HTTP, JSON, DSP

new_cases_response = HTTP.get("https://services6.arcgis.com/rNuo8nvF17v2dPFX/arcgis/rest/services/COVID19_DashboardData/FeatureServer/0/query?f=json&where=Name%3D%27Calaveras%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=ObjectId%2CNew_Cases%2CDate_Reported%2CName&orderByFields=Date_Reported%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true")

parsed = JSON.parse(new_cases_response.body |> String)

open("cases.json", "w") do f
  JSON.print(f, parsed)
end

dates = map(x -> x["attributes"]["Date_Reported"], parsed["features"])
cases = map(x -> x["attributes"]["New_Cases"], parsed["features"])

data = [cases dates]
