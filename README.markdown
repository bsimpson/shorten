# Description

In the spirit of VIM commands, shorten the word to the least number of letters while still being unambiguous. This came out of a conversation of how many letters we waste everyday compared to how many we save by using the best text editor ever made

# Example

If a word can be shortened, it is: `"quintessential" => "quintessent"`
If a word cannot be shortened, the entire word is used: `"the" => "the"`

# Usage
    require 'shorten.rb'
    shortener = Shorten.new
    shortener.shorten("quintessential") # => "quintessent"
    shortener.shorten_sentence("The expeditious brown omnivorous mammal leapfrogged over the lethargic canine") # => "the expeditious brown omnivoro mammal leapfrogge over the lethargic canine"
