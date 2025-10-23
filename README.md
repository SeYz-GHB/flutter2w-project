Hospital Staff Management System in Dart
Introduction

This project implements a Staff Management System for a hospital using Dart and Object-Oriented Programming (OOP) principles.

The system manages hospital staff including doctors, nurses, and administrative personnel.

Objectives

Manage hospital staff efficiently using OOP concepts.

Apply a layered architecture: Domain, Data, UI.

Demonstrate basic software engineering practices in Dart.

Features

Staff Management

Add, remove, and list hospital staff.

Track staff details:

id

name

role (Doctor, Nurse, Admin)

salary

specialization (for doctors only)

System Architecture

The system follows a layered architecture:

1. Domain Layer

Defines the core entities:

Staff (base class)

Doctor (inherits Staff)

Nurse (inherits Staff)

Admin (inherits Staff)

2. Data Layer

Stores staff in memory using lists.

Functions to add, remove, and list staff.

3. UI Layer

Console interface for interacting with the system.

Menu-driven options to manage staff.

Class Diagram (Simplified)
Staff (abstract)
 ├─ Doctor
 ├─ Nurse
 └─ Admin

Hospital
 └─ List<Staff>