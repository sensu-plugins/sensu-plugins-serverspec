#Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

## [1.0.0] - 2016-09-25
### Changed
- Dependency on sensu-plugin changed from strict (= 1.2.0) to pessimistic (~> 1.2)
- Dependency on serverspec bumped from 2.24.2 to 2.24.3

### Removed
- Support for Ruby 1.9.3

### Added
- Support for Ruby 2.3

## [0.1.0] - 2015-11-10
### Added
- Support for Windows

### Changed
- Use fully qualified path of invoking Ruby (to handle cases when Ruby is not on the system path)
- Updated serverspec gem to 2.24.2

## [0.0.2] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

### Removed
- Remove JSON gem dep that is not longer needed with Ruby 1.9+

## 0.0.1 - 2015-07-04
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-serverspec/compare/1.0.0...HEAD
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-serverspec/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-serverspec/compare/0.0.2...0.1.0
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-serverspec/compare/0.0.1...0.0.2
