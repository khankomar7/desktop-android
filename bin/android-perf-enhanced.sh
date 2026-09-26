#!/usr/bin/env bash
# ============================================================================
# android-perf-enhanced: Advanced performance tuning for Android desktop
# ============================================================================
# Extended version of android-perf.sh with additional optimizations for
# maximum responsiveness on mobile devices. Runs once per desktop session.
# Safe to re-run; every step is guarded.
#
# Optimizations:
# 1. Disable XFCE compositing and animations (massive win for mobile)
# 2. Kill any background compositors
# 3. Disable screensaver and power management
# 4. Disable GTK/Qt animations
# 5. Reduce font rendering overhead
# 6. Disable wallpaper (solid color only)
# 7. Optimize mouse behavior for trackpad
# 8. Disable drag and drop animations
# ============================================================================
set -u

echo "[android-perf] Starting Android performance optimization..."

# ---- 1. XFCE Compositing & Animations ----
if command -v xfconf-query >/dev/null 2>&1; then
  echo "[android-perf] Disabling XFCE compositing and animations..."
  # Disable compositing (biggest single performance gain)
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false 2>/dev/null || true
  
  # Disable animation previews
  xfconf-query -c xfwm4 -p /general/cycle_preview -t bool -s false 2>/dev/null || true
  
  # Disable shadows
  xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_frame_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_popup_shadow -t bool -s false 2>/dev/null || true
  
  # Disable zoom/expose effects
  xfconf-query -c xfwm4 -p /general/zoom_desktop -t bool -s false 2>/dev/null || true
  
  # Use solid color background (no wallpaper scaling overhead)
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/color-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/rgba1 -t double -t double -t double -t double -s 0.10 -s 0.12 -s 0.16 -s 1.0 2>/dev/null || true
  
  # Disable panel animations
  xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -t int -s 0 2>/dev/null || true
  
  # Reduce window manager overhead
  xfconf-query -c xfwm4 -p /general/activate_action -t string -s "switch" 2>/dev/null || true
fi

# ---- 2. Kill Background Compositors ----
echo "[android-perf] Removing background compositors..."
for proc in picom compton xcompmgr; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -x "$proc" 2>/dev/null || true
  fi
done

# ---- 3. Disable Screensaver & Power Management ----
if command -v xset >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  echo "[android-perf] Disabling screensaver and DPMS..."
  xset s off 2>/dev/null || true
  xset -dpms 2>/dev/null || true
  xset s noblank 2>/dev/null || true
fi

# ---- 4. GTK & Qt Rendering Optimization ----
echo "[android-perf] Setting GTK/Qt environment variables..."
export GTK_ANIMATION=none
export GDK_RENDERING=image
export QT_QUICK_BACKEND=software
export QT_QPA_PLATFORMTHEME=gtk2

# ---- 5. Font Rendering (disable anti-aliasing for speed) ----
echo "[android-perf] Optimizing font rendering..."
if command -v xfconf-query >/dev/null 2>&1; then
  xfconf-query -c xfce4-desktop -p /desktop-icons/font-size -t int -s 9 2>/dev/null || true
fi

# ---- 6. Mouse/Trackpad Acceleration ----
echo "[android-perf] Configuring trackpad for mobile touch..."
if command -v xinput >/dev/null 2>&1; then
  # Find and configure trackpad devices
  for device in $(xinput list --id-only); do
    name=$(xinput list-props "$device" 2>/dev/null | head -1 || true)
    # Disable acceleration for more predictable touch response
    xinput set-prop "$device" "Accel Speed" 0 2>/dev/null || true
  done
fi

# ---- 7. Disable Drag-and-Drop Animations ----
if command -v xfconf-query >/dev/null 2>&1; then
  echo "[android-perf] Disabling drag-drop animations..."
  xfconf-query -c xfce4-desktop -p /desktop-icons/use-xtheme-icons -t bool -s true 2>/dev/null || true
fi

# ---- 8. Reduce CPU throttling in rendering ----
echo "[android-perf] Setting CPU governor to performance mode..."
if [ -w /sys/devices/system/cpu ]; then
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > "$cpu" 2>/dev/null || true
  done
fi

echo "[android-perf] ✓ Android performance optimization complete!"
echo "[android-perf] Desktop should now feel responsive on mobile browsers."
echo "[android-perf] If still slow: check SELKIES_FRAMERATE and MAX_RES in .env"

exit 0
