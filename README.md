
# 🌐 PolyMaster - Coordinate & PolyZone Builder for FiveM

**PolyMaster** is a lightweight but powerful developer tool for FiveM, designed to simplify collecting world coordinates and creating PolyZone areas. Ideal for scripting, mapping, and zone definition with a real-time visual interface and intuitive controls.

---

### ✨ Features

- 🔥 Toggleable Coordinate Capture Mode (`/pz`)
- 📍 Real-time raycasting & visual marker display
- 🧭 Copy coordinates instantly:
  - `G` → Copy `vector4`
  - `Z` → Copy `vector3`
- 🧱 PolyZone Mode:
  - `L` → Toggle Poly Mode
  - `Z` → Add Poly Point
  - `G` → Undo Last Point
  - `E` → Save PolyZone (minZ/maxZ auto-detected)
- 🧾 Save directly into `list.lua` in **Lua-native format**
- 📦 Built-in `ox_lib` support: Notifications, Clipboard, TextUI
- ✅ Works with **Lua 5.4**

---

### 📸 Screenshots (Coming Soon)

> _Showcase of marker, lines, PolyZone drawing, and saved outputs..._

---

### 🚀 Installation

1. **Download or clone this repo:**

```bash
git clone https://github.com/yourname/PolyMaster.git
```

2. **Add to your `server.cfg`:**

```
ensure PolyMaster
```

3. **Dependencies:**
- Requires [ox_lib](https://github.com/overextended/ox_lib)
- Create the file `data/list.lua` and paste:

```lua
return {

}
```

---

### 🔧 Controls (Default)

| Key | Action |
|-----|--------|
| `/pz` | Toggle Coordinate Mode |
| `G` | Copy `vec4` / Undo Poly Point |
| `Z` | Copy `vec3` / Add Poly Point |
| `E` | Save Point / Save PolyZone |
| `L` | Enter / Exit PolyZone Mode |

---

### 📁 Output Format (Lua)

All data is saved to `data/list.lua` in a native, readable format:

```lua
return {
    {
        type = "point",
        name = "my_spot",
        vec3 = vector3(-50.0, 100.0, 70.0),
        vec4 = vector4(-50.0, 100.0, 70.0, 240.0),
        heading = 240.0,
        minZ = 69.0,
        maxZ = 71.0
    },
    {
        type = "polyzone",
        name = "cool_area",
        minZ = 42.1,
        maxZ = 44.5,
        points = {
            vector3(...),
            vector3(...),
            ...
        }
    }
}
```

---

### 👨‍💻 Author

**Developed by:** [BlackCris](https://github.com/BlackCris)  
**Version:** 1.0.0  
**License:** MIT

---

### 💡 Future Plans

- [ ] GUI-based coordinate editor
- [ ] Export to JSON for PolyZone WebEditor
- [ ] In-game preview of saved zones
- [ ] Optimized zone loader from list.lua

---

🧠 _Built for all serious FiveM developers._
