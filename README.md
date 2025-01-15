[![Actions Status](https://github.com/lizmat/Sub-Memoized/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Sub-Memoized/actions) [![Actions Status](https://github.com/lizmat/Sub-Memoized/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Sub-Memoized/actions) [![Actions Status](https://github.com/lizmat/Sub-Memoized/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Sub-Memoized/actions)

NAME
====

Sub::Memoized - trait for memoizing calls to subroutines

SYNOPSIS
========

```raku
use Sub::Memoized;

sub a($a,$b) is memoized {
  # do some expensive calculation
}

sub b($a, $b) is memoized( my %cache ) {
  # do some expensive calculation with direct access to cache
}

use Hash::LRU;
sub c($a, $b) is memoized( my %cache is LRU( elements => 2048 ) ) {
  # do some expensive calculation, keep last 2048 results returned
}

sub d(Int:D $a, Int:D $b) is memoized({ "$_[0],$_[1]" }) {
  # do some expensive calculation with cheaper key maker
}

sub e(Str:D $a, Str:D $b) is memoized(my %cache, *.list.sort.join("'")) {
  # do some expensive calculation with direct access to cache
  # without making the order of the arguments matter
}
```

DESCRIPTION
===========

The `Sub::Memoized` distribution provides a `is memoized` trait on `Sub`routines as an easy way to cache calculations made by that subroutine (assuming a given set of input parameters will always produce the same result).

Optionally, one can specify an `Associative` that will serve as the cache. This allows later access to the generated results. Or you can specify a specially crafted hash, such as one made with [`Hash::LRU`](https://raku.land/zef:lizmat/Hash::LRU).

IDENTIFICATION KEY
==================

By default, the identification key used to lookup values in the cache, is built from the `.WHICH` values of **all** the arguments passed to the subroutine. This may not always be the fastest or best way to do this.

Therefore one can specify a `Callable` that will be called to generate the identification key, bypassing the default key maker. This can e.g. be used to create a more efficient key generator, or can be used to create a key generator with special properties, e.g. making the arguments commutative.

This `Callable` will be given a `Capture` and is expected to return something that can be used as a key in the `Associative` that has been (implicitely) specified (usually a string).

CAVEAT
======

Please note that if you do **not** use a store that is thread-safe, the memoization will **not** be thread-safe either. This is the default.

SEE ALSO
========

The experimental [`is cached`](https://docs.raku.org/routine/is%20cached) trait provides similar but more limited functionality.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Sub-Memoized . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2020, 2021, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

