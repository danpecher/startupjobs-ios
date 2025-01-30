This is an unofficial iOS client for browsing [StartupJobs](https://www.startupjobs.cz/) listings. I wanted to be able to browse jobs while on the go and didn't like the mobile web experience. It's currently in early stages, checkout the [TODO](#wip-todo-list)

<img src="Screenshot.png" alt="App Screenshot" width="200"/>

This is a personal practice project, I'm not affiliated with StartupJobs.

Technologies used:
- [Tuist](https://tuist.dev/) for project setup & modules
- MVVM-C: UIKit navigation with SwiftUI views
- ~~[Quick](https://github.com/Quick/Quick) for testing~~ (Swift Testing for now)
- [Mocker](https://github.com/WeTransfer/Mocker) for request mocking (TBD)

## TODO
- [x]  Networking layer
- [x]  Basic list with infinite scroll
- [x]  Filters sheet
- [x]  Filter data
- [x]  Display active filters
- [ ]  Load dynamic filter values from api
- [ ]  Job detail
- [ ]  Group by date (Today, yesterday, etc.)
- [ ]  Search by keywords
- [ ]  Refresh data if stale (view x new jobs)
- [ ]  Full screen tiktok style scroll (experimental) – switch between list / fullscreen
- [ ]  Mark job as interested
- [ ]  My jobs tab
- [ ]  Mark all as seen
- [ ]  Save search
- [ ]  Select saved search
- [ ]  Delete saved search