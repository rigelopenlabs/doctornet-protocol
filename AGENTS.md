# doctornet-protocol (MQ-32)

Librería con los tipos de datos que intercambian el NOC de DoctorNet y sus apps (macOS y iPhone): un paquete Swift y uno Python que buscan describir el mismo JSON (hoy con diferencias, ver Riesgos abiertos). Sin interfaz, servidor ni datos propios. Familia DoctorNet, etapa Producción. Código de Mesquite (recibido de Rigel Open Labs el 12 de octubre de 2026).
Ficha: MQ-32 en el registro de fichas de Mesquite AI. Responsable técnico y quién valida: [POR CONFIRMAR: la ficha dice «Por definir»]. Revisado: 2026-10-15.

## Stack

- Swift con SwiftPM: [Package.swift](Package.swift).
- Python con pydantic: [python/pyproject.toml](python/pyproject.toml).
- Se distribuye por tag de git. Pin de cada consumidor: [NOC](../doctornet-noc/requirements.txt) (rigelopenlabs/doctornet-noc), [macOS](../../Proyectos%20JH/netprobe/project.yml) (mrhobbes79/netprobe), [iOS](../../Proyectos%20JH/doctornet-ios/project.yml) (mrhobbes79/doctornet-ios).

## Comandos

| Para | Comando |
| --- | --- |
| Compilar (Swift) | `swift build` (del mensaje del commit 360a8bd) |
| Pruebas (Swift) | `swift test` (del mismo commit) |
| Pruebas (Python) | `cd python && pip install -e . pytest && pytest` (comprobado el 2026-10-23: 3 pruebas pasan) |

## Contrato

Este repo es el dueño del contrato (regla 7). La tabla lista el archivo de cada lado; no son equivalentes hoy (ver Riesgos abiertos). Instalación: [README](README.md), «Cómo usarlo».

| Qué define | Swift | Python |
| --- | --- | --- |
| Versiones | [Version.swift](Sources/DoctorNetProtocol/Version.swift) | [version.py](python/doctornet_protocol/version.py) |
| Tipos comunes | [Common.swift](Sources/DoctorNetProtocol/Common.swift) | [common.py](python/doctornet_protocol/common.py) |
| Reporte periódico | [ReportPayload.swift](Sources/DoctorNetProtocol/ReportPayload.swift) | [report.py](python/doctornet_protocol/report.py) |
| Escaneo de red | [ScanPayload.swift](Sources/DoctorNetProtocol/ScanPayload.swift) | [scan.py](python/doctornet_protocol/scan.py) |
| Ida y vuelta | [RoundTripTests.swift](Tests/DoctorNetProtocolTests/RoundTripTests.swift) | [test_roundtrip.py](python/tests/test_roundtrip.py) |

Reglas:

1. Un campo se cambia en Swift y en Python en el mismo commit (el 360a8bd corrigió un desfase).
2. En el JSON los nombres van en snake_case; Swift los mapea con `CodingKeys`.
3. Las fechas van en ISO 8601: las pruebas y los clientes Swift codifican con `.iso8601` ([macOS](../../Proyectos%20JH/netprobe/NetProbe/Sources/Services/RemoteReportService.swift) (mrhobbes79/netprobe), [iOS](../../Proyectos%20JH/doctornet-ios/DoctorNet/Services/ReportService.swift) (mrhobbes79/doctornet-ios)).
4. Qué sube versión menor o mayor, y el pin: [README](README.md), «Versionado».
5. Subir versión toca `Version.swift`, `version.py`, `pyproject.toml` y las pruebas que la comprueban.
6. Tras publicar un tag, cada consumidor sube su pin.

