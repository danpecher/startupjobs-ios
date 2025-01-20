This is an unofficial iOS client for browsing [StartupJobs](https://www.startupjobs.cz/) listings. I wanted to be able to browse jobs while on the go and didn't like the mobile web experience. 

This is a personal practice project, I'm not affiliated with StartupJobs.

Technologies used:
- [Tuist](https://tuist.dev/) for project setup
- MVVM-C: UIKit navigation with SwiftUI views
- [Quick](https://github.com/Quick/Quick) for testing
- [Mocker](https://github.com/WeTransfer/Mocker) for request mocking

WIP TODO list:
- [x]  Networking layer
- [ ]  Basic list with infinite scroll
- [ ]  Job detail
- [ ]  Group by date (Today, yesterday, etc.)
- [ ]  Filters sheet
- [ ]  Filter data
- [ ]  Display active filters
- [ ]  Search by keywords
- [ ]  Refresh data if stale (view x new jobs)
- [ ]  Full screen tiktok style scroll (experimental) – switch between list / fullscreen
- [ ]  Mark job as interested
- [ ]  My jobs tab
- [ ]  Mark all as seen
- [ ]  Save search
- [ ]  Select saved search
- [ ]  Delete saved search