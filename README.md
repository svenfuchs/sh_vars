# ShVars [![Build Status](https://travis-ci.org/svenfuchs/cl.svg?branch=master)](https://travis-ci.org/svenfuchs/cl) [![Code Climate](https://api.codeclimate.com/v1/badges/2c2c23d7103d193e72a2/maintainability)](https://codeclimate.com/github/svenfuchs/sh_vars)

A library for parsing shell environment variables.

## Installation

```
gem install sh_vars
```

## Usage

```
require 'sh_vars'

ShVars.parse('FOO=foo BAR="bar"')
# => [['FOO', foo], ['BAR', '"bar"']]
```
