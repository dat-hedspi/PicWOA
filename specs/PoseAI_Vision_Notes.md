# Picwoa Vision Notes

## 1. Product Vision

**Mission:** Become the AI Photographer in your pocket.

### Core idea

Instead of only suggesting poses, the app coaches both: - The model -
The photographer

### Product flow

``` text
Open Camera
→ AI understands Scene + Lighting + Composition + Pose
→ Live Coaching
→ User adjusts
→ AI says "Perfect"
→ Capture
→ Auto Edit
→ Share
```

### AI Pipeline

``` text
Camera
→ Vision
→ Pose Extraction
→ Scene Analysis
→ Composition Analysis
→ Decision Engine
→ Rule Engine
→ Prompt Builder
→ GPT (only when necessary)
→ Overlay Renderer
→ Capture
→ Core Image Recipe
```

### Principles

-   Vision & Core ML first.
-   Rule Engine before GPT.
-   GPT only for creative coaching.
-   Core Image applies editing recipes.
-   Real-time experience.

------------------------------------------------------------------------

# 2. Hackathon Vision (4 Hours)

Goal: Build a convincing demo, not a production app.

### Demo Flow

``` text
Open App
→ Camera
→ Detect Person
→ Analyze
→ Overlay Guidance
→ Capture
```

### Must Have

-   Camera Preview
-   Person Detection
-   Analyze button
-   GPT JSON response
-   Overlay guidance
-   Capture photo

### Skip

-   Login
-   Backend
-   Firebase
-   Database
-   History
-   Favorites
-   Pose Library
-   Core ML training

------------------------------------------------------------------------

# 3. Team Split

## Dev A

-   Camera
-   AVFoundation
-   Permissions
-   Vision Person Detection

## Dev B

-   GPT API
-   Networking
-   JSON Parser
-   Prompt Builder

## Dev C

-   SwiftUI UI
-   Overlay
-   Result Screen
-   Animations

## Designer / PM

-   UI polish
-   Demo script
-   README
-   Testing

------------------------------------------------------------------------

# 4. GPT Payload

``` json
{
  "scene":"office",
  "lighting":"soft",
  "subject_count":1,
  "pose":"standing",
  "issues":[
    "left shoulder low",
    "chin down"
  ]
}
```

Expected response:

``` json
{
  "main_cue":"Xoay người 20° sang trái.",
  "secondary_cue":"Nâng cằm nhẹ.",
  "camera":"Lùi 2 bước.",
  "filter":{
    "exposure":-0.2,
    "contrast":10
  }
}
```

------------------------------------------------------------------------

# 5. Long-term Product Roadmap

## MVP

-   Camera
-   Vision Detection
-   GPT Coach
-   Overlay
-   Capture

## V1

-   Scene Detection
-   Composition Analysis
-   Auto Capture
-   Core Image Recipes

## V2

-   Personalized Pose Library
-   AI Photographer Mode
-   Travel Presets
-   Offline Core ML
-   Community & Sharing

------------------------------------------------------------------------

# Guiding Principle

> Don't build an AI Camera.
>
> Build an AI Photographer.
