using HTTP, JSON, DSP, Plots, PlotThemes, Dates, LinearAlgebra

new_cases_response = HTTP.get("https://services6.arcgis.com/rNuo8nvF17v2dPFX/arcgis/rest/services/COVID19_DashboardData/FeatureServer/0/query?f=json&where=Name%3D%27Calaveras%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=ObjectId%2CNew_Cases%2CDate_Reported%2CName&orderByFields=Date_Reported%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true")

parsed = JSON.parse(new_cases_response.body |> String)

open("cases.json", "w") do f JSON.print(f, parsed)
end

dates = map(x -> x["attributes"]["Date_Reported"] / 1000 |> Dates.unix2datetime, parsed["features"])
cases = map(x -> x["attributes"]["New_Cases"], parsed["features"])

kernel = fill(1/7, 7)
average_cases = conv(kernel, cases)[length(kernel):end]
cumulative_cases = (cases' * UpperTriangular(ones(length(cases), length(cases))))'

theme(:dark)
plot(
  dates,
  [cases average_cases],
  label = ["New Cases" "New Cases (weekly average)"],
  lw = [1 2],
  legend=:topleft,
)

savefig("new_cases.pdf")
