# WM-Controller-Design
 Washing Machine Controller Design in Verilog HDL

# Washing Machine Controller (WM-Controller)
This repository contains the Verilog implementation of a Washing Machine Controller module. This module is designed to control the different stages of a washing machine based on user input signals, such as lid, coin, and cancel with different modes for user to choose from.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Verilog Files](#verilog-files)
- [Simulation](#simulation)
- [Interpretting Code](#interpretting-code)
## Introduction

The Washing Machine Controller module is implemented in Verilog and uses a finite state machine to control the various stages of a washing machine.

## Features

- State machine implementation for washing machine control.
- Support for different modes with configurable soak, wash, rinse, and spin times.
- Outputs indicating the current state of the washing machine.

## Verilog Files

- `Controller.v`: Main Verilog file containing the Washing Machine Controller module.
- `testbench.v` : Testbench file.
## Simulation

To simulate the Verilog code, you can use a Verilog simulator such as . Follow these steps:

## Interpretting Code
| Signal name   |  Direction | Description |
| ------------- | ---------- | ----------- |
| clk |input| Clock signal |
| lid |input| Machine door (lid) is open |
| Coin |input| Start wash machine after coin insertion |
| Cancel |input| Cancels the washing process |
| mode |input| Select Washing modes |
| idle_op |output| Do not perform any process |
| ready_op |output| Machine is ready to start the process
| soak_op |output| Soaking operation |
| wash_op |output| Washing operation |
| rinse_op |output| Rinsing operation |
| spin_op |output| Spinning operation |
| coin_rtrn |output| Return the coin |
| water_inlet |output| Water intake |
