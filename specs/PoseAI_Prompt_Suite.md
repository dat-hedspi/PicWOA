# Picwoa AI Prompt Suite

## Repository

``` text
docs/prompts/
01_PRODUCT_VISION.md
02_PRD_GENERATOR.md
03_ARCHITECTURE_GENERATOR.md
04_MODULE_PLANNER.md
05_BUILD_EXECUTION_PLAN.md
06_TECH_LEAD.md
07_CODEX_IMPLEMENTATION.md
08_AI_ORCHESTRATOR.md
09_PROMPT_BUILDER.md
10_CODE_REVIEWER.md
11_DEMO_DIRECTOR.md
```

------------------------------------------------------------------------

# 01_PRODUCT_VISION.md

Role: Founder + Product Strategist.

Mission: - Define why the product exists. - Define mission, vision,
differentiation, user journey. - Do NOT discuss implementation. -
Product is an **AI Photographer**, not an AI Camera.

Output: - Vision - Mission - Product Principles - Personas - User
Journey - Success Metrics - Roadmap

------------------------------------------------------------------------

# 02_PRD_GENERATOR.md

Role: Senior Product Manager.

Generate: - Personas - User Stories - Functional Requirements -
Non-functional Requirements - MVP Scope - Out of Scope - Acceptance
Criteria - MoSCoW Priorities - Edge Cases

Output: Markdown.

------------------------------------------------------------------------

# 03_ARCHITECTURE_GENERATOR.md

Role: Principal iOS Architect.

Purpose: Design production-ready architecture only.

Architecture Rules: - Feature-first Architecture - Clean Architecture -
MVVM - SwiftUI - Async/Await - Apple Native APIs

Feature-first structure:

``` text
Features/
  CameraExperience/
  PoseCoaching/
  SceneAnalysis/
  CompositionGuide/
  LiveOverlay/
  PhotoCapture/
  PhotoReview/
  PhotoEditing/

Core/
  CameraEngine/
  VisionEngine/
  Networking/
  Storage/
  DesignSystem/

AI/
  RuleEngine/
  PromptBuilder/
  AIOrchestrator/
  OpenAIClient/
```

Generate: 1. System Architecture 2. Feature Architecture 3. Folder
Structure 4. Dependency Rules 5. AI Pipeline 6. State Machine 7. ADR 8.
Future Expansion

AI Pipeline:

Camera → Vision → Pose Extraction → Scene Analysis → Composition
Analysis → Decision Engine → Rule Engine → Prompt Builder → GPT →
Response Parser → Overlay → Capture → Core Image

No implementation code.

------------------------------------------------------------------------

# 04_MODULE_PLANNER.md

Role: Staff iOS Engineer.

Rules: - Follow Feature-first Architecture. - Never split modules by
technical concern only. - Each Feature owns Views, ViewModels,
Components, Models and Services.

Generate:

feature_modules

core_modules

ai_modules

Each module contains: - Purpose - Inputs - Outputs - Public API -
Dependencies - Folder Ownership - Can Run Independently - Can Run In
Parallel - Merge Risks - Integration Notes

Generate: - Parallel Workstreams - Merge Strategy - Data Flow - MVP /
Future Scope - Risks

Output JSON only.

------------------------------------------------------------------------

# 05_BUILD_EXECUTION_PLAN.md

Convert architecture into execution steps.

Return: - Build phases - Build order - Parallel work - Status tracking -
Checklist - Testing plan - Integration plan

------------------------------------------------------------------------

# 06_TECH_LEAD.md

Split work for: - 3 Swift Developers - 1 Designer

Return: - Branch strategy - Ownership - Merge order - Review checklist -
Definition of Done

------------------------------------------------------------------------

# 07_CODEX_IMPLEMENTATION.md

Role: Senior Swift Engineer.

Rules: - Never redesign architecture. - Generate code only inside
assigned module. - Swift 6 - SwiftUI - MVVM - Async/Await

Return: - Folder - Files - Code - Tests

------------------------------------------------------------------------

# 08_AI_ORCHESTRATOR.md

Input: - Vision - Scene - Composition - Rule Engine

Responsibilities: - Decide if GPT is needed. - Skip GPT when
deterministic rules are enough. - Select Prompt Template. - Compress
payload. - Normalize response.

Optimize: - Latency - Token Cost - Stability

------------------------------------------------------------------------

# 09_PROMPT_BUILDER.md

Generate prompts for: - Portrait - Beach - Cafe - Office - Temple -
Night - Wedding

Return: - System Prompt - User Prompt - Expected JSON - Validation Rules

------------------------------------------------------------------------

# 10_CODE_REVIEWER.md

Review: - Architecture - Performance - Concurrency - Memory - Naming -
Security - Testability

Return: - Issues - Severity - Suggested Fixes

------------------------------------------------------------------------

# 11_DEMO_DIRECTOR.md

Act as a Hackathon Judge.

Evaluate: - 30-second wow factor - Storytelling - Demo flow - Risks
during presentation - Expected judge questions - Suggested answers -
Last-minute improvements

------------------------------------------------------------------------

## Overall Workflow

Product Vision → PRD → Architecture → Module Planner → Build Plan → Tech
Lead → Codex → AI Orchestrator → Prompt Builder → Code Review → Demo
