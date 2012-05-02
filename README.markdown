# Description

In the spirit of VIM commands, shorten the word to the least number of letters while still being unambiguous. This came out of a conversation of how many letters we waste everyday compared to how many we save by using the best text editor ever made

# Example

If a word can be shortened, it is: `"quintessential" => "quintessent"`
If a word cannot be shortened, the entire word is used: `"the" => "the"`

# Usage

## Require the library
    require './shorten'

## Instantiate the class, and populate the dictionaries
    shorten = Shorten.new

## Shorten a single word
    word = shorten.word("quintessential").shorten # => "quintessent"
    word.class # => Shorten::Word
    word.truncated? # => true
    word.original # => "quintessential"

## Shorten an entire sentence
    shorten.sentence("The expeditious brown omnivorous mammal leapfrogged over the lethargic canine")
    # => "the expeditious brown omnivoro mammal leapfrogge over the lethargic canine"

## Encode words/sentences
Encoding suffixes shortened words with a \t character to indicate it was truncated. If you are just crazy enough, you can truncate and encode sentences as a poor man's compression algorithm.

    shorten.encode("The expeditious brown omnivorous mammal leapfrogged over the lethargic canine")
    # => "the expeditious brown omnivoro\t mammal leapfrogge\t over the lethargic canine"

## Decode encoded words/sentences
    shorten.decode("the expeditious brown omnivoro\t mammal leapfrogge\t over the lethargic canine")
    # => "The expeditious brown omnivorous mammal leapfrogged over the lethargic canine"
