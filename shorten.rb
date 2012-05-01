class Shorten
  DICT_PATH = '/usr/share/dict/words'
  DICT_LENGTH = `wc -l #{DICT_PATH}`

  def initialize
    a_through_z = ('a'..'z').to_a
    a_through_z.each {|x| instance_variable_set(:"@dict_#{x}", [])}
    File.open(DICT_PATH).each do |line|
      line.downcase!
      next unless a_through_z.include?(line[0])
      instance_variable_get(:"@dict_#{line[0]}").push(line.chomp)
    end
  end

  def shorten(word)
    word.downcase!
    (1..word.length).to_a.each do |x|
      prefix = word.slice(0, x)
      words_matching_prefix = Proc.new {|y| y[/^#{prefix}/]}
      matches = instance_variable_get(:"@dict_#{word[0]}").select(&words_matching_prefix)
      return prefix if matches.length <= 1
    end
    word
  end

  def shorten_sentence(sentence="the expeditious brown omnivorous mammal leapfrogged over the lethargic canine")
    word_lookup = Proc.new {|x| shorten(x) }
    sentence.split.map(&word_lookup).join(' ')
  end
end
