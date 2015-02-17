## Sensu-Plugins-serverspec

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-serverspec.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-serverspec)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-serverspec.svg)](http://badge.fury.io/rb/sensu-plugins-serverspec)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-serverspec/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-serverspec)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-serverspec/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-serverspec)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-serverspec.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-serverspec)

## Functionality

## Files
 * bin/check-serverspec

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-serverspec -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-serverspec`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-serverspec' do
  options('--prerelease')
  version '0.0.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-serverspec' do
  options('--prerelease')
  version '0.0.1'
end
```

## Notes
