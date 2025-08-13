import React, { useEffect, useState } from "react";
import { Map, Source, Layer } from "@vis.gl/react-maplibre";
import "maplibre-gl/dist/maplibre-gl.css";

export default function EarthquakeMap() {
  const [data, setData] = useState([]);
  const [error, setError] = useState(null);

  // Fetch earthquake data from your API Gateway
  useEffect(() => {
    const fetchData = async () => {
      try {
        console.log("Fetching earthquake data...");
        const res = await fetch("https://a5ktzi32re.execute-api.us-east-1.amazonaws.com/Prod/datasets/earthquakes");
        if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
        const json = await res.json();
        console.log("Fetched data:", json);

        // Convert to GeoJSON features
        const features = json.map((point) => ({
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [point.lon, point.lat],
          },
          properties: {
            magnitude: point.value,
          },
        }));

        setData({
          type: "FeatureCollection",
          features,
        });
      } catch (err) {
        console.error("Error fetching data:", err);
        setError(err.message);
      }
    };

    fetchData();
  }, []);

  if (error) return <div>Error: {error}</div>;

  // Circle layer style
  const circleLayer = {
    id: "earthquake-circles",
    type: "circle",
    paint: {
      "circle-radius": [
        "interpolate",
        ["linear"],
        ["get", "magnitude"],
        0, 2,       // magnitude 0 -> radius 2
        1, 4,       // magnitude 1 -> radius 4
        2, 6,
        3, 8,
        4, 10,
        5, 12,
        6, 14,
        7, 16,
        8, 18,
        9, 20
      ],
      "circle-color": "#FF5722",
      "circle-opacity": 0.6,
      "circle-stroke-color": "#B71C1C",
      "circle-stroke-width": 1,
    },
  };

  console.log(data)

  return (
    <div style={{ width: "100vw", height: "100vh" }}>
    <Map
      initialViewState={{
        longitude: -122.744667053223,
        latitude: 38.7868347167969,
        zoom: 3,
      }}
      style={{ width: "100%", height: "100vh" }}
      mapStyle="https://basemaps.cartocdn.com/gl/positron-gl-style/style.json"
    >
      {data.features && (
        <Source id="earthquakes" type="geojson" data={data}>
          <Layer {...circleLayer} />
        </Source>
      )}
    </Map>
    </div>
  );
}
