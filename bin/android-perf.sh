#!/usr/bin/env bash
# android-perf: strip XFCE compositing/animation overhead for low-latency
# mobile streaming over Selkies. Runs once per desktop session via
# /etc/xdg/autostart/android-perf.desktop. Safe to re-run; every step is
# guarded so a missing binary never breaks login.
set -u

# 1. Disable xfwm4 compositing + animations (biggest win: stops re-encoding
#    every shadow/fade while switching windows on a phone).
if command -v xfconf-query >/dev/null 2>&1; then
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/cycle_preview -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_frame_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_popup_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/zoom_desktop -t bool -s false 2>/dev/null || true
  # Solid color background: wallpaper scaling costs CPU on every expose.
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/color-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/rgba1 -t double -t double -t double -t double -s 0.10 -s 0.12 -s 0.16 -s 1.0 2>/dev/null || true
  # No fade/hide animations on panels and desktop icons.
  xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -t int -s 0 2>/dev/null || true
fi

# 2. Kill any compositor that snuck in (picom/compton/xfwm4 --compositor).
for proc in picom compton; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -x "$proc" 2>/dev/null || true
  fi
done

# 3. Disable screensaver + DPMS blanking (a blanked stream still costs a
#    keyframe storm on wake for mobile clients).
if command -v xset >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xset s off 2>/dev/null || true
  xset -dpms 2>/dev/null || true
  xset s noblank 2>/dev/null || true
fi

# 4. Make GTK redraws cheap: no animations, no smooth scrolling.
export GTK_ANIMATION=none
export GDK_RENDERING=image
export QT_QUICK_BACKEND=software

exit 0
