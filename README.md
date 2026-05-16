# doctornet-protocol

Source of truth de los **contratos de datos** del ecosistema DoctorNet.

Hoy los DTOs (`ReportPayload`, `ScanPayload`, `HostMetric`, etc) viven duplicados:
- Pydantic en `doctornet-noc`
- Codable en `netprobe` (macOS)
- Codable en `doctornet-ios`
- Dict-shape ad-hoc en `netprobe-agent` y `netscout`

Cuando NOC agrega un campo (ej. `traceroute_samples` en v0.5.1), hay que cambiarlo a mano en 4 lugares y nadie te avisa si te olvidaste.

**Este repo arregla eso** publicando los tipos en **un solo lugar**, consumibles desde Swift (macOS + iOS) y Python (NOC + agents).

## Estructura

```
doctornet-protocol/
├── Package.swift                       Swift Package (macOS + iOS clients)
├── Sources/DoctorNetProtocol/          Swift Codable mirrors
│   ├── ReportPayload.swift
│   ├── ScanPayload.swift
│   ├── Common.swift                    Tipos compartidos (HostMetric, Alert, etc)
│   └── Version.swift                   Versión del protocolo
└── python/                             Python package
    ├── pyproject.toml
    ├── doctornet_protocol/
    │   ├── __init__.py
    │   ├── report.py
    │   ├── scan.py
    │   ├── common.py
    │   └── version.py
    └── tests/
        └── test_roundtrip.py
```

## Versionado

Semver. Versión actual: **0.1.0** (inicial, congela el shape al cierre del 2026-05-10).

- **Minor bump** (0.1 → 0.2): backwards-compatible (campos opcionales agregados).
- **Major bump** (0.x → 1.x): rompe compatibilidad. Todos los componentes deben actualizar.
- Cada componente pinea una versión exacta (ej. `doctornet-protocol==0.1.0`, no `>=0.1`).

Ver compatibility matrix en `doctornet-docs/COMPATIBILITY.md`.

## Cómo usarlo

### Swift (macOS / iOS, via SPM)

En `Package.swift` o en `project.yml` del consumidor:

```swift
dependencies: [
    .package(url: "https://github.com/mrhobbes79/doctornet-protocol", from: "0.1.0")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "DoctorNetProtocol", package: "doctornet-protocol"),
        ]
    )
]
```

Luego en código Swift:

```swift
import DoctorNetProtocol

let report = ReportPayload(
    version: ProtocolVersion.current,
    deviceID: UUID(),
    deviceName: "tech-laptop",
    // ...
)
let data = try JSONEncoder().encode(report)
```

### Python (NOC + agents)

```bash
pip install git+https://github.com/mrhobbes79/doctornet-protocol@v0.1.0#subdirectory=python
```

O en `requirements.txt`:

```
doctornet-protocol @ git+https://github.com/mrhobbes79/doctornet-protocol@v0.1.0#subdirectory=python
```

Luego:

```python
from doctornet_protocol import ReportPayload, HostPayload, IperfSamplePayload

report = ReportPayload(
    device_id=uuid4(),
    device_name="rpi-01",
    period_start=datetime.utcnow(),
    period_end=datetime.utcnow(),
    health_summary=...,
)
```

## ¿Por qué no codegen automático?

Considerado y descartado por ahora:

- Codegen Pydantic → Swift es frágil (`Optional[X]` ≠ `X?` cuando hay default values).
- JSON Schema → Swift/Python con `quicktype` o `datamodel-code-generator` agrega dependencia de build pipeline.
- Hand-written mirrors son **~150 líneas por lado** — mantenible a mano mientras el contrato cambie despacio.

Si en algún momento hay 3+ cambios al protocolo por mes, revisitar codegen.

## Roadmap del protocolo

Cosas pendientes que probablemente requieran bump:

- `WifiSummaryPayload`: agregar canales 6E (6 GHz)
- `HostPayload`: agregar `category_color` para UI custom
- `ReportPayload`: agregar `compression` field (gzip vs raw)
- Endpoint para registrar `iperf_relay` URL (futuro)

Ver `../doctornet-docs/ROADMAP.md` P2 para coordinación cross-repo.
