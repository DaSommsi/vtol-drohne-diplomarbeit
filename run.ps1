# 1. Sicherstellen, dass der Ordner existiert und hineinwechseln
$path = "docs/tdd_de/chapters"
if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force }
Set-Location $path

# 2. Alle alten Test-Dateien löschen
Remove-Item 0* -ErrorAction SilentlyContinue

# 3. Alle 13 Kapitel-Dateien mit sauberem Inhalt erzeugen
@'
\chapter{Executive Summary \& Admin}
\label{ch:admin}
\section{Purpose \& Scope}
\section{Document Traceability (MRD)}
\section{Applicable Standards (EASA SC-Light UAS, STANAG 4703)}
\section{Configuration Management}
'@ | Out-File -FilePath "01_admin.tex" -Encoding utf8

@'
\chapter{Concept of Operations (CONOPS)}
\label{ch:conops}
\section{Operational Scenarios (VTOL, Transition, Fixed-Wing)}
\section{Flight Envelopes}
\section{Environmental Constraints}
'@ | Out-File -FilePath "02_conops.tex" -Encoding utf8

@'
\chapter{System Architecture \& High-Level Design}
\label{ch:architecture}
\section{System Element Breakdown (Air Vehicle vs. GCS)}
\section{Functional Architecture}
\section{Physical Architecture \& Integration}
'@ | Out-File -FilePath "03_architecture.tex" -Encoding utf8

@'
\chapter{Airframe \& Aerodynamics}
\label{ch:aerodynamics}
\section{Aerodynamic Design \& Transition Physics}
\section{Structural Layout \& Materials (CFK, PA12-CF)}
\section{Mass Properties \& Center of Gravity (CoG) Shift}
'@ | Out-File -FilePath "04_aerodynamics.tex" -Encoding utf8

@'
\chapter{Propulsion \& Tilt-Mechanism}
\label{ch:propulsion_tilt}
\section{Powertrain Architecture}
\section{Motor Specifications \& Efficiency}
\section{Tilt Actuation System (TAS) \& Redundancy}
\section{Rotor/Propeller Design}
'@ | Out-File -FilePath "05_propulsion_tilt.tex" -Encoding utf8

@'
\chapter{Avionics \& Flight Control System (FCS)}
\label{ch:avionics_fcs}
\section{Flight Control Laws (C-Laws for Conversion Mode)}
\section{Sensor Fusion Matrix (IMU, GNSS, Air-Data)}
\section{Avionics Hardware Architecture}
'@ | Out-File -FilePath "06_avionics_fcs.tex" -Encoding utf8

@'
\chapter{Electrical \& Energy Storage Systems}
\label{ch:electrical_energy}
\section{Power Distribution Architecture (High- vs. Low-Volt)}
\section{Battery Management System (BMS) \& Thermal Management}
\section{Emergency Power (Bus-Backup)}
'@ | Out-File -FilePath "07_electrical_energy.tex" -Encoding utf8

@'
\chapter{Communication \& Datalink}
\label{ch:communication}
\section{Command \& Control (C2) Datalink}
\section{Payload Datalink}
\section{Lost-Link Procedures (Autonome RTH-Routinen)}
'@ | Out-File -FilePath "08_communication.tex" -Encoding utf8

@'
\chapter{Payload Integration}
\label{ch:payload}
\section{Payload Bay Interfaces (Mechanical \& Data)}
\section{Center of Gravity Impact}
'@ | Out-File -FilePath "09_payload.tex" -Encoding utf8

@'
\chapter{Safety, Redundancy \& Failure Modes (FMEA)}
\label{ch:safety}
\section{Functional Hazard Assessment (FHA)}
\section{Redundancy Concept (Fail-Safe vs. Fail-Operational)}
\section{Emergency Systems (Ballistischer Fallschirm)}
'@ | Out-File -FilePath "10_safety.tex" -Encoding utf8

@'
\chapter{Ground Control Station (GCS) \& HMI}
\label{ch:gcs_hmi}
\section{GCS Hardware \& Software Architecture}
\section{Pilot Interface (HMI \& Telemetry Visualization)}
'@ | Out-File -FilePath "11_gcs_hmi.tex" -Encoding utf8

@'
\chapter{Manufacturing, Assembly \& Maintenance}
\label{ch:manufacturing}
\section{Design for Manufacturing (DFM)}
\section{Maintenance \& Component Lifespan (MTBF)}
'@ | Out-File -FilePath "12_manufacturing.tex" -Encoding utf8

@'
\chapter{Verification, Validation \& Testing (V\&V)}
\label{ch:testing}
\section{Simulation \& Hardware-in-the-Loop (HITL)}
\section{Ground Testing (Wing-Bend, Propulsion Testbed)}
\section{Flight Test Program (Transition Corridor Validation)}
'@ | Out-File -FilePath "13_testing.tex" -Encoding utf8

# 4. Wieder zurück in den Root-Ordner springen
Set-Location ../../../
Write-Host "Done! Alle 13 Luftfahrt-Kapitel wurden erfolgreich angelegt!" -ForegroundColor Green