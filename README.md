# 🚁 3m High-Efficiency Dual-Tilt-Rotor VTOL UAV System

<div align="center">

![Project Status](https://img.shields.io/badge/Status-In_Development-orange?style=for-the-badge)
![HTL Salzburg](https://img.shields.io/badge/HTL_Salzburg-Elektrotechnik-003366?style=for-the-badge)
![Regulatory Standard](https://img.shields.io/badge/SORA-SAIL_IV-navy?style=for-the-badge)
![ROS 2](https://img.shields.io/badge/ROS_2-Humble-22314E?style=for-the-badge&logo=ros)
![PX4](https://img.shields.io/badge/PX4-Autopilot_v1.14+-007ACC?style=for-the-badge)
![Gazebo](https://img.shields.io/badge/Gazebo-Fortress-orange?style=for-the-badge)
![Hardware](https://img.shields.io/badge/Jetson-Orin_Nano-76B900?style=for-the-badge&logo=nvidia)

**Diplomarbeit an der HTL Salzburg (Abteilung Elektrotechnik)**  
*in Kooperation mit dem **Österreichischen Bundesheer** & aligned mit **Austro Control / EASA** Standards.*

[Projektübersicht (DE)](#-projektübersicht-deutsch) • [Project Overview (EN)](#-project-overview-english) • [Technical Specifications](#-technical-specifications) • [System Architecture](#-system-architecture) • [Repo Structure](#-repository-structure) • [Getting Started](#-getting-started) • [Team & Contact](#-team--contact)

---

</div>

## 📌 Projektübersicht (Deutsch)

Dieses Diplomprojekt an der **HTL Salzburg (Elektrotechnik)** umfasst die konzeptionelle Auslegung, thermodynamische/aerodynamische Simulation, mechatronische Entwicklung und Fertigung eines autonomen, 3 Meter großen **Dual-Tilt-Rotor VTOL-UAVs** (MTOM ~26,5 kg). Das Flugsystem ist speziell für **alpine Such- und Rettungseinsätze (SAR / Bergrettung)** sowie den Katastrophenschutz in hochalpinem Terrain (bis zu 4.000 m ü. A.) ausgelegt.

### ⚙️ Antriebs- & Flugkonzept
Um eine maximale aerodynamische Effizienz im Vorwärtsflug und hohe Reichweiten ($\le 30\text{ km}$ Radius) zu erzielen, verzichtet das Fluggerät vollständig auf dedizierte Schwebeflug-Motoren (kein klassisches Quadcopter-Setup). Stattdessen setzt das System auf ein **asymmetrisches Tri-Tilt-Rotor-Konzept**:
- **Vordere Hauptantriebe:** Zwei schwenkbare Triebwerke (*Dual-Tilt-Rotors*) an den Tragflächen liefern vertikalen Schub beim Start und schwenken für den Reiseflug stufenlos um 90° nach vorne.
- **Heck-Hubantrieb:** Ein im T-Leitwerk integrierter VTOL-Heckmotor liefert die erforderliche Nicksynchronisation im Schwebeflug. Nach der Transition in den Fixed-Wing-Modus wird dieser Motor elektronisch deaktiviert und eingenommen, um den aerodynamischen Widerstand auf Null zu reduzieren.

---

## 🌐 Project Overview (English)

This diploma project at **HTL Salzburg (Department of Electrical Engineering)** covers the aerodynamic design, mechatronic development, hardware-in-the-loop simulation, and structural construction of a modular 3-meter **Dual-Tilt-Rotor VTOL UAV** (MTOM ~26.5 kg). Engineered for **alpine Search & Rescue (SAR)** operations, the aircraft operates under extreme weather and atmospheric conditions (elevations up to 4,000 m MSL and temperatures down to -35°C).

### ⚙️ Propulsion & Flight Concept
To achieve maximum aerodynamic efficiency and extended range ($\le 30\text{ km}$ operational radius) during wing-borne cruise, the aircraft eliminates redundant hover motors. Instead, it utilizes an **asymmetric Tri-Tilt-Rotor topology**:
- **Front Main Actuators:** Two wing-mounted tilting motor nacelles (*Dual-Tilt*) provide vertical thrust during takeoff/landing and vector 90° forward for high-speed cruise.
- **Rear Hover Actuator:** A tail-mounted motor compensates pitch during hover. Once airspeed exceeds stall speed ($V_{\text{stall}} \approx 12.5\text{ m/s}$), the system transitions into fixed-wing flight and deactivates/folds the rear motor to minimize drag.

---

## 📊 Technical Specifications

| Parameter | Specification | Details / Operational Range |
| :--- | :--- | :--- |
| **Wingspan / Length** | $3.0\text{ m}$ span | Modular quick-assembly carbon wings |
| **Max Take-Off Mass (MTOM)** | $\approx 26.5\text{ kg}$ | Target weight class: 20 – 30 kg |
| **Payload Capacity** | $1.0\text{ kg}$ | Dual EO/IR Stabilized Optical/Thermal Gimbal |
| **Power Supply** | $12\text{S LiPo}$ ($44.4\text{ V}$ nominal) | Distributed Power Distribution Board (PDB) |
| **Cruise Speed ($V_{\text{cruise}}$)** | $18\text{ m/s}$ ($\approx 65\text{ km/h}$) | Optimised for thermal/optical AI scan pattern |
| **Max Speed ($V_{\text{max}}$)** | $36\text{ m/s}$ ($\approx 130\text{ km/h}$) | Structural Never-Exceed Limit |
| **Stall Speed ($V_{\text{stall}}$)** | $12.5\text{ m/s}$ ($\approx 45\text{ km/h}$) | Minimum fixed-wing level flight speed |
| **Operational Ceiling** | Up to $4,000\text{ m MSL}$ | Atmospheric compensation down to $616\text{ hPa}$ |
| **Temperature Envelope** | $-35^\circ\text{C}$ to $+40^\circ\text{C}$ | Heated IMU board & environmental shielding |
| **Regulatory Risk Level** | **SORA SAIL IV** | EASA SC-Light UAS compliant design |

---

## 🛠️ System Architecture

```
                                  +---------------------------------------+
                                  |     Ground Control Station (GCS)      |
                                  |   HMI & Tactical Mission Control      |
                                  +---------------------------------------+
                                        |                 |         |
                          868 MHz FHSS  |    2.4GHz / LTE |         | 5.8 GHz COFDM
                         Primary C2 Link|    Secondary C2 |         | Video Stream
                                        v                 v         v
+-----------------------------------------------------------------------------------+
| AIRBORNE SEGMENT (ALBATROS VTOL)                                                  |
|                                                                                   |
|  +-----------------------------------+     micro-XRCE-DDS    +------------------+ |
|  | Flight Controller (Pixhawk 6X)    |<=====================>| Companion Comp.  | |
|  | - PX4 Autopilot (NuttX RTOS)      |     over Ethernet     | NVIDIA Jetson    | |
|  | - STM32H753 MCU + STM32F103 IO    |   (< 2 ms latency)    | Orin Nano        | |
|  | - 3x ICM-45686 IMUs (BalancedGyro)|                       | - Ubuntu 22.04   | |
|  | - Dual Baro (ICP20100 + BMP388)   |                       | - ROS 2 Humble   | |
|  | - Vector Control & PID Loops      |                       | - YOLO + TensorRT| |
|  +-----------------------------------+                       +------------------+ |
|                   |                                                   |           |
|        CAN / PWM  v                                                   v           |
|  +----------------------------------+                        +------------------+ |
|  | Actuators & Motors               |                        | Payload & Sensors| |
|  | - 2x Front: T-Motor V605 KV210   |                        | - EO/IR Gimbal   | |
|  |   + Volz DA 30-HT-D / DA 36-LP   |                        | - Airspeed Pitot | |
|  | - 1x Rear: T-Motor V605 + 3-Blade|                        | - 105dB Siren    | |
|  | - FTS Pyrotechnic Parachute      |                        | - 72h UHF ELT    | |
|  +----------------------------------+                        +------------------+ |
+-----------------------------------------------------------------------------------+
```

### 🛩️ Flight Control & Avionics (SAIL IV)
- **Primary Flight Controller:** Holybro Pixhawk 6X running **PX4 Autopilot (v1.14+)** on NuttX RTOS.
- **Hardware Redundancy:** Split MCU architecture (STM32H753 main processor + STM32F103 safety IO coprocessor) and triple-redundant, heated, vibration-isolated IMU domains (`ICM-45686`).
- **Companion Computer & AI:** **NVIDIA Jetson Orin Nano** running **ROS 2 Humble**. High-speed inter-processor bridge via `micro-XRCE-DDS` over native Ethernet ($< 2\text{ ms}$ latency). Real-time object detection (YOLOv8 accelerated with TensorRT) converting pixel coordinates into WGS84/MGRS geo-targets.

### 📡 Datalinks & Emergency Systems
- **Command & Control (C2):** Tri-band redundant setup: Primary 868 MHz FHSS ($500\text{ mW}$), backup 2.4 GHz short-range & LTE 4G/5G mobile network, plus autarkic 5.8 GHz COFDM video link.
- **Contingencies & Failsafes:**
  - *GPS Loss:* Autonomous **Dead Reckoning** via sensor-fusion EKF2 (Pitot airspeed + IMU + wind estimation).
  - *Engine Failure:* Structural belly-landing capability or deployment of the integrated **pyrotechnic ballistic parachute system**.
  - *Emergency Response Plan (ERP):* Instant transmission of Last Known Position (LKP) in **WGS84 & MGRS**, activation of a $105\text{ dB}$ piezo beacon, and a $72\text{h}$ UHF emergency locator transmitter (ELT).

---

## 📂 Repository Structure

```
.
├── docs/                     # Documentation & Technical Design Documents
│   ├── concept/              # Conceptual layout & LaTeX sources
│   ├── tdd_de/               # Technical Design Document (German / HTL Version)
│   │   ├── main_de.tex       # Master LaTeX file (14 Chapters according to SORA SAIL IV)
│   │   └── chapters/         # CONOPS, Aerodynamics, Avionics, Software, Safety, etc.
│   ├── tdd_en/               # Technical Design Document (English / Sponsor Version)
│   ├── pdfs/                 # Official regulations, SORA matrices & Easy Access Rules
│   └── data/                 # Raw datasheets, CAD specs & avionics pinout matrices
│
├── src/                      # Robotics & Control Source Code
│   ├── vtol_control/         # ROS 2 C++ vector control & trajectory planning nodes
│   └── vtol_gazebo/          # Gazebo Fortress simulation models & worlds
│
├── hardware/                 # Hardware & CAD Exports
│   ├── cad/                  # Solid Edge CAD models & STEP exports
│   ├── 3d_print/             # Slicer configs & gcode (Extrudr PA12-CF carbon nylon)
│   └── electronics/          # Wiring diagrams, PDB schematics & pinout matrices
│
├── run.ps1                   # Automation & LaTeX project setup script
└── README.md                 # Project README
```

---

## 🚀 Getting Started

### Prerequisites
- **Operating System:** Linux (Ubuntu 22.04 LTS recommended) or WSL2 on Windows
- **ROS 2:** Humble Hawksbill (`ros-humble-desktop-full`)
- **Simulation:** Gazebo Fortress / Ignition Gazebo
- **Build System:** `colcon`, `cmake`, `g++`
- **LaTeX (for TDD compilation):** `texlive-full`, `latexmk`

### 1. Building the ROS 2 Workspace
```bash
# Clone the repository
git clone https://github.com/DaSommsi/vtol-drohne-diplomprojekt.git
cd vtol-drohne-diplomprojekt

# Build ROS 2 packages
colcon build --symlink-install
source install/setup.bash
```

### 2. Running the Gazebo Simulation
```bash
# Launch Gazebo world with VTOL dual-tilt rotor model
ros2 launch vtol_gazebo vtol_sim.launch.py
```

### 3. Compiling Technical Design Documents (LaTeX)
To build the German Technical Design Document (TDD):
```bash
cd docs/tdd_de
latexmk -pdf main_de.tex
```

---

## 👥 Team & Contact

<div align="center">

| Author | Role / Focus Area | Institution |
| :--- | :--- | :--- |
| **David Sommerer** | Avionics, Software Architecture, ROS 2, CONOPS & SORA | HTL Salzburg (Elektrotechnik) |
| **Sebastian Minkenberg** | Propulsion, Tilt Mechanics, Aerodynamics & CAD | HTL Salzburg (Elektrotechnik) |

**Diploma Thesis Advisory / Partners:**
- **HTL Salzburg** – Höhere Technische Bundeslehranstalt Salzburg (Abteilung Elektrotechnik)
- **Österreichisches Bundesheer** – Tactical & Logistics Support
- **Austro Control** – Regulatory Compliance & SORA Guidance

</div>

---

<div align="center">
  <sub>© 2026 Dual-Tilt-Rotor VTOL Diploma Project Team. All Rights Reserved.</sub>
</div>
