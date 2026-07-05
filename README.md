# Synchronous FIFO Buffer Design using Verilog

A high-performance, synthesis-ready **Synchronous FIFO (First-In, First-Out)** memory buffer designed in Verilog HDL. This project demonstrates core VLSI concepts including modular digital design, pointer management, and status flag generation under a single clock domain.

---

## 📌 Project Overview

A FIFO is a critical component in digital systems used to buffer data between hardware modules. This design implements a synchronous architecture where both data write and data read operations share the same clock signal. 

### Key Features:
* **Parameterized Design:** Easily configure `DATA_WIDTH`, `DEPTH`, and `ADDR_WIDTH` to scale the buffer.
* **Status Flags:** Real-time generation of `full` and `empty` flags to prevent data overwriting or underflow.
* **Resource Optimization:** Uses a built-in counter logic mechanism to safely track memory occupancy.
* **Fully Synthesizable:** Written in standard synthesizable Verilog, ready for FPGA or ASIC deployment.

---

## 🏗️ Architecture & Signal Breakdown

The design consists of a memory array, a Write Pointer tracking incoming data addresses, a Read Pointer tracking outgoing data addresses, and an internal tracking counter.

| Signal Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1-bit | System Clock |
| `rst_n` | Input | 1-bit | Active-Low Asynchronous Reset |
| `wr_en` | Input | 1-bit | Write Enable (Active High) |
| `rd_en` | Input | 1-bit | Read Enable (Active High) |
| `data_in` | Input | `[DATA_WIDTH-1:0]` | Parallel Data Input Bus |
| `data_out` | Output | `[DATA_WIDTH-1:0]` | Parallel Data Output Bus |
| `full` | Output | 1-bit | High when FIFO is full (prevents writes) |
| `empty` | Output | 1-bit | High when FIFO is empty (prevents reads) |
| `fifo_cnt` | Output | `[ADDR_WIDTH:0]` | Current count of elements stored |

---

## 📁 Repository Structure

```text
├── src/
│   └── synchronous_fifo.v    # Core FIFO RTL Design
├── tb/
│   └── tb_synchronous_fifo.v # Self-checking Simulation Testbench
└── README.md                 # Project Documentation
