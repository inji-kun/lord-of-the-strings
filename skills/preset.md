---
name: preset
description: Switch the active preset for all skills
---

<process>
1. Parse the user's argument. It will be one of:
   - A preset name like "triality" or "my-custom"
   - "null" or "none" to clear the active preset

2. **If the argument is "null" or "none":**
   - Write an empty string to `config/active-preset.txt` (clear the file).
   - Confirm: "Preset cleared. All skills now run in general-purpose mode."

3. **If the argument is a preset name:**
   - Construct the preset path: `config/presets/{argument}.md`
   - Write that path to `config/active-preset.txt`
   - Read `config/presets/{argument}.md` to verify it exists.

4. **If the preset file does not exist:**
   - Warn the user: "Preset file config/presets/{argument}.md not found."
   - List available presets by globbing `config/presets/*.md`.
   - Do NOT leave the broken path in active-preset.txt — revert it to its
     previous value or clear it.

5. **If the preset file exists:**
   - Confirm: "Preset switched to: {argument}"
   - Show the first 5 lines of the preset file so the user can verify.
</process>

<preset>
N/A — this is an infrastructure skill.
</preset>

<output>
- Confirmation message indicating the new active preset (or that it was cleared).
- First 5 lines of the preset file if one was activated.
- List of available presets if the requested one was not found.
</output>
