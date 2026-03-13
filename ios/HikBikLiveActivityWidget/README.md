# Live Activity Widget Extension

This folder contains the **Live Activity** UI for track recording (lock screen and Dynamic Island).

## Setup in Xcode

1. **Add Widget Extension target**
   - File → New → Target → **Widget Extension**
   - Product name: e.g. `HikBikLiveActivityWidget`
   - Check **Include Live Activity**
   - Uncheck "Include Configuration App Intent" if you don't need it.

2. **Add these files to the Widget target**
   - `TrackRecordingLiveActivityView.swift` (this folder)
   - From main app: `HikBik/Services/TrackRecordingLiveActivityAttributes.swift`  
     (Add to Widget target: select file → File Inspector → Target Membership → check the Widget target)

3. **Register the widget**
   - In the Widget Extension's `Bundle` (e.g. `HikBikLiveActivityWidgetBundle.swift`), add:
   ```swift
   @main
   struct HikBikLiveActivityWidgetBundle: WidgetBundle {
       var body: some Widget {
           TrackRecordingLiveActivityView()
       }
   }
   ```

4. **Main app**
   - The main app already uses `TrackRecordingLiveActivityManager` to start/update/end the activity.
   - No need to add the Widget Extension target as a dependency of the app; the app only uses ActivityKit to push updates.

## Behaviour

- **Recording**: Live Activity shows distance, time, elevation and updates in real time.
- **Paused**: Status shows "Paused" and icon turns orange.
- **Published**: Final state shows "Published", then the activity ends after 5 seconds (user sees success on lock screen).
