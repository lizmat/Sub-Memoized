# Create the identification string for the capture to serve as key
my sub fingerprint(Capture:D $capture --> Str:D) {
    my str @parts = $capture.list.map: *<>.WHICH.Str;
    @parts.push('|');  # don't allow positionals to bleed into nameds
    for $capture.hash -> $pair {
        @parts.push( $pair.key );  # key is always a string with nameds
        @parts.push( $pair.value<>.WHICH.Str );
    }
    @parts.join('|')
}

# Perform the actual wrapping of the sub to have it memoized
my sub memoize(\r, \cache, &keyer --> Nil) {
    r.wrap(-> |c {
        my $key := keyer(c);
        cache.EXISTS-KEY($key)
          ?? cache.AT-KEY($key)
          !! cache.BIND-KEY($key,callsame);
    });
    r.WHAT.^set_name(r.^name ~ '(memoized)');
}

# Handle the "is memoized" / is memoized(Bool:D) cases
multi sub trait_mod:<is>(
  Sub:D  \r,
  Bool:D :$memoized!,
--> Nil) is export {
    memoize(r, {}, &fingerprint) if $memoized;
}

# Handle the "is memoized(my %h)" case
multi sub trait_mod:<is>(
  Sub:D      \r, 
  Hash:D     :$memoized!,
--> Nil) is export {
    memoize(r, $memoized<>, &fingerprint);
}

# Handle the "is memoized(&fingerprint)" case
multi sub trait_mod:<is>(
  Sub:D      \r, 
  Callable:D :$memoized!,
--> Nil) is export {
    memoize(r, {}, $memoized);
}

# Handle the "is memoized(my %h, &fingerprint)" case
multi sub trait_mod:<is>(
  Sub:D  \r, 
  List:D :$memoized!,
--> Nil) is export {
    memoize(r, $memoized[0]<>, $memoized[1] // &fingerprint);
}

# vim: expandtab shiftwidth=4
