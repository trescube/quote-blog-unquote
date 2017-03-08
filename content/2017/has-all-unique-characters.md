title=Generatively Testing for All Unique Characters
date=2017-03-08
type=post
tags=generative testing, all unique characters
status=published
~~~~~~

Lately I've been going through [Cracking the Coding Interview](https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850/ref=sr_1_1?ie=UTF8&qid=1488990244&sr=8-1&keywords=cracking+the+coding+interview) and practicing generative testing approaches to some of the problems.  This will hopefully be the first in a number of posts about the problems found in that book.  I won't be posting solutions to the actual problems, but these posts will provide code and strategies for testing solutions that readers come up with.  

### The Problem

The problem in the book states: Implement an algorithm to determine if a string has all unique characters.  Presumably this algorithm returns `true` if the string has all unique characters and `false` otherwise.  For example, strings like 'abc' would return `true` and `aba` would return `false`.  

<!--break-->

### Generative Tests

In my environment, the method under test is named `isAllUniqueChars` and the tests utilize a library I wrote called [RandomStringBuilder](https://github.com/trescube/RandomStringBuilder) to generate random strings but any function that generates random strings will do.  

I fully admit that this is overkill for what is a relatively simple problem.  These tests are mainly for practice and illustration purposes.  

#### Tests for `true`

This test generates inputs that are known to contain all unique characters, an assertion we can make because of the usage of the  [`unique`](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/util/Collection.html#unique%28%29) collections method in groovy (if `unique` is broken then we have bigger things to worry about.)  We have to use `unique` because RandomStringBuilder is generating random strings and could very well contain duplicates.

```groovy
def "strings with all unique characters should return true"() {
    given:
    def randomStringBuilder = new RandomStringBuilder()
    def random = new Random()

    and: "a string of unique characters"
    def value = randomStringBuilder.atLeastOneAlphaNumeric().build().toCharArray().toList().unique().join()

    expect:
    isAllUniqueChars(value) == true

    where:
    i << (1..10)

}
```

I ran this locally and some of the generated inputs were:

* `A`
* `8RNg2`
* `1X0h`
* `4XucoNigHzF`
* `3yjdGO`
* `e5m`
* `KYSb2Tofd`

#### Tests for `false`

It's fairly easy to test the positive case by using built-in collections methods that guarantee uniqueness, but how do we generate strings that are known to have duplicate characters?  One simple way would be to append the generated value to itself, so `abc` becomes `abcabc`.  This approach may not cover all cases depending on your solution's algorithm, so the approach I took was to generate a random string, then splice 1 or more characters of the string back into itself at a random index.  That is, if `a` is selected from `abc`, the value could become `aabc`, `abac`, or `abca`.

```groovy
def "string with duplicate characters should return false"() {
    given:
    def randomStringBuilder = new RandomStringBuilder()
    def random = new Random()

    and: "a list of unique characters"
    def value = randomStringBuilder.atLeastOneAlphaNumeric().build().toCharArray().toList().unique()

    and: "1 or more duplicate characters spliced in at random indexes"
    (0..random.nextInt(10)+1).each({
        // find a random character from the string
        def c = value[random.nextInt(value.size())]

        // find a random index to splice the duplicate character into
        def idx = random.nextInt(value.size())

        // splice in the duplicate character
        value.add(idx, c)

    })

    expect:
    isAllUniqueChars(value.join()) == false

    where:
    i << (1..10)

}
```

I ran this locally and some of the generated inputs that will return `false` were:

* `jydiKvYdiyi`
* `JUmssPRPR9u`
* `BBBBBB` (in this case, the initial value was just `B` that got duplicated 5 times)
* `33232H333H`
* `i44Xi44Vyi4Xy`
* `tOZfCay3Qt5L7Q7y`
* `zWzvvvw99wf`
