# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2024-06-03

### Changed

- `ControlRoom` constructor now uses a `Map<Type, Creator>` for controller registration instead of a `List`.
- Improved controller tracking with a static registry for better singleton management.

### Added

- Integrated logging for controller lifecycle events (initialization, access, disposal).

## [1.0.0] - 2024-06-02

### Added

- Initial release of the Control Room state management package.
- Implementation of `StateController` for managing business logic and state using Streams.
- Implementation of `ControlRoom` InheritedWidget for efficient dependency injection and controller lifecycle management.
- Implementation of `StateListener` for reactive UI rebuilding based on state changes.
- Comprehensive example project showcasing multi-controller management and cross-page state persistence.
- Professional documentation in README.md.
- Unit and widget tests for controllers and UI components.
