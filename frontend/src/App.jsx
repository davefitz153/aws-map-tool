import Map from "./Map";

const PORTFOLIO_URL = "https://github.com/davefitz153/"

export default function App() {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        height: "100vh",
        width: "100vw",
      }}
    >
      <div
        style={{
          height: "75vh",
          width: "85vw",
          display: "flex",
          flexDirection: "column",
        }}
      >
      {/* Navigation Bar */}
      <div
        style={{
          background: "#1a1a1a",
          color: "white",
          padding: "10px 20px",
          fontSize: "1.1rem",
          display: "flex",
          alignItems: "center",
        }}
      >
        <a
          href={PORTFOLIO_URL}
          style={{
            color: "white",
            textDecoration: "none",
            fontWeight: "bold",
          }}
        >
          ← Back
        </a>
        <div style={{ flex: 1 }} />
        <span style={{ opacity: 0.7 }}>Live Earthquake Map</span>
      </div>

      {/* Map Component */}
      <div style={{ flex: 1 }}>
        <Map />
      </div>
    </div>
    </div>
  );
}
