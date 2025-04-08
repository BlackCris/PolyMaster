
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

- ![ima321ge](https://github.com/user-attachments/assets/7a951816-b098-4909-89bd-7354d6b3f841)
- ![image](https://github.com/user-attachments/assets/03865a87-07a9-49aa-a564-118275435ffb)
- ![im12age](https://github.com/user-attachments/assets/feb4a5d6-2d6b-4ad9-8ed1-918fd25e80bb)
- ![im112age](https://github.com/user-attachments/assets/296e9661-cede-48f2-af0e-72264681e9a4)



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
