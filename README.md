# 🎖️ The Lost Front - Suite (ESP, Combat, Weapon & Staff Detector)

![Roblox](https://img.shields.io/badge/Roblox-The_Lost_Front-blue?style=for-the-badge&logo=roblox)
![Status](https://img.shields.io/badge/Status-Undetected-brightgreen?style=for-the-badge)
![Security](https://img.shields.io/badge/Protection-ChaCha20_CFF_Protected-purple?style=for-the-badge)

High-performance, feature-packed client suite for **The Lost Front (Roblox)**. Built with Rayfield UI library, zero-lag drawing routines, combat assistance, client-side weapon controllers, and real-time staff/moderator intrusion detection.

---

## ⚡ Quick Execution

Paste the following line into your executor (**Solara, Wave, Codex, Delta, Fluxus, Synapse, etc.**):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/kingofgetban-cmyk/TheLostFront/main/TheLostFront.lua"))()
```

---

## 🚀 Features

### 👤 Player ESP
- **2D Box & Skeleton Lines**: Accurate bone tracing across R15 joints.
- **Health Bar & Distance**: Real-time health calculation with dynamic green-to-red shading.
- **Weapon & Ammo Display**: Shows currently equipped weapon and magazine capacity.
- **Team Check & Color Coding**: Distinguishes teammates and hostile enemies automatically.

### 🛸 Drone ESP & Alerts
- **Drone Tracker**: Tracks active hostile and friendly drones with exact distance meters.
- **Proximity Alerts**: Visual audio-visual indicator when an enemy drone approaches your perimeter.

### 🎯 Combat Suite
- **Anti-Jitter Smooth Aim**: Uses mouse relative delta interpolation to prevent camera fighting.
- **Wall Check (Line of Sight)**: Raycasts through map obstacles so the aimbot never targets enemies hidden behind walls.
- **Target Stickiness**: Locks onto an enemy until eliminated or key released, preventing target-flipping.
- **TriggerBot**: Instant automatic firing when crosshair intersects an enemy hitbox.

### 🔫 Weapon Modifiers
- **No Recoil**: Completely eliminates vertical kick, horizontal roughness, and rotational camera shake.
- **No Spread (Laser Accuracy)**: Hooks bullet dispersion algorithms to ensure 100% pinpoint accuracy.
- **Rapid Fire**: Configurable fire rate cooldown slider (down to 0.01s).
- **Always Automatic**: Converts semi-automatic pistols and rifles into full-auto weapons.
- **Fast Bullet Speed**: Accelerates bullet velocity up to 10,000 studs/s.
- **No Bullet Drop (Zero Gravity)**: Removes bullet gravity drop for long-range engagements.
- **Factory Reset**: Single-click button to revert all weapon stats back to default.

### ⚙️ Settings & Security
- **Map & Server Info**: Displays Place ID, Server JobId, Match Time, and Player Count.
- **Moderator & Staff Detector**: Real-time scanner checking group ranks, admin attributes, and creator permissions.
- **Auto Leave on Staff Detect**: Optional fail-safe that automatically disconnects you if a moderator joins.
- **One-Click Rejoin & JobId Copy**: Effortless server management.

---

## 🔒 Security & Credits
- Source code is protected with multi-layered ChaCha20 stream cipher & Control Flow Flattening (CFF).
- Developed by **valexcryzer** & **MintraZERX**.
- Telegram: **@MintraZERX**
