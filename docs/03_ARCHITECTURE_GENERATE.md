# ROLE

You are a Principal iOS Architect, Staff Swift Engineer, AI Systems Architect, and Technical Product Designer.

Your mission is to design the complete architecture for an AI-powered photography coach application.

This is NOT a coding task.

This is an architecture design task.

---

# PRODUCT VISION

The application is NOT an AI Camera.

The application is an AI Photographer.

It helps both:

- The subject
- The photographer

capture professional-looking photos through real-time coaching.

The app should prioritize:

1. Apple Vision Framework
2. Core ML
3. Rule Engine
4. GPT (only when deterministic logic is insufficient)

---

# OBJECTIVES

Generate a production-ready architecture that is:

- Modular
- Scalable
- Easy for multiple developers
- Easy for multiple AI coding agents
- Clean Architecture
- MVVM
- Feature-first
- SwiftUI Native
- Async/Await

---

# TECH STACK

Language
- Swift 6

UI
- SwiftUI
- NavigationStack
- Observation

Camera
- AVFoundation

Vision
- Vision Framework

ML
- CoreML

Image
- CoreImage

Storage
- SwiftData

Networking
- URLSession

Cloud AI
- OpenAI API

---

# REQUIRED ARCHITECTURE

Generate:

## 1. System Architecture

High-level architecture diagram.

---

## 2. Feature Architecture

The application MUST be organized using Feature-first Architecture.

Avoid organizing by technical layers such as Camera, Networking, Models or Services.

Instead, organize by user-facing features.

Example:

Features/

- CameraExperience
- PoseCoaching
- SceneAnalysis
- CompositionGuide
- LiveOverlay
- PhotoCapture
- PhotoReview
- PhotoEditing

Core/

- VisionEngine
- CameraEngine
- Networking
- DesignSystem
- Storage

AI/

- PromptBuilder
- RuleEngine
- AIOrchestrator
- OpenAIClient

Each Feature should own:

- Views
- ViewModels
- Models
- Services
- Components
- Routing

Minimize dependencies between Features.

---

## 3. Clean Architecture

Layers

Presentation

↓

Application

↓

Domain

↓

Infrastructure

↓

External Services

---

## 4. Folder Structure

Generate a production folder structure.

Feature-first.

---

## 5. Dependency Rules

Clearly define:

Which layer can access which layer.

---

## 6. AI Pipeline

Describe the complete AI pipeline.

Example

Camera

↓

Vision

↓

Pose Extraction

↓

Scene Analyzer

↓

Composition Analyzer

↓

Decision Engine

↓

Rule Engine

↓

Prompt Builder

↓

GPT

↓

Response Parser

↓

Overlay Renderer

↓

Capture

---

## 7. Data Flow

Describe every data flow.

---

## 8. State Machine

Define application states.

Example

Idle

Detecting

Analyzing

Suggesting

Ready

Capturing

Review

---

## 9. ADR

Generate major architecture decisions.

Explain WHY.

---

## 10. Future Expansion

Show where future modules plug in.

---

# OUTPUT

Markdown only.

No implementation code.

No Swift.

No pseudocode.

Architecture only.
