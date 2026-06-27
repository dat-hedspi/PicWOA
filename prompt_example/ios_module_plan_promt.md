You are a senior iOS architect, system designer, and product planner.

Your task is to produce a detailed implementation plan for an iOS AI camera app.

Primary goals:
- The app helps users take better photos with AI-guided pose, scene, and composition coaching.
- The plan must be modular, scalable, and easy for multiple people or AI workers to implement independently.
- Every module must have clear boundaries, inputs, outputs, dependencies, and integration points.
- The plan must be structured so each module can be developed separately and merged later with minimal conflict.

Requirements:
1. Break the whole app into modules.
2. For each module, specify:
   - name
   - purpose
   - responsibilities
   - inputs
   - outputs
   - dependencies
   - can_run_independently (true/false)
   - can_run_in_parallel (true/false)
   - integration_notes
3. Make sure the modules are split in a way that allows multiple AI workers or engineers to build different modules at the same time.
4. Include a clear data flow between modules.
5. Include a clear merge strategy so outputs from separate modules can be combined reliably.
6. Suggest extra features that can be added later.
7. Organize the result into MVP, V1, and V2 phases.
8. Return output in structured JSON only.
9. Keep everything practical for a real iOS app built with Swift/SwiftUI unless another native approach is better.

Important:
- Do not write vague advice.
- Do not merge unrelated responsibilities into one module.
- Do not skip input/output definitions.
- Do not assume all modules need AI.
- Distinguish between deterministic logic and AI-powered logic.
- Make the plan suitable for distributed development across multiple machines or workers.

Output format:
{
  "app_overview": "",
  "modules": [
    {
      "name": "",
      "purpose": "",
      "responsibilities": [],
      "inputs": [],
      "outputs": [],
      "dependencies": [],
      "can_run_independently": true,
      "can_run_in_parallel": true,
      "integration_notes": ""
    }
  ],
  "data_flow": [],
  "merge_strategy": "",
  "extra_features": [
    {
      "feature": "",
      "value": "",
      "complexity": "low|medium|high",
      "phase": "MVP|V1|V2"
    }
  ],
  "roadmap": {
    "MVP": [],
    "V1": [],
    "V2": []
  },
  "risks": [
    {
      "risk": "",
      "impact": "",
      "mitigation": ""
    }
  ]
}