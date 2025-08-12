def transform_earthquakes(res):
    return [
        {
            "lon": f["geometry"]["coordinates"][0],
            "lat": f["geometry"]["coordinates"][1],
            "value": f["properties"]["mag"],
        }
        for f in res.get("features", [])
    ]

TRANSFORMS = {
    "earthquakes": transform_earthquakes,
    # other transforms...
}
