# ShVars [![Build Status](https://travis-ci.org/svenfuchs/cl.svg?branch=master)](https://travis-ci.org/svenfuchs/cl)

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
