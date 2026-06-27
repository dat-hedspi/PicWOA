# PRODUCT_VISION.md

## ROLE

You are the Founder, CEO, Product Strategist, UX Visionary, and AI Product Lead.

You are NOT an engineer.

You are defining the long-term direction of the product.

Every engineering, design, and AI decision must align with this document.

---

# PRODUCT NAME

Picwoa (Working Title)

---

# PRODUCT MISSION

Build an AI Photographer that helps anyone capture professional-looking photos without needing photography skills.

The application should guide both:

* The subject (how to pose)
* The photographer (how to frame, position, and capture)

The experience should feel like having a professional photographer standing beside the user.

---

# PRODUCT VISION

Most camera applications help users **after** a photo has been taken.

Picwoa helps users **before** the shutter is pressed.

Instead of editing mistakes, Picwoa prevents them.

The application continuously analyzes the live camera feed and provides real-time coaching until the photo is ready to capture.

---

# NORTH STAR

Become the world's smartest AI Photography Coach.

Not an AI Camera.

Not an AI Filter.

Not a Photo Editor.

An AI Photographer.

---

# PROBLEM STATEMENT

Most people:

* don't know how to pose
* don't know where to stand
* don't know how to compose a frame
* don't understand lighting
* don't know when to capture

As a result, they take many photos but keep very few.

Picwoa solves this by providing instant coaching before the photo is taken.

---

# TARGET USERS

Primary

* Travelers
* Couples
* Families
* Social media creators
* Casual users

Secondary

* Content creators
* Small businesses
* Fashion photographers
* Event photographers

---

# CORE VALUE PROPOSITION

Picwoa should help users answer:

* Where should I stand?
* How should I pose?
* Which direction should I face?
* Where should the photographer move?
* Is this composition good?
* Is the lighting flattering?
* Is this the right moment to capture?

---

# PRODUCT PRINCIPLES

## 1. Coach Before Capture

Always improve the photo before it is taken.

---

## 2. Real-time Experience

Suggestions should appear while the camera is open.

Never force the user to wait after pressing the shutter.

---

## 3. AI Assists, Never Overwhelms

Only display the most important suggestion.

One primary coaching cue.

One optional refinement.

Avoid information overload.

---

## 4. Apple Native First

Prioritize:

* Vision Framework
* Core ML
* Core Image
* AVFoundation

Use cloud AI only when deterministic logic is insufficient.

---

## 5. Privacy First

Images should remain on-device whenever possible.

Only structured metadata should be sent to cloud AI.

Avoid uploading full-resolution images unless explicitly requested.

---

# USER JOURNEY

Open App

↓

Camera Opens

↓

Vision detects:

* person
* scene
* composition
* lighting

↓

AI Coach generates guidance

↓

User adjusts

↓

Live score improves

↓

AI says:

"Perfect. Capture now."

↓

Photo captured

↓

Core Image recipe applied

↓

Share

---

# DIFFERENTIATORS

Instead of:

AI Camera

↓

Picwoa becomes

AI Photographer.

Instead of:

Photo Editing

↓

Live Coaching.

Instead of:

Static Pose Library

↓

Context-aware pose guidance.

Instead of:

Preset Filters

↓

Dynamic editing recipes.

---

# SUCCESS METRICS

User Experience

* Time to first successful photo
* Coaching acceptance rate
* Capture success rate
* User satisfaction

Technical

* Camera preview ≥30 FPS
* AI response <1 second
* Overlay latency <100 ms
* Crash-free sessions >99.5%

Business

* Daily Active Users
* Weekly Retention
* Premium Conversion
* Photos captured
* Coaching sessions

---

# MVP DEFINITION

The MVP succeeds if a user can:

1. Open the camera.
2. Receive live AI coaching.
3. Adjust their pose.
4. Capture a noticeably better photo.

Nothing else is required for MVP success.

---

# LONG-TERM ROADMAP

## MVP

* Camera
* Vision
* Pose Coaching
* Overlay
* Capture
* Core Image recipe

---

## V1

* Scene understanding
* Composition scoring
* Auto Capture
* Personalized coaching

---

## V2

* AI Photographer Mode
* Couple & Group Coaching
* Offline Core ML models
* Travel presets
* Community & Pose sharing

---

# ENGINEERING GUIDELINES

Every technical decision should support the following priorities:

1. Fast user feedback
2. On-device intelligence
3. Low latency
4. Low cloud cost
5. Modular architecture
6. Feature-first organization
7. AI used only when necessary

---

# FINAL PRINCIPLE

Whenever there is uncertainty, choose the option that makes the user feel like they are being guided by a professional photographer in real time.

If a feature does not contribute to that feeling, it does not belong in the product.
