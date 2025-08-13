import { useEffect, useState } from "react";
import { Map as MapLibre, Source, Layer } from "react-map-gl/maplibre";

const API_URL = "https://a5ktzi32re.execute-api.us-east-1.amazonaws.com/Prod/datasets/earthquakes";

export default function Map() {
  const [geoData, setGeoData] = useState(null);

  useEffect(() => {
    fetch(API_URL)
      .then((res) => res.json())
      .then((data) => {
        // Convert API data to GeoJSON
        const geojson = {
          type: "FeatureCollection",
          features: data.map((d) => ({
            type: "Feature",
            geometry: { type: "Point", coordinates: [d.lon, d.lat] },
            properties: { value: d.value },
          })),
        };
        setGeoData(geojson);
      })
      .catch((err) => console.error("Failed to load earthquake data", err));
  }, []);

  // Circle layer for earthquake points
  const circleLayer = {
    id: "earthquake-circles",
    type: "circle",
    paint: {
      "circle-radius": [
        "interpolate",
        ["linear"],
        ["get", "value"],
        0, 2,
        1, 4,
        3, 8,
        5, 16,
        7, 24,
      ],
      "circle-color": "#e63946",
      "circle-opacity": 0.7,
    },
  };

  return (
    <MapLibre
      initialViewState={{
        longitude: -122.744667053223,
        latitude: 38.7868347167969,
        zoom: 5,
      }}
      style={{ width: "100%", height: "100vh" }}
      mapStyle="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json"
    >
      {geoData && (
        <Source type="geojson" data={geoData}>
          <Layer {...circleLayer} />
        </Source>
      )}
    </MapLibre>
  );
}