Versiones compatibles entre componentes: [COMPATIBILITY.md](../../Proyectos%20JH/doctornet-docs/COMPATIBILITY.md) (mrhobbes79/doctornet-docs; desactualizado: la sede lo lista como atrasado en su [AGENTS.md](../../Proyectos%20JH/doctornet-docs/AGENTS.md#riesgos-abiertos)).

## Mapa: qué leer antes de tocar algo

| Si vas a tocar… | Lee |
| --- | --- |
| Qué es DoctorNet | [producto de la familia](../../Proyectos%20JH/doctornet-docs/docs/producto.md) (mrhobbes79/doctornet-docs) |
| Por qué hay un paquete compartido | [ADR 0003](../../Proyectos%20JH/doctornet-docs/docs/adr/0003-protocolo-fuente-unica.md) (mrhobbes79/doctornet-docs) |
| Por qué no hay codegen | [README](README.md), «¿Por qué no codegen automático?» |
| Quién envía y recibe estos tipos | [NOC](../doctornet-noc/AGENTS.md) y su [backend](../doctornet-noc/docs/backend.md) (rigelopenlabs/doctornet-noc), [macOS](../../Proyectos%20JH/netprobe/AGENTS.md) (mrhobbes79/netprobe), [iOS](../../Proyectos%20JH/doctornet-ios/AGENTS.md) (mrhobbes79/doctornet-ios) |
| Uso del paquete Python | [python/README.md](python/README.md) |

Frontend, backend propio, distribución propia, hardware y plan: no aplican (librería; Producción no abre plan aquí). No hay roles en este repo.

## Prohibido

- Cambiar un campo en un solo lado (regla 1 de «Contrato»).
- Romper compatibilidad sin subir la versión mayor ([README](README.md), «Versionado»).
- Escribir secretos o datos reales de redes (IP, MAC, SSID, coordenadas) en el repo, ejemplos o pruebas: el repo no guarda ninguno.

## Qué no incluye

La lista de la familia: [producto.md](../../Proyectos%20JH/doctornet-docs/docs/producto.md#no-incluye) (mrhobbes79/doctornet-docs). Propio: no envía nada por red.

## Riesgos abiertos

- `README.md` · desactualizado: versión y estado atrasados frente a `Version.swift` y `pyproject.toml`; lista agentes que la ficha no incluye y URLs de la cuenta anterior; enlace roto a `../doctornet-docs/ROADMAP.md`; dice «~150 líneas por lado», ya no es cierto.
- `python/README.md` · desactualizado: pin y URL de la cuenta anterior.
- Tags · hay un tag posterior al de `main` solo en la rama remota `feat/cloud-accounts` (`git tag`); los consumidores fijan versiones distintas y iOS y macOS usan `from:` en vez del pin exacto del README. Versión vigente (2026-10-23): **v0.1.2**, el tag más reciente. El NOC la fija con `@v0.1.2` en la rama `deploy/railway` que corre en Railway; iOS (`from: 0.1.0`) y macOS (`from: 0.1.1`) también resuelven a v0.1.2; la app Flutter trae una copia en Dart de v0.1.2. La 0.2.0 (límites y `validate()`) está a medias, sin commit ni tag.
- `python/doctornet_protocol/scan.py:38-39` · define `topology` y `alerts`; `Sources/DoctorNetProtocol/ScanPayload.swift` no los tiene. El NOC los usa ([ingest_scan.py:19-20,84](../doctornet-noc/app/services/ingest_scan.py) y [web.py:686](../doctornet-noc/app/routes/web.py), rigelopenlabs/doctornet-noc): un cliente Swift no puede mandarlos.
- `python/doctornet_protocol/common.py:30` · `global_health = Field(alias="global")`: `model_dump()` da `global_health` y solo con `by_alias` da `global`, que es lo que espera Swift. Contradice la regla 2 de «Contrato»; latente, nadie lo usa hoy.
- `report.py`, `ReportPayload.swift` · Python limita tamaños y rangos (`max_length`, `confloat`) y Swift no; `status_changes` es `list[dict]` en Python y `[[String: String]]?` en Swift. Un cliente Swift puede enviar lo que el NOC rechaza.
- `python/pyproject.toml` · licencia «Proprietary» sin archivo de licencia en el repo.
- Sin integración continua: nada corre las pruebas de ninguno de los dos lados.
